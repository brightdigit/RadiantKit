//
//  OpenWindowWithAction.swift
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
    import Foundation

    public import SwiftUI

    /// A type alias for opening windows without an associated value.
    public typealias OpenWindowWithAction = OpenWindowWithValueAction<Void>

    /// Extension providing functionality for opening windows without associated
    /// values.
    @MainActor
    extension OpenWindowWithAction {
      /// Creates a new window opening action with the specified closure.
      /// - Parameter closure: A closure that handles the window opening action.
      public init(closure: @escaping @Sendable @MainActor (OpenWindowAction) -> Void) {
        self.init { _, action in closure(action) }
      }

      /// Executes the window opening action with the specified window action.
      /// - Parameter openWidow: The window action to execute.
      @MainActor
      public func callAsFunction(with openWidow: OpenWindowAction) {
        closure((), openWidow)
      }
    }
  #endif
#endif
