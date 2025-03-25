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

internal final class DownloadDelegate: NSObject, URLSessionDownloadDelegate {
  private let container = ObserverContainer()

  internal func setObserver(_ observer: DownloadObserver) {
    self.container.setObserver(observer)
  }

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

  internal func urlSession(
    _: URLSession,
    task _: URLSessionTask,
    didCompleteWithError error: (any Error)?
  ) {
    container.on { observer in observer.didComplete(withError: error) }
  }
}
