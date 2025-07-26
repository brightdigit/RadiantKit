//
//  OpenFilePanel.swift
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

#if canImport(AppKit) && canImport(SwiftUI)
  import AppKit

  import Foundation

  public import SwiftUI

  import UniformTypeIdentifiers

  /// A struct that represents an open file panel for a specific file type.
  @available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
  public struct OpenFilePanel<FileType: FileTypeSpecification>: Sendable {
    /// Initializes a new instance of the `OpenFilePanel` struct.
    public init() {}

    /// Initializes a new instance of the `OpenFilePanel` struct
    /// with a specific file type.
    ///
    /// - Parameter _: The type of the file to be selected.
    public init(_: FileType.Type) {}

    /// Calls the open file panel and
    ///  passes the selected file to the provided `OpenWindowAction`.
    ///
    /// - Parameter openWindow: The action to be performed with the selected
    /// file.
    @MainActor
    public func callAsFunction(with openWindow: OpenWindowAction) {
      let openPanel = NSOpenPanel()
      openPanel.allowedContentTypes = [UTType(fileType: FileType.fileType)]
      openPanel.isExtensionHidden = true
      openPanel.begin { response in
        Task { @MainActor in
          guard let fileURL = openPanel.url, response == .OK else {
            return
          }
          let libraryFile = DocumentFile<FileType>(url: fileURL)
          openWindow(value: libraryFile)
        }
      }
    }
  }

  @available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
  extension OpenWindowAction {
    /// Calls the `OpenFilePanel` with the provided file type
    /// and passes the selected file to the `OpenWindowAction`.
    ///
    /// - Parameter valueType: The type of the file to be selected.
    @MainActor
    public func callAsFunction(_ valueType: (some FileTypeSpecification).Type) {
      OpenFilePanel(valueType)(with: self)
    }
  }
#endif
