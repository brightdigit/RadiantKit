//
//  NSWindowAdaptorModifier.swift
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

import Foundation

#if canImport(SwiftUI)
  public import SwiftUI

  #if canImport(AppKit)
    import AppKit

    fileprivate struct NSWindowAdaptorHostingView: NSViewRepresentable {
      #warning(
        """
        Issue 100
        We need a way to specific when the callback is called and whether it should be.
        """
      )
      private var callback: (NSWindow?) -> Void

      fileprivate init(callback: @escaping (NSWindow?) -> Void) { self.callback = callback }

      fileprivate func makeNSView(context _: Self.Context) -> NSView {
        let view = NSView()
        DispatchQueue.main.async { [weak view] in self.callback(view?.window) }
        view.setFrameSize(.zero)
        view.isHidden = true
        view.frame = CGRect.zero
        return view
      }

      fileprivate func updateNSView(_: NSView, context _: Context) {}
    }

    fileprivate struct NSWindowAdaptorModifier: ViewModifier {
      private var callback: (NSWindow?) -> Void

      fileprivate init(callback: @escaping (NSWindow?) -> Void) { self.callback = callback }

      fileprivate func body(content: Content) -> some View {
        content.overlay(NSWindowAdaptorHostingView(callback: callback).frame(width: 0, height: 0))
      }
    }

    extension View {
      public func nsWindowAdaptor(_ callback: @escaping (NSWindow?) -> Void) -> some View {
        self.modifier(NSWindowAdaptorModifier(callback: callback))
      }
    }
  #else
    extension View {
      public func nsWindowAdaptor(_: @escaping (Any?) -> Void) -> some View { self }
    }
  #endif

#endif