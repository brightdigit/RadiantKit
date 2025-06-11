//
//  DocumentFile.swift
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

/// Represents a document file with a specific file type.
public struct DocumentFile<FileType: FileTypeSpecification>: Codable, Hashable, Sendable {
  /// The URL of the document file.
  public let url: URL

  /// Initializes a `DocumentFile` with the given URL.
  /// - Parameter url: The URL of the document file.
  public init(url: URL) { self.url = url }

  /// Hashes the `DocumentFile` instance into the given hasher.
  /// - Parameter hasher: The hasher to combine the URL with.
  public func hash(into hasher: inout Hasher) { hasher.combine(url) }
}

extension DocumentFile {
  /// Creates a `DocumentFile` instance from the given URL
  ///  if the file type matches the specified `FileType`.
  /// - Parameter url: The URL of the document file.
  /// - Returns: A `DocumentFile` instance if the file type matches, or `nil` if
  /// it does not.
  public static func documentFile(from url: URL) -> Self? {
    guard url.pathExtension == FileType.fileType.fileExtension else {
      return nil
    }
    return Self(url: url)
  }
}
