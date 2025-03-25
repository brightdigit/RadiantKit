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

  /// A view modifier that adapts an NSWindow delegate to a SwiftUI view.
  private struct NSWindowDelegateAdaptorModifier: ViewModifier {
    /// The container that manages the NSWindow delegate.
    let container: any NSWindowDelegateContainer
    /// The delegate that will be applied to the NSWindow.
    let delegate: any NSWindowDelegate

    /// Initializes the modifier with the container and delegate.
    ///
    /// - Parameters:
    ///   - container: The container that manages the NSWindow delegate.
    ///   - delegate: The delegate to be applied to the NSWindow.
    init(
      container: any NSWindowDelegateContainer,
      delegate: @autoclosure () -> any NSWindowDelegate
    ) {
      self.container = container
      if let windowDelegate = container.windowDelegate {
        self.delegate = windowDelegate
      } else {
        let newDelegate = delegate()
        print("Creating a New Window Delegate")
        self.delegate = newDelegate
        self.container.windowDelegate = newDelegate
      }
    }

    /// Applies the NSWindow delegate to the content view.
    ///
    /// - Parameter content: The content view to be modified.
    /// - Returns: The modified content view with the NSWindow delegate applied.
    func body(content: Content) -> some View {
      content.nsWindowAdaptor { window in
        assert(!self.delegate.isEqual(window?.delegate))
        assert(window != nil)
        window?.delegate = delegate
      }
    }
  }

  extension View {
    /// Adapts an NSWindow delegate to the current view.
    ///
    /// - Parameters:
    ///   - container: The container that manages the NSWindow delegate.
    ///   - delegate: The delegate to be applied to the NSWindow.
    /// - Returns: The modified view with the NSWindow delegate adaptor.
    public func nsWindowDelegateAdaptor(
      _ container: any NSWindowDelegateContainer,
      _ delegate: @autoclosure () -> any NSWindowDelegate
    ) -> some View {
      self.modifier(
        NSWindowDelegateAdaptorModifier(container: container, delegate: delegate())
      )
    }
  }

#endif
