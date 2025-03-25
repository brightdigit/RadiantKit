//
//  PageNavigationAvailability.swift
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

  /// A key that represents the availability of page navigation in the environment.
  private struct PageNavigationAvailabilityKey: EnvironmentKey, Sendable {
    /// The default value for page navigation availability, which is `.default`.
    static let defaultValue: PageNavigationAvailability = .default
  }

  /// An option set that represents the availability of page navigation.
  public struct PageNavigationAvailability: OptionSet, Sendable {
    /// The raw value type for the option set.
    public typealias RawValue = Int

    /// The default page navigation availability, which is `.none`.
    public static let `default`: PageNavigationAvailability = .none

    /// Indicates that no page navigation is available.
    public static let none: PageNavigationAvailability = .init()

    /// Indicates that navigation to the next page is available.
    public static let next: PageNavigationAvailability = .init(rawValue: 1)

    /// Indicates that navigation to the previous page is available.
    public static let previous: PageNavigationAvailability = .init(rawValue: 2)

    /// Indicates that navigation to both the previous and next pages is available.
    public static let both: PageNavigationAvailability = [previous, next]

    /// The raw value of the option set.
    public let rawValue: Int

    /// Initializes a `PageNavigationAvailability` instance with the given raw value.
    ///
    /// - Parameter rawValue: The raw value to initialize the option set with.
    public init(rawValue: RawValue) {
      assert(rawValue < 4)
      self.rawValue = rawValue
    }
  }

  extension EnvironmentValues {
    /// The availability of page navigation in the environment.
    public var pageNavigationAvailability: PageNavigationAvailability {
      get { self[PageNavigationAvailabilityKey.self] }
      set { self[PageNavigationAvailabilityKey.self] = newValue }
    }
  }

#endif
