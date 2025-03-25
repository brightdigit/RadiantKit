//
//  OpenFileURLAction.swift
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

    /// A private environment key for storing the `OpenFileURLAction` in the
    /// environment.
    private struct OpenFileURLKey: EnvironmentKey, Sendable {
      typealias Value = OpenFileURLAction

      static let defaultValue: OpenFileURLAction = .default
    }

    /// A type alias for opening windows with URL values.
    public typealias OpenWindowURLAction = OpenWindowWithValueAction<URL>

    /// A type alias for opening files with URLs.
    public typealias OpenFileURLAction = OpenWindowURLAction

    /// Environment values extension that provides access to the file URL opening
    /// action.
    extension EnvironmentValues {
      /// The action used to open file URLs in the current environment.
      public var openFileURL: OpenFileURLAction {
        get { self[OpenFileURLKey.self] }
        set { self[OpenFileURLKey.self] = newValue }
      }
    }

    /// Scene extension that provides file URL opening functionality.
    extension Scene {
      /// Configures the scene to handle file URL opening.
      /// - Parameter closure: A closure that handles the URL opening action,
      /// receiving both the URL and the window action.
      /// - Returns: The modified scene with the file URL opening handler.
      public func openFileURL(
        _ closure: @escaping @Sendable @MainActor (URL, OpenWindowAction) -> Void
      ) -> some Scene { self.environment(\.openFileURL, .init(closure: closure)) }
    }

    /// View extension that provides file URL opening functionality.
    extension View {
      /// Configures the view to handle file URL opening.
      /// - Parameter closure: A closure that handles the URL opening action,
      /// receiving both the URL and the window action.
      /// - Returns: The modified view with the file URL opening handler.
      public func openFileURL(
        _ closure: @Sendable @escaping @MainActor (URL, OpenWindowAction) -> Void
      ) -> some View { self.environment(\.openFileURL, .init(closure: closure)) }
    }
  #endif
#endif
