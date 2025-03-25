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

  /// An observable downloader class that observes download progress and provides a way to resume downloads.
  @Observable
  @MainActor
  public final class ObservableDownloader: DownloadObserver, Downloader {
    /// Represents a download request with a source URL and a destination file URL.
    internal struct DownloadRequest {
      /// The URL of the download source.
      internal let downloadSourceURL: URL
      /// The URL of the destination file.
      internal let destinationFileURL: URL
    }

    /// The delegate for the download process.
    @ObservationIgnored private var delegate: DownloadDelegate!

    /// The total number of bytes written so far.
    public internal(set) var totalBytesWritten: Int64 = 0

    /// The total number of bytes expected to be written.
    public internal(set) var totalBytesExpectedToWrite: Int64?

    /// The URL session used for the download.
    @ObservationIgnored internal private(set) var session: URLSession!

    /// A subject that publishes resume data when a download is interrupted.
    internal let resumeDataSubject = PassthroughSubject<Data, Never>()

    /// The current download task.
    internal var task: URLSessionDownloadTask?

    private var cancellables = [AnyCancellable]()
    internal let requestSubject = PassthroughSubject<DownloadRequest, Never>()
    internal let locationURLSubject = PassthroughSubject<URL, Never>()
    internal let downloadUpdate = PassthroughSubject<DownloadUpdate, Never>()
    private var completion: ((Result<Void, any Error>) -> Void)?

    private let formatter = ByteCountFormatter()

    /// A formatted string representing the total bytes written.
    public var prettyBytesWritten: String {
      formatter.string(from: .init(value: .init(totalBytesWritten), unit: .bytes))
    }

    /// Initializes a new `ObservableDownloader` instance.
    ///
    /// - Parameters:
    ///   - totalBytesExpectedToWrite: The total number of bytes expected to be written, or `nil` if unknown.
    ///   - configuration: The URL session configuration to use, or `nil` to use the default configuration.
    ///   - queue: The operation queue to use for the URL session, or `nil` to use the main queue.
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

    /// Initializes a new `ObservableDownloader` instance with custom publishers.
    ///
    /// - Parameters:
    ///   - totalBytesExpectedToWrite: The total number of bytes expected to be written, or `nil` if unknown.
    ///   - setupPublishers: A closure that sets up the internal publishers.
    ///   - configuration: The URL session configuration to use, or `nil` to use the default configuration.
    ///   - queue: The operation queue to use for the URL session, or `nil` to use the main queue.
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

    /// Initializes a new `ObservableDownloader` instance with custom publishers.
    ///
    /// - Parameters:
    ///   - totalBytesExpectedToWrite: The total number of bytes expected to be written, or `nil` if unknown.
    ///   - setupPublishers: A closure that sets up the internal publishers.
    ///   - configuration: The URL session configuration to use, or `nil` to use the default configuration.
    ///   - queue: The operation queue to use for the URL session, or `nil` to use the main queue.
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

    /// Calls the completion closure with the result of the download.
    internal func onCompletion(_ result: Result<Void, any Error>) {
      assert(completion != nil)
      completion?(result)
    }

    /// Cancels the current download task.
    public func cancel() { task?.cancel() }

    /// Begins a new download.
    ///
    /// - Parameters:
    ///   - downloadSourceURL: The URL of the download source.
    ///   - destinationFileURL: The URL of the destination file.
    ///   - completion: A closure that is called with the result of the download.
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
        .init(
          downloadSourceURL: downloadSourceURL,
          destinationFileURL: destinationFileURL
        )
      )
    }

    /// Notifies the observer that the download has finished.
    nonisolated internal func finishedDownloadingTo(_ location: URL) {
      Task { @MainActor in self.finishedDownloadingToAsync(location) }
    }

    /// Notifies the observer of download progress updates.
    nonisolated internal func progressUpdated(_ progress: DownloadUpdate) {
      Task { @MainActor in self.progressUpdatedAsync(progress) }
    }

    /// Notifies the observer that the download has completed, optionally with an error.
    nonisolated internal func didComplete(withError error: (any Error)?) {
      Task { @MainActor in self.didCompleteAsync(withError: error) }
    }

    private func finishedDownloadingToAsync(_ location: URL) {
      locationURLSubject.send(location)
    }

    private func progressUpdatedAsync(_ progress: DownloadUpdate) {
      self.downloadUpdate.send(progress)
    }

    private func didCompleteAsync(withError error: (any Error)?) {
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
