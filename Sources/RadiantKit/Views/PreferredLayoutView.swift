//
//  PreferredLayoutView.swift
//  RadiantKit
//
//  Created by Leo Dion.
//  Copyright © 2024 BrightDigit.
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

  public enum PreferredLayout {
    public struct Value<Value> {
      private let value: Value?

      fileprivate let update: (Value) -> Void

      fileprivate init(value: Value?, update: @escaping (Value) -> Void) {
        self.value = value
        self.update = update
      }

      public func get() -> Value? { value }
    }

    public struct View<Content: SwiftUI.View, ValueType>: SwiftUI.View {
      let reduce: (ValueType, ValueType) -> ValueType
      let content: (Value<ValueType>) -> Content
      @State private var value: ValueType?

      public var body: some SwiftUI.View {
        let valueType = Value(value: self.value) { newValue in
          let value = value ?? newValue
          self.value = reduce(value, newValue)
        }
        content(valueType)
      }

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
  @available(*, deprecated, renamed: "PreferredLayout.View") public typealias PreferredLayoutView =
    PreferredLayout.View

  extension PreferredLayout.View where ValueType: Comparable {
    public init(content: @escaping (PreferredLayout.Value<ValueType>) -> Content) {
      self.init(reduce: max, content: content)
    }
  }

  extension View {
    public func apply<V>(
      _ keyPath: KeyPath<GeometryProxy, V>,
      with valueType: PreferredLayout.Value<V>
    ) -> some View { self.apply(keyPath, with: valueType) { Color.clear } }

    public func apply<V>(
      _ keyPath: KeyPath<GeometryProxy, V>,
      with valueType: PreferredLayout.Value<V>,
      backgroundView: @escaping () -> some View
    ) -> some View {
      self.background(
        GeometryReader { geometry in
          backgroundView().onAppear(perform: { valueType.update(geometry[keyPath: keyPath]) })
        }
      )
    }
  }
#endif
