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

  @MainActor @Observable
  public final class DownloadOperation<ValueType: BinaryInteger & Sendable>:

    Identifiable, ProgressOperation, Sendable
  {
    private let download: Downloader
    private let sourceURL: URL
    private let destinationURL: URL

    public nonisolated var id: URL { sourceURL }

    public var currentValue: ValueType { .init(download.totalBytesWritten) }

    public var totalValue: ValueType? { download.totalBytesExpectedToWrite.map(ValueType.init(_:)) }

    #if canImport(Combine)
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
    public init(sourceURL: URL, destinationURL: URL, download: Downloader) {
      self.download = download
      self.sourceURL = sourceURL
      self.destinationURL = destinationURL
    }

    public func execute() async throws {
      try await withCheckedThrowingContinuation { continuation in
        self.download.begin(from: self.sourceURL, to: self.destinationURL) { result in
          continuation.resume(with: result)
        }
      }
    }
  }

#endif
