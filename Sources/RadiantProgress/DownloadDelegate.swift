//
//  DownloadDelegate.swift
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

import Foundation

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

/// The `DownloadDelegate` class is responsible for handling the download progress and completion of a URL session download task.
internal final class DownloadDelegate: NSObject, URLSessionDownloadDelegate {
  private let container = ObserverContainer()

  /// Sets the observer for the download delegate.
  ///
  /// - Parameter observer: The `DownloadObserver` instance to be set as the observer.
  internal func setObserver(_ observer: DownloadObserver) {
    self.container.setObserver(observer)
  }

  /// Called when the download task has finished downloading the file.
  ///
  /// - Parameters:
  ///   - _: The URL session that initiated the download task.
  ///   - downloadTask: The download task that has finished downloading.
  ///   - location: The temporary URL where the downloaded file is located.
  internal func urlSession(
    _: URLSession,
    downloadTask _: URLSessionDownloadTask,
    didFinishDownloadingTo location: URL
  ) {
    let newLocation = FileManager
      .default.temporaryDirectory
      .appendingPathComponent(UUID().uuidString)
      .appendingPathExtension(location.pathExtension)
    do {
      try FileManager.default.copyItem(at: location, to: newLocation)
    } catch {
      container.on { observer in observer.didComplete(withError: error) }
      return
    }
    container.on { observer in observer.finishedDownloadingTo(newLocation) }
  }

  /// Called periodically to report the progress of the download task.
  ///
  /// - Parameters:
  ///   - _: The URL session that initiated the download task.
  ///   - downloadTask: The download task that is reporting progress.
  ///   - _: The amount of data that has been written to the file.
  ///   - totalBytesWritten: The total number of bytes written to the file so far.
  ///   - totalBytesExpectedToWrite: The total number of bytes expected to be written to the file.
  internal func urlSession(
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

  /// Called when the download task has completed, either successfully or with an error.
  ///
  /// - Parameters:
  ///   - _: The URL session that initiated the download task.
  ///   - task: The download task that has completed.
  ///   - error: The error, if any, that occurred during the download.
  internal func urlSession(
    _: URLSession,
    task _: URLSessionTask,
    didCompleteWithError error: (any Error)?
  ) {
    container.on { observer in observer.didComplete(withError: error) }
  }
}
