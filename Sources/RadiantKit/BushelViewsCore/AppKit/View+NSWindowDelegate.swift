//
//  View+NSWindowDelegate.swift
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

#if canImport(AppKit) && canImport(SwiftUI)
  import AppKit

  public import SwiftUI

  fileprivate struct NSWindowDelegateAdaptorModifier: ViewModifier {
    @Binding var binding: (any NSWindowDelegate)?
    let delegate: any NSWindowDelegate

    init(
      binding: Binding<(any NSWindowDelegate)?>,
      delegate: @autoclosure () -> any NSWindowDelegate
    ) {
      self._binding = binding
      self.delegate = binding.wrappedValue ?? delegate()

      #warning(
        "Issue 100 - We can't set binding here - Modifying state during view update, this will cause undefined behavior."
      )
      self.binding = self.delegate
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
      _ binding: Binding<(any NSWindowDelegate)?>,
      _ delegate: @autoclosure () -> any NSWindowDelegate
    ) -> some View {
      self.modifier(NSWindowDelegateAdaptorModifier(binding: binding, delegate: delegate()))
    }
  }
#endif
