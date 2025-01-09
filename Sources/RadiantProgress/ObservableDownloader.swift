//
//  ObservableDownloader.swift
//  RadiantKit
//
//  Created by Leo Dion.
//  Copyright © 2025 BrightDigit.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the “Software”), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#if canImport(Combine) && canImport(Observation)
  public import Combine

  public import Foundation

  fileprivate protocol DownloadObserver {
    func finishedDownloadingTo(_ location: URL)
    func progressUpdated(_ progress: DownloadUpdate)
    func didComplete(withError error: Error?)
  }

  private actor ObserverContainer: Sendable {
    private nonisolated(unsafe) var observer: DownloadObserver?

    nonisolated func setObserver(_ observer: DownloadObserver) {
      assert(self.observer == nil)
      self.observer = observer
    }

    nonisolated func on(_ closure: @escaping @Sendable (DownloadObserver) -> Void) {
      Task { await self.withObserver(closure) }
    }

    private func withObserver(_ closure: @escaping @Sendable (DownloadObserver) -> Void) {
      assert(self.observer != nil)
      guard let observer else { return }

      closure(observer)
    }
  }

  fileprivate final class DownloadDelegate: NSObject, URLSessionDownloadDelegate {
    let container = ObserverContainer()

    func setObserver(_ observer: DownloadObserver) { self.container.setObserver(observer) }

    func urlSession(
      _: URLSession,
      downloadTask _: URLSessionDownloadTask,
      didFinishDownloadingTo location: URL
    ) {
      let newLocation = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString).appendingPathExtension(location.pathExtension)
      do { try FileManager.default.copyItem(at: location, to: newLocation) }
      catch {
        container.on { observer in observer.didComplete(withError: error) }
        return
      }
      container.on { observer in observer.finishedDownloadingTo(newLocation) }
    }

    func urlSession(
      _: URLSession,
      downloadTask _: URLSessionDownloadTask,
      didWriteData _: Int64,
      totalBytesWritten: Int64,
      totalBytesExpectedToWrite: Int64
    ) {
      container.on { observer in
        observer.progressUpdated(
          .init(
            totalBytesWritten: totalBytesWritten,
            totalBytesExpectedToWrite: totalBytesExpectedToWrite
          )
        )
      }
    }

    func urlSession(_: URLSession, task _: URLSessionTask, didCompleteWithError error: (any Error)?)
    { container.on { observer in observer.didComplete(withError: error) } }
  }

  @Observable @MainActor public final class ObservableDownloader: DownloadObserver, Downloader {
    internal struct DownloadRequest {
      internal let downloadSourceURL: URL
      internal let destinationFileURL: URL
    }

    // swift-format-ignore: NeverUseImplicitlyUnwrappedOptionals
    @ObservationIgnored private var delegate: DownloadDelegate!

    public internal(set) var totalBytesWritten: Int64 = 0
    public internal(set) var totalBytesExpectedToWrite: Int64?

    // swift-format-ignore: NeverUseImplicitlyUnwrappedOptionals
    @ObservationIgnored internal private(set) var session: URLSession!

    internal let resumeDataSubject = PassthroughSubject<Data, Never>()
    internal var task: URLSessionDownloadTask?

    private var cancellables = [AnyCancellable]()
    internal let requestSubject = PassthroughSubject<DownloadRequest, Never>()
    internal let locationURLSubject = PassthroughSubject<URL, Never>()
    internal let downloadUpdate = PassthroughSubject<DownloadUpdate, Never>()
    private var completion: ((Result<Void, any Error>) -> Void)?

    private let formatter = ByteCountFormatter()

    public var prettyBytesWritten: String {
      formatter.string(from: .init(value: .init(totalBytesWritten), unit: .bytes))
    }

    public convenience init(
      totalBytesExpectedToWrite: (some BinaryInteger)?,
      configuration: URLSessionConfiguration? = nil,
      queue: OperationQueue? = nil
    ) {
      self.init(
        totalBytesExpectedToWrite: totalBytesExpectedToWrite,
        setupPublishers: .init(),
        configuration: configuration,
        queue: queue
      )
    }
    internal convenience init(
      totalBytesExpectedToWrite: (some BinaryInteger)?,
      setupPublishers: SetupPublishers,
      configuration: URLSessionConfiguration? = nil,
      queue: OperationQueue? = nil
    ) {
      self.init(
        totalBytesExpectedToWrite: totalBytesExpectedToWrite,
        setupPublishers: setupPublishers.callAsFunction(downloader:),
        configuration: configuration,
        queue: queue
      )
    }

    public init(
      totalBytesExpectedToWrite: (some BinaryInteger)?,
      setupPublishers: @escaping (ObservableDownloader) -> [AnyCancellable],
      configuration: URLSessionConfiguration? = nil,
      queue: OperationQueue? = nil
    ) {
      self.totalBytesExpectedToWrite = totalBytesExpectedToWrite.map(Int64.init(_:))

      let delegate = DownloadDelegate()
      self.session = URLSession(
        configuration: configuration ?? .default,
        delegate: delegate,
        delegateQueue: queue
      )

      self.delegate = delegate

      self.cancellables = setupPublishers(self)
    }

    func onCompletion(_ result: Result<Void, any Error>) {
      assert(completion != nil)
      completion?(result)
    }

    public func cancel() { task?.cancel() }

    public func begin(
      from downloadSourceURL: URL,
      to destinationFileURL: URL,
      _ completion: @escaping @Sendable (Result<Void, any Error>) -> Void
    ) {
      #warning("Requires Testing")
      self.delegate.setObserver(self)
      assert(self.completion == nil)
      self.completion = completion
      requestSubject.send(
        .init(downloadSourceURL: downloadSourceURL, destinationFileURL: destinationFileURL)
      )
    }

    nonisolated func finishedDownloadingTo(_ location: URL) {
      Task { @MainActor in self.finishedDownloadingToAsync(location) }
    }

    nonisolated func progressUpdated(_ progress: DownloadUpdate) {
      Task { @MainActor in self.progressUpdatedAsync(progress) }
    }

    nonisolated func didComplete(withError error: (any Error)?) {
      Task { @MainActor in self.didCompleteAsync(withError: error) }
    }

    func finishedDownloadingToAsync(_ location: URL) { locationURLSubject.send(location) }

    func progressUpdatedAsync(_ progress: DownloadUpdate) { self.downloadUpdate.send(progress) }

    func didCompleteAsync(withError error: (any Error)?) {
      guard let error else {
        // Handle success case.
        return
      }
      let userInfo = (error as NSError).userInfo
      if let resumeData = userInfo[NSURLSessionDownloadTaskResumeData] as? Data {
        resumeDataSubject.send(resumeData)
      }
    }
    deinit {
      MainActor.assumeIsolated {
        for cancellable in self.cancellables { cancellable.cancel() }
        self.cancellables.removeAll()
        self.session = nil
        self.task = nil
      }
    }
  }
#endif
