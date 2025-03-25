//
//  OpenWindowWithValueAction.swift
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

    /// A struct that represents an action to open a window with a given value.
    public struct OpenWindowWithValueAction<ValueType: Sendable>: Sendable {
      /// The default instance of `OpenWindowWithValueAction`.
      public static var `default`: Self {
        .init { value, action in defaultClosure(value, with: action) }
      }

      internal let closure: @Sendable @MainActor (ValueType, OpenWindowAction) -> Void

      /// Initializes a new instance of `OpenWindowWithValueAction`.
      ///
      /// - Parameter closure: The closure to be executed when the action is called.
      public init(
        closure: @escaping @MainActor @Sendable (ValueType, OpenWindowAction) -> Void
      ) {
        self.closure = closure
      }

      private static func defaultClosure(_: ValueType, with _: OpenWindowAction) {
        assertionFailure()
      }

      /// Calls the action with the given value and open window action.
      ///
      /// - Parameters:
      ///   - value: The value to be passed to the action.
      ///   - openWidow: The open window action to be performed.
      @MainActor
      public func callAsFunction(_ value: ValueType, with openWidow: OpenWindowAction) {
        closure(value, openWidow)
      }
    }
  #endif
#endif
