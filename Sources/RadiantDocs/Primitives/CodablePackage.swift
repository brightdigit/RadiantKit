//
//  CodablePackage.swift
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

/// A protocol that defines a package that is both Sendable and Codable.
public protocol CodablePackage: Sendable, Codable {
  /// The JSONDecoder to use for decoding the package.
  static var decoder: JSONDecoder { get }

  /// The JSONEncoder to use for encoding the package.
  static var encoder: JSONEncoder { get }

  /// The key used to access the configuration file wrapper.
  static var configurationFileWrapperKey: String { get }

  /// The file types that can be read by the package.
  static var readableContentTypes: [FileType] { get }
}

extension CodablePackage {
  /// Initializes a `CodablePackage` instance from the contents of a URL.
  ///
  /// - Parameter url: The URL to read the package data from.
  /// - Throws: Any errors that may occur during the initialization process.
  public init(contentsOf url: URL) throws {
    let data = try Data(
      contentsOf: url.appendingPathComponent(Self.configurationFileWrapperKey)
    )
    self = try Self.decoder.decode(Self.self, from: data)
  }
}
