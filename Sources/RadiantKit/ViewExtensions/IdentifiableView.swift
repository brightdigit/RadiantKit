//
//  IdentifiableView.swift
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

  /// A SwiftUI view that wraps another view and provides an identifier.
  @MainActor
  public struct IdentifiableView: Identifiable, View {
    /// The content view to be wrapped.
    private let content: any View

    /// The unique identifier for the view.
    public let id: Int

    /// The body of the `IdentifiableView`.
    public var body: some View {
      AnyView(content)
    }

    /// Initializes an `IdentifiableView` with the provided content view and identifier.
    /// - Parameters:
    ///   - content: The view to be wrapped.
    ///   - id: The unique identifier for the view.
    public init(_ content: any View, id: Int) {
      self.content = content
      self.id = id
    }

    /// Initializes an `IdentifiableView` with a closure that produces the content view and an identifier.
    /// - Parameters:
    ///   - content: A closure that produces the view to be wrapped.
    ///   - id: The unique identifier for the view.
    public init(_ content: @escaping () -> some View, id: Int) {
      self.content = content()
      self.id = id
    }
  }
#endif
