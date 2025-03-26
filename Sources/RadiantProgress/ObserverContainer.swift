//
//  ObserverContainer.swift
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

internal actor ObserverContainer {
  /// The download observer.
  private nonisolated(unsafe) var observer: DownloadObserver?

  /// Sets the download observer.
  ///
  /// - Parameter observer: The download observer to set.
  nonisolated internal func setObserver(_ observer: DownloadObserver) {
    assert(self.observer == nil)
    self.observer = observer
  }

  /// Executes the provided closure with the download observer.
  ///
  /// - Parameter closure: The closure to execute with the download observer.
  nonisolated internal func on(
    _ closure: @escaping @Sendable (DownloadObserver) -> Void
  ) {
    Task { await self.withObserver(closure) }
  }

  /// Executes the provided closure with the download observer.
  ///
  /// - Parameter closure: The closure to execute with the download observer.
  private func withObserver(
    _ closure: @escaping @Sendable (DownloadObserver) -> Void
  ) {
    assert(self.observer != nil)
    guard let observer else {
      return
    }

    closure(observer)
  }
}
