//
//  PreferredLayout.swift
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

  /// Represents a preferred layout for a view.
  public enum PreferredLayout {
    /// Represents a value with an associated update function.
    public struct Value<Value> {
      private let value: Value?

      fileprivate let update: (Value) -> Void

      /// Initializes a new `Value` instance with the given value and update
      /// function.
      ///
      /// - Parameters:
      ///   - value: The value to be stored.
      ///   - update: The update function to be called when the value changes.
      fileprivate init(value: Value?, update: @escaping (Value) -> Void) {
        self.value = value
        self.update = update
      }

      /// Returns the stored value, if any.
      public func get() -> Value? { value }
    }

    /// Represents a view that adapts its content based on a preferred layout.
    public struct View<Content: SwiftUI.View, ValueType>: SwiftUI.View {
      private let reduce: (ValueType, ValueType) -> ValueType
      private let content: (Value<ValueType>) -> Content
      @State private var value: ValueType?

      /// The body of the `View` struct.
      public var body: some SwiftUI.View {
        let valueType = Value(value: self.value) { newValue in
          let value = value ?? newValue
          self.value = reduce(value, newValue)
        }
        content(valueType)
      }

      /// Initializes a new `View` instance with the given initial value,
      /// reduction function, and content.
      ///
      /// - Parameters:
      ///   - initial: The initial value for the preferred layout.
      /// - reduce: A function that reduces two values of type `ValueType` into a
      /// single value.
      /// - content: A function that creates the content of the view based on the
      /// preferred layout value.
      public init(
        initial: ValueType? = nil,
        reduce: @escaping (ValueType, ValueType) -> ValueType,
        content: @escaping (Value<ValueType>) -> Content
      ) {
        self.reduce = reduce
        self.content = content
        self.value = initial
      }
    }
  }

  /// Extends the `PreferredLayout.View` struct with a convenience initializer
  /// when the `ValueType` is `Comparable`.
  extension PreferredLayout.View where ValueType: Comparable {
    /// Initializes a new `View` instance with the given content function, using
    /// `max` as the reduction function.
    ///
    /// - Parameter content: A function that creates the content of the view
    /// based on the preferred layout value.
    public init(content: @escaping (PreferredLayout.Value<ValueType>) -> Content) {
      self.init(reduce: max, content: content)
    }
  }

  /// Extends the `View` protocol with methods to apply a preferred layout to a
  /// view.
  extension View {
    /// Applies a preferred layout value to the view, using a clear background
    /// view.
    ///
    /// - Parameters:
    ///   - keyPath: The key path to the value in the `GeometryProxy`.
    ///   - valueType: The preferred layout value to apply.
    public func apply<V>(
      _ keyPath: KeyPath<GeometryProxy, V>,
      with valueType: PreferredLayout.Value<V>
    ) -> some View { self.apply(keyPath, with: valueType) { Color.clear } }

    /// Applies a preferred layout value to the view, with a custom background
    /// view.
    ///
    /// - Parameters:
    ///   - keyPath: The key path to the value in the `GeometryProxy`.
    ///   - valueType: The preferred layout value to apply.
    /// - backgroundView: A function that creates the background view for the
    /// preferred layout.
    public func apply<V>(
      _ keyPath: KeyPath<GeometryProxy, V>,
      with valueType: PreferredLayout.Value<V>,
      backgroundView: @escaping () -> some View
    ) -> some View {
      self.background(
        GeometryReader { geometry in
          backgroundView()
            .onAppear(perform: {
              valueType.update(geometry[keyPath: keyPath])
            })
        }
      )
    }
  }

#endif
