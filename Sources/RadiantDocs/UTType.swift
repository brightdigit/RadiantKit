//
//  UTType.swift
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

#if canImport(UniformTypeIdentifiers)
  public import UniformTypeIdentifiers

  extension UTType {
    /// Initializes a `UTType` instance from a `FileType`.
    ///
    /// - Parameter fileType: The `FileType` to use for initialization.
    public init(fileType: FileType) {
      if fileType.isOwned {
        self.init(exportedAs: fileType.utIdentifier)
      } else {
        // swiftlint:disable force_unwrapping
        // swift-format-ignore: NeverForceUnwrap
        self.init(fileType.utIdentifier)!
        // swiftlint:enable force_unwrapping
      }
    }

    /// Returns an array of `UTType` instances
    /// that are allowed content types for the given `FileType`.
    ///
    /// - Parameter fileType: The `FileType` to get allowed content types for.
    /// - Returns: An array of `UTType` instances that are allowed content types
    /// for the given `FileType`.
    public static func allowedContentTypes(for fileType: FileType) -> [UTType] {
      var types = [UTType]()

      if fileType.isOwned { types.append(.init(exportedAs: fileType.utIdentifier)) }

      if let fileExtensionType =
        fileType.fileExtension.flatMap({ UTType(filenameExtension: $0) })
      {
        types.append(fileExtensionType)
      }

      if let utIdentified = UTType(fileType.utIdentifier) { types.append(utIdentified) }

      return types
    }

    /// Returns an array of `UTType` instances
    /// that are allowed content types for the given `FileType` instances.
    ///
    /// - Parameter fileTypes: The `FileType` instances to get allowed content
    /// types for.
    /// - Returns: An array of `UTType` instances that are allowed content types
    /// for the given `FileType` instances.
    public static func allowedContentTypes(for fileTypes: FileType...) -> [UTType] {
      fileTypes.flatMap(allowedContentTypes(for:))
    }
  }

  extension FileType {
    /// Initializes a `FileType` instance from a `URL`.
    ///
    /// - Parameter url: The `URL` to initialize the `FileType` from.
    @Sendable
    public init?(url: URL) {
      guard let utType = UTType(filenameExtension: url.pathExtension) else {
        return nil
      }
      self.init(stringLiteral: utType.identifier)
    }
  }
#endif
