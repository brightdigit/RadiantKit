//
//  AppStorageDateTests.swift
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
import RadiantKit
import Testing

#if canImport(SwiftUI)
  import SwiftUI
#endif

// MARK: - Test Types

internal enum TestDateStored: AppStored {
  internal typealias Value = Date
  internal static let keyType: KeyType = .describing
}

internal enum TestOptionalDateStored: AppStored {
  internal typealias Value = Date?
  internal static let keyType: KeyType = .describing
}

internal enum TestReflectingDateStored: AppStored {
  internal typealias Value = Date
  internal static let keyType: KeyType = .reflecting
}

internal enum TestReflectingOptionalDateStored: AppStored {
  internal typealias Value = Date?
  internal static let keyType: KeyType = .reflecting
}

// MARK: - Test Suite

internal enum AppStorageDateTests {
  #if canImport(SwiftUI)
    internal static var isAppStorageDateAvailable: Bool {
      if #available(macOS 15.0, iOS 18.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *) {
        return true
      } else {
        return false
      }
    }
  #else
    internal static var isAppStorageDateAvailable: Bool {
      false
    }
  #endif
}
