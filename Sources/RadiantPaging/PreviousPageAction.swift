//
//  PreviousPageAction.swift
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

  /// A private struct that serves as the environment key for the `previousPage`
  /// environment value.
  private struct PreviousPageKey: EnvironmentKey, Sendable {
    /// The default value for the `previousPage` environment value.
    static let defaultValue: PreviousPageAction = .default
  }

  /// A type alias for the `PageAction` type, used to represent the action to
  /// take when navigating to the previous page.
  public typealias PreviousPageAction = PageAction

  extension EnvironmentValues {
    /// The action to take when navigating to the previous page.
    public var previousPage: PreviousPageAction {
      get { self[PreviousPageKey.self] }
      set { self[PreviousPageKey.self] = newValue }
    }
  }

#endif
