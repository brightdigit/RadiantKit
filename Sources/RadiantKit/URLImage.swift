//
//  URLImage.swift
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

  public import SwiftUI

  /// A SwiftUI view that displays an image from a local file.
  public struct URLImage: View {
    /// The path to the local file containing the image.
    private let path: String

    public var body: some View {
      Group {
        #if os(iOS) || os(watchOS) || os(tvOS)
          /// If the image can be loaded from the file path, display it and scale it to fit the available space.
          if let image = UIImage(contentsOfFile: path) {
            Image(uiImage: image).resizable().scaledToFit()
          }
        #elseif os(macOS)
          /// If the image can be loaded from the file path, display it and scale it to fit the available space.
          if let image = NSImage(contentsOfFile: path) {
            Image(nsImage: image).resizable().scaledToFit()
          }
        #endif
      }
    }

    /// Initializes a `URLImage` with the contents of a URL.
    /// - Parameter url: The URL of the local file containing the image.
    public init(contentsOf url: URL) {
      assert(url.isFileURL)
      self.init(contentsOfFile: url.path)
    }

    /// Initializes a `URLImage` with the contents of a file path.
    /// - Parameter path: The file path of the local file containing the image.
    public init(contentsOfFile path: String) {
      self.path = path
    }
  }
#endif
