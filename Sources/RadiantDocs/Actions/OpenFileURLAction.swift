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

    private struct OpenFileURLKey: EnvironmentKey, Sendable {
      typealias Value = OpenFileURLAction

      static let defaultValue: OpenFileURLAction = .default
    }

    public typealias OpenWindowURLAction = OpenWindowWithValueAction<URL>

    public typealias OpenFileURLAction = OpenWindowURLAction

    extension EnvironmentValues {
      public var openFileURL: OpenFileURLAction {
        get { self[OpenFileURLKey.self] }
        set { self[OpenFileURLKey.self] = newValue }
      }
    }

    extension Scene {
      public func openFileURL(
        _ closure: @escaping @Sendable @MainActor (URL, OpenWindowAction) -> Void
      ) -> some Scene { self.environment(\.openFileURL, .init(closure: closure)) }
    }

    @available(*, deprecated, message: "Use on Scene only.") extension View {
      public func openFileURL(
        _ closure: @Sendable @escaping @MainActor (URL, OpenWindowAction) -> Void
      ) -> some View { self.environment(\.openFileURL, .init(closure: closure)) }
    }
  #endif
#endif
