//
//  InitializablePackage.swift
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

public protocol InitializablePackage: CodablePackage { init() }

extension InitializablePackage {
  public typealias Options = InitializablePackageOptions
  @discardableResult public static func createAt(
    _ fileURL: URL,
    using encoder: JSONEncoder,
    options: Options = .none
  ) throws -> Self {
    let library = self.init()
    try FileManager.default.createDirectory(
      at: fileURL,
      withIntermediateDirectories: options.withIntermediateDirectoriesIsEnabled
    )
    let metadataJSONPath = fileURL.appendingPathComponent(self.configurationFileWrapperKey)
    let data = try encoder.encode(library)
    try data.write(to: metadataJSONPath, options: .init(options: options))
    return library
  }
}
