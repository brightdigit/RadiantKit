//
//  OpenAnyFilePanel.swift
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

  public struct OpenAnyFilePanel {
    let fileTypes: [FileType]

    internal init(fileTypes: [FileType]) {
      assert(!fileTypes.isEmpty)
      self.fileTypes = fileTypes
    }

    @MainActor public func callAsFunction(
      with openFileURL: OpenFileURLAction,
      using openWindow: OpenWindowAction
    ) {
      let openPanel = NSOpenPanel()
      openPanel.allowedContentTypes = fileTypes.map(UTType.init(fileType:))
      openPanel.isExtensionHidden = true
      openPanel.begin { response in
        guard let fileURL = openPanel.url, response == .OK else { return }
        openFileURL(fileURL, with: openWindow)
      }
    }
  }

  extension OpenFileURLAction {
    @MainActor public func callAsFunction(
      ofFileTypes fileTypes: [FileType],
      using openWindow: OpenWindowAction
    ) { OpenAnyFilePanel(fileTypes: fileTypes).callAsFunction(with: self, using: openWindow) }
  }

#endif
