//
//  CodablePackageDocument.swift
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

#if canImport(SwiftUI)
  #if os(macOS) || os(iOS) || os(visionOS)
    public import Foundation

    public import SwiftUI

    public import UniformTypeIdentifiers

    public struct CodablePackageDocument<T: CodablePackage>: FileDocument {
      internal enum ReadError: Error { case missingConfigurationAtKey(String) }

      public static var readableContentTypes: [UTType] { T.readableContentTypes.map(UTType.init) }

      let configuration: T

      public init(configuration: T) { self.configuration = configuration }

      public init(configuration: ReadConfiguration) throws {
        let regularFileContents = configuration.file.fileWrappers?[T.configurationFileWrapperKey]?
          .regularFileContents
        guard let configJSONWrapperData = regularFileContents else {
          throw ReadError.missingConfigurationAtKey(T.configurationFileWrapperKey)
        }

        let configuration = try T.decoder.decode(T.self, from: configJSONWrapperData)
        self.init(configuration: configuration)
      }

      public func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let rootFileWrapper =
          configuration.existingFile ?? FileWrapper(directoryWithFileWrappers: [:])

        if let oldConfigJSONWrapper = rootFileWrapper.fileWrappers?[T.configurationFileWrapperKey] {
          rootFileWrapper.removeFileWrapper(oldConfigJSONWrapper)
        }

        let newConfigJSONData = try T.encoder.encode(self.configuration)
        let newConfigJSONWrapper = FileWrapper(regularFileWithContents: newConfigJSONData)
        newConfigJSONWrapper.preferredFilename = T.configurationFileWrapperKey
        rootFileWrapper.addFileWrapper(newConfigJSONWrapper)

        return rootFileWrapper
      }
    }

    extension CodablePackageDocument where T: InitializablePackage {
      public init() { self.init(configuration: .init()) }
    }
  #endif
#endif
