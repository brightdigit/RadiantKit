//
//  NextPageAction.swift
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

  /// A private struct representing a key for the next page action in the environment.
  private struct NextPageKey: EnvironmentKey, Sendable {
    /// The default value for the next page action.
    fileprivate static let defaultValue: NextPageAction = .default
  }

  /// A struct representing a page action.
  public struct PageAction: Sendable {
    /// The default page action that throws an assertion failure.
    internal static let `default`: PageAction = .init { assertionFailure() }

    /// The function to be executed when the page action is called.
    private let pageFunction: @Sendable @MainActor () -> Void

    /// Initializes a new page action with the given function.
    /// - Parameter pageFunction: The function to be executed when the page action is called.
    internal init(_ pageFunction: @Sendable @MainActor @escaping () -> Void) {
      self.pageFunction = pageFunction
    }

    /// Executes the page function on the main actor.
    @MainActor
    public func callAsFunction() { pageFunction() }
  }

  /// An alias for the `NextPageAction` type.
  public typealias NextPageAction = PageAction

  extension EnvironmentValues {
    /// The next page action in the environment.
    public var nextPage: NextPageAction {
      get { self[NextPageKey.self] }
      set { self[NextPageKey.self] = newValue }
    }
  }
#endif
