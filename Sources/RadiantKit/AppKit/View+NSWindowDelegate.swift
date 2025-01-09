//
//  View+NSWindowDelegate.swift
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

#if canImport(AppKit) && canImport(SwiftUI)
  import AppKit
  public import SwiftUI

  fileprivate struct NSWindowDelegateAdaptorModifier: ViewModifier {
    let container: any NSWindowDelegateContainer
    let delegate: any NSWindowDelegate

    init(
      container: any NSWindowDelegateContainer,
      delegate: @autoclosure () -> any NSWindowDelegate
    ) {
      self.container = container
      if let windowDelegate = container.windowDelegate {
        self.delegate = windowDelegate
      }
      else {
        let newDelegate = delegate()
        print("Creating a New Window Delegate")
        self.delegate = newDelegate
        self.container.windowDelegate = newDelegate
      }
    }

    func body(content: Content) -> some View {
      content.nsWindowAdaptor { window in
        assert(!self.delegate.isEqual(window?.delegate))
        assert(window != nil)
        window?.delegate = delegate
      }
    }
  }

  extension View {
    public func nsWindowDelegateAdaptor(
      _ container: any NSWindowDelegateContainer,
      _ delegate: @autoclosure () -> any NSWindowDelegate
    ) -> some View {
      self.modifier(NSWindowDelegateAdaptorModifier(container: container, delegate: delegate()))
    }
  }
#endif
