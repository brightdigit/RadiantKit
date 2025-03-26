//
//  SingleWindowView.swift
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

  /// A default view value for a `SingleWindowView`.
  /// - Note: This struct is marked as `periphery:ignore` to exclude it from code
  /// analysis.
  public struct SingleWindowViewValue<ViewType: SingleWindowView>: DefaultableViewValue {
    /// The default value for the `SingleWindowViewValue`.
    public static var `default`: Self { .init() }

    private init() {}
  }

  /// A protocol that defines a single window view.
  @MainActor
  public protocol SingleWindowView: View {
    /// The type of the view value.
    associatedtype Value: DefaultableViewValue = SingleWindowViewValue<Self>
    /// Initializes a new instance of the `SingleWindowView`.
    init()
  }

  extension SingleWindowView {
    /// Initializes a new instance of the `SingleWindowView` with a binding to
    /// the view value.
    /// - Parameter value: A binding to the view value.
    public init(_ value: Binding<Value>) {
      self.init()
    }
  }

  #if os(macOS) || os(iOS) || os(visionOS)
    extension WindowGroup {
      /// Initializes a new instance of the `WindowGroup` with a single window
      /// view.
      /// - Parameter _: The type of the `SingleWindowView`.
      @MainActor
      public init<V: SingleWindowView>(singleOf _: V.Type)
      where Content == PresentedWindowContent<V.Value, V> {
        self.init { value in
          V(value)
        } defaultValue: {
          V.Value.default
        }
      }
    }
  #else
    extension WindowGroup {
      /// Initializes a new instance of the `WindowGroup` with a single window
      /// view.
      /// - Parameter _: The type of the `SingleWindowView`.
      @MainActor
      public init(singleOf _: Content.Type) where Content: SingleWindowView {
        self.init {
          Content()
        }
      }
    }
  #endif
#endif
