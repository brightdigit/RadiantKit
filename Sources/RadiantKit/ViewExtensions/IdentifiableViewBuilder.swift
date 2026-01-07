//
//  IdentifiableViewBuilder.swift
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

  /// A result builder for creating `IdentifiableView` values.
  @MainActor
  @resultBuilder
  public enum IdentifiableViewBuilder {
    /// Constructs an array of `IdentifiableView` with a single element.
    ///
    /// - Parameter first: The view to be wrapped in an `IdentifiableView`.
    /// - Returns: An array containing a single `IdentifiableView` with an ID of
    /// 0.
    public static func buildPartialBlock(first: any View) -> [IdentifiableView] {
      [IdentifiableView(first, id: 0)]
    }

    /// Constructs an array of `IdentifiableView` by appending a new
    /// `IdentifiableView` to an existing array.
    ///
    /// - Parameters:
    ///   - accumulated: The existing array of `IdentifiableView`.
    ///   - next: The view to be wrapped in a new `IdentifiableView`.
    /// - Returns: A new array containing the existing `IdentifiableView` values
    /// plus a new `IdentifiableView` with an ID equal to the count of the
    /// existing array.
    public static func buildPartialBlock(accumulated: [IdentifiableView], next: any View)
      -> [IdentifiableView]
    {
      accumulated + [IdentifiableView(next, id: accumulated.count)]
    }

    /// Constructs an array of `IdentifiableView` with a single element.
    ///
    /// - Parameter first: The `IdentifiableView` to be included in the array.
    /// - Returns: An array containing the provided `IdentifiableView`.
    public static func buildPartialBlock(first: IdentifiableView) -> [IdentifiableView] {
      [first]
    }

    /// Constructs an array of `IdentifiableView` by appending a new
    /// `IdentifiableView` to an existing array.
    ///
    /// - Parameters:
    ///   - accumulated: The existing array of `IdentifiableView`.
    ///   - next: The `IdentifiableView` to be appended to the existing array.
    /// - Returns: A new array containing the existing `IdentifiableView` values
    /// plus the new `IdentifiableView`.
    public static func buildPartialBlock(
      accumulated: [IdentifiableView],
      next: IdentifiableView
    ) -> [IdentifiableView] {
      accumulated + [next]
    }
  }
#endif
