//
//  NewFilePanel.swift
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

  /// A struct that represents a new file panel for a specific file type.
  public struct NewFilePanel<FileType: InitializableFileTypeSpecification>: Sendable {
    /// Initializes a new instance of `NewFilePanel`.
    public init() {}

    /// Initializes a new instance of `NewFilePanel` with a specified file type.
    ///
    /// - Parameter _: The type of file to be created.
    public init(_: FileType.Type) {}

    /// Presents a new file panel and opens a window with the created file.
    ///
    /// - Parameter openWindow: The action to be performed when a new file is
    /// created.
    @MainActor
    public func callAsFunction(with openWindow: OpenWindowAction) {
      let openPanel = NSSavePanel()
      openPanel.allowedContentTypes = [UTType(fileType: FileType.fileType)]
      openPanel.isExtensionHidden = true
      openPanel.begin { response in
        guard let fileURL = openPanel.url, response == .OK else {
          return
        }
        let value: FileType.WindowValueType
        do {
          value = try FileType.createAt(fileURL)
        } catch {
          openPanel.presentError(error)
          return
        }
        openWindow(value: value)
      }
    }
  }

  extension OpenWindowAction {
    /// Presents a new file panel for a specified file type and
    /// opens a window with the created file.
    ///
    /// - Parameter valueType: The type of file to be created.
    @MainActor
    public func callAsFunction(
      newFileOf valueType: (some InitializableFileTypeSpecification).Type
    ) {
      NewFilePanel(valueType)(with: self)
    }
  }
#endif
