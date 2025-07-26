//
//  DownloadOperation.swift
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

#if canImport(Observation)
  public import Foundation
  public import Observation

  #if canImport(FoundationNetworking)
    public import FoundationNetworking
  #endif

  /// A download operation that downloads data from a source URL to a destination
  /// URL.
  @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
  @MainActor
  @Observable
  public final class DownloadOperation<ValueType: BinaryInteger & Sendable>: Identifiable,
    ProgressOperation {
    private let download: Downloader
    private let sourceURL: URL
    private let destinationURL: URL

    /// The unique identifier for the download operation, which is the source
    /// URL.
    public nonisolated var id: URL { sourceURL }

    /// The current value of the download progress, represented as a `ValueType`.
    public var currentValue: ValueType { .init(download.totalBytesWritten) }

    /// The total value of the download progress, represented as a `ValueType`,
    /// or `nil` if the total bytes expected to write is unknown.
    public var totalValue: ValueType? {
      download.totalBytesExpectedToWrite.map(ValueType.init(_:))
    }

    #if canImport(Combine)
      /// Initializes a new `DownloadOperation` instance.
      /// - Parameters:
      ///   - sourceURL: The URL from which the data should be downloaded.
      /// - destinationURL: The URL to which the downloaded data should be
      /// written.
      /// - totalBytesExpectedToWrite: The total number of bytes expected to be
      /// written, or `nil` if unknown.
      /// - configuration: The `URLSessionConfiguration` to use for the download,
      /// or `nil` to use the default configuration.
      /// - queue: The `OperationQueue` to use for the download, or `nil` to use
      /// the default queue.
      public init(
        sourceURL: URL,
        destinationURL: URL,
        totalBytesExpectedToWrite: ValueType?,
        configuration: URLSessionConfiguration? = nil,
        queue: OperationQueue? = nil
      ) {
        assert(!sourceURL.isFileURL)
        assert(totalBytesExpectedToWrite != nil)
        self.sourceURL = sourceURL
        self.destinationURL = destinationURL
        self.download = ObservableDownloader(
          totalBytesExpectedToWrite: totalBytesExpectedToWrite,
          configuration: configuration,
          queue: queue
        )
      }
    #endif

    /// Initializes a new `DownloadOperation` instance.
    /// - Parameters:
    ///   - sourceURL: The URL from which the data should be downloaded.
    /// - destinationURL: The URL to which the downloaded data should be written.
    ///   - download: The `Downloader` instance to use for the download.
    public init(sourceURL: URL, destinationURL: URL, download: Downloader) {
      self.download = download
      self.sourceURL = sourceURL
      self.destinationURL = destinationURL
    }

    /// Executes the download operation asynchronously.
    /// - Throws: Any errors that occur during the download.
    public func execute() async throws {
      try await withCheckedThrowingContinuation { continuation in
        self.download.begin(from: self.sourceURL, to: self.destinationURL) { result in
          continuation.resume(with: result)
        }
      }
    }
  }
#endif
