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

  // periphery:ignore
  public struct SingleWindowViewValue<ViewType: SingleWindowView>: DefaultableViewValue {
    public static var `default`: Self { .init() }

    private init() {}
  }

  @MainActor public protocol SingleWindowView: View {
    associatedtype Value: DefaultableViewValue = SingleWindowViewValue<Self>
    init()
  }

  extension SingleWindowView { public init(_: Binding<Value>) { self.init() } }

  #if os(macOS) || os(iOS) || os(visionOS)
    extension WindowGroup {
      @MainActor public init<V: SingleWindowView>(singleOf _: V.Type)
      where Content == PresentedWindowContent<V.Value, V> {
        self.init { value in
          V(value)
        } defaultValue: {
          V.Value.default
        }
      }
    }
  #endif
#endif
