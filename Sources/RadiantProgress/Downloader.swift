//
//  Downloader.swift
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

public import Foundation

#if canImport(FoundationNetworking)
  public import FoundationNetworking
#endif

/// A protocol that defines the interface for a downloader.
@MainActor
public protocol Downloader {
  /// The total number of bytes written.
  var totalBytesWritten: Int64 { get }

  /// The total number of bytes expected to be written, or `nil` if unknown.
  var totalBytesExpectedToWrite: Int64? { get }

  /// Begins a download from the specified source URL to the specified destination file URL.
  ///
  /// - Parameters:
  ///   - downloadSourceURL: The URL to download from.
  ///   - destinationFileURL: The URL to download to.
  ///   - completion: A completion handler that is called with the result of the download operation.
  func begin(
    from downloadSourceURL: URL,
    to destinationFileURL: URL,
    _ completion: @escaping @Sendable (Result<Void, any Error>) -> Void
  )
}
