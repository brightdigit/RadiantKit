//
//  Button.swift
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

  extension Button {
    /// Initializes a `Button` with an `OpenURLAction` and a `URL`.
    ///
    /// - Parameters:
    /// - openURL: The `OpenURLAction` to be performed when the button is
    /// pressed.
    ///   - url: The `URL` to be opened when the button is pressed.
    /// - label: A closure that returns the view to be used as the button's
    /// label.
    public init(_ openURL: OpenURLAction, _ url: URL, @ViewBuilder _ label: () -> Label) {
      self.init(action: { openURL.callAsFunction(url) }, label: label)
    }

    /// Initializes a `Button` with a localized string key, an `OpenURLAction`,
    /// and a `URL`.
    ///
    /// - Parameters:
    ///   - titleKey: The localized string key to be used as the button's title.
    /// - openURL: The `OpenURLAction` to be performed when the button is
    /// pressed.
    ///   - url: The `URL` to be opened when the button is pressed.
    public init(_ titleKey: LocalizedStringKey, _ openURL: OpenURLAction, _ url: URL)
    where Label == Text {
      self.init(openURL, url) { Text(titleKey) }
    }
  }

#endif
