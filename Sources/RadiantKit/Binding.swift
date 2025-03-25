//
//  Binding.swift
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

  import Foundation

  public import SwiftUI

  extension Binding {
    /// Transforms the value of the `Binding` using the provided `get` and `set`
    /// functions.
    ///
    /// - Parameters:
    /// - get: A closure that transforms the value of the `Binding` to a
    /// different type.
    /// - set: A closure that transforms a value of a different type back to the
    /// original type of the `Binding`.
    /// - Returns: A new `Binding` with the transformed value.
    @MainActor
    public func map<T>(
      to get: @escaping @Sendable (Value) -> T,
      from set: @escaping @Sendable (T) -> Value
    ) -> Binding<T> {
      .init {
        get(self.wrappedValue)
      } set: {
        self.wrappedValue = set($0)
      }
    }
  }
#endif
