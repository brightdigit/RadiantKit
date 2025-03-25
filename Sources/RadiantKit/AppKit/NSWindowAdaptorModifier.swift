//
//  NSWindowAdaptorModifier.swift
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

import Foundation

#if canImport(SwiftUI)
  public import SwiftUI

  #if canImport(AppKit)
    import AppKit

    /// A private struct that provides a `NSViewRepresentable` implementation
    /// to create an `NSView` that can be used to access the underlying `NSWindow`.
    private struct NSWindowAdaptorHostingView: NSViewRepresentable {
      /// A closure that will be called with
      /// the `NSWindow` associated with the created `NSView`.
      private var callback: (NSWindow?) -> Void

      /// Initializes the `NSWindowAdaptorHostingView` with a callback closure.
      /// - Parameter callback: A closure that will be called with the `NSWindow` associated with the created `NSView`.
      fileprivate init(callback: @escaping (NSWindow?) -> Void) {
        self.callback = callback
      }

      /// Creates the `NSView` that will be used to access the underlying `NSWindow`.
      /// - Parameter context: The context provided by the SwiftUI framework.
      /// - Returns: An `NSView` instance.
      fileprivate func makeNSView(context _: Self.Context) -> NSView {
        let view = NSView()
        DispatchQueue.main.async { [weak view] in self.callback(view?.window) }
        view.setFrameSize(.zero)
        view.isHidden = true
        view.frame = CGRect.zero
        return view
      }

      /// Updates the `NSView` if necessary.
      /// - Parameters:
      ///   - nsView: The `NSView` to be updated.
      ///   - context: The context provided by the SwiftUI framework.
      fileprivate func updateNSView(_: NSView, context _: Context) {}
    }

    /// A private struct that provides a `ViewModifier` implementation to add the `NSWindowAdaptorHostingView` to a `View`.
    private struct NSWindowAdaptorModifier: ViewModifier {
      /// A closure that will be called with the `NSWindow` associated with the created `NSView`.
      private var callback: (NSWindow?) -> Void

      /// Initializes the `NSWindowAdaptorModifier` with a callback closure.
      /// - Parameter callback: A closure that will be called with the `NSWindow` associated with the created `NSView`.
      fileprivate init(callback: @escaping (NSWindow?) -> Void) {
        self.callback = callback
      }

      /// Applies the `NSWindowAdaptorHostingView` to the content `View`.
      /// - Parameter content: The content `View` to be modified.
      /// - Returns: The modified `View`.
      fileprivate func body(content: Content) -> some View {
        content.overlay(
          NSWindowAdaptorHostingView(callback: callback)
            .frame(width: 0, height: 0)
        )
      }
    }

    extension View {
      /// Adds an `NSWindowAdaptorModifier` to the `View`, which provides access to the underlying `NSWindow`.
      /// - Parameter callback: A closure that will be called with the `NSWindow` associated with the created `NSView`.
      /// - Returns: The modified `View`.
      public func nsWindowAdaptor(_ callback: @escaping (NSWindow?) -> Void) -> some View {
        self.modifier(NSWindowAdaptorModifier(callback: callback))
      }
    }
  #else
    extension View {
      /// Adds a no-op `nsWindowAdaptor` modifier to the `View`.
      /// - Parameter callback: A closure that will be called with `Any?`, but does nothing.
      /// - Returns: The original `View`.
      public func nsWindowAdaptor(_: @escaping (Any?) -> Void) -> some View { self }
    }
  #endif
#endif
