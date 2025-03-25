//
//  DismissParameters.swift
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
public import RadiantKit

/// Provides information about a dismissal event, including the current page
/// index and ID, and the type of dismissal action.
public struct DismissParameters {
  #if canImport(SwiftUI)
    /// The identifier for a view in SwiftUI.
    public typealias PageID = IdentifiableView.ID
  #else
    /// The identifier for a page in a non-SwiftUI context.
    public typealias PageID = Int
  #endif

  /// Represents the different types of dismissal actions.
  public enum Action {
    /// The previous page was dismissed.
    case previous
    /// The next page was dismissed.
    case next
    /// The dismissal was cancelled.
    case cancel
  }

  /// The current page index.
  public let currentPageIndex: Int

  /// The current page ID.
  public let currentPageID: PageID?

  /// The type of dismissal action.
  public let action: Action
}
