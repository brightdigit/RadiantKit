//
//  FileType.swift
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

/// Represents a file type with
///  a Uniform Type Identifier (UTI), ownership status, and optional file extension.
public struct FileType: Hashable, ExpressibleByStringLiteral, Sendable {
  /// The type alias for the string literal initializer.
  public typealias StringLiteralType = String

  /// The Uniform Type Identifier (UTI) for the file type.
  public let utIdentifier: String

  /// A boolean indicating whether the file type is owned.
  public let isOwned: Bool

  /// The optional file extension associated with the file type.
  public let fileExtension: String?

  /// Initializes a `FileType` instance with the specified UTI, ownership status,
  /// and optional file extension.
  ///
  /// - Parameters:
  ///   - utIdentifier: The Uniform Type Identifier (UTI) for the file type.
  ///   - isOwned: A boolean indicating whether the file type is owned.
  ///   - fileExtension: The optional file extension associated with the file type.
  public init(utIdentifier: String, isOwned: Bool, fileExtension: String? = nil) {
    self.utIdentifier = utIdentifier
    self.isOwned = isOwned
    self.fileExtension = fileExtension
  }

  /// Initializes a `FileType` instance with the specified UTI,
  /// and sets the ownership status to `false`.
  ///
  /// - Parameter utIdentifier: The Uniform Type Identifier (UTI) for the file type.
  public init(stringLiteral utIdentifier: String) {
    self.init(utIdentifier: utIdentifier, isOwned: false)
  }

  /// Creates a `FileType` instance with the specified UTI, ownership status set to `true`, and the given file extension.
  ///
  /// - Parameters:
  ///   - utIdentifier: The Uniform Type Identifier (UTI) for the file type.
  ///   - fileExtension: The file extension associated with the file type.
  /// - Returns: A `FileType` instance with
  /// the specified UTI, ownership status set to `true`, and the given file extension.
  public static func exportedAs(_ utIdentifier: String, _ fileExtension: String) -> FileType {
    .init(utIdentifier: utIdentifier, isOwned: true, fileExtension: fileExtension)
  }
}
