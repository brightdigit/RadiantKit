//
//  AppStorageDateTests+Optional.swift
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

extension AppStorageDateTests {
  @Suite("Optional Date Storage Tests")
  @MainActor
  internal struct OptionalDateTests {
    @Test(.enabled(if: AppStorageDateTests.isAppStorageDateAvailable))
    internal func testOptionalDateStorageWithValue() async throws {
      #if canImport(SwiftUI)
        if #available(macOS 15.0, iOS 18.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *) {
          guard let store = UserDefaults(suiteName: #function) else {
            Issue.record("Failed to create UserDefaults")
            return
          }
          defer { store.removePersistentDomain(forName: #function) }

          let testDate = Date(timeIntervalSince1970: 1_704_067_200)
          let storage = AppStorage(
            for: TestOptionalDateStored.self,
            store: store
          )

          #expect(storage.wrappedValue == nil)

          storage.wrappedValue = testDate

          #expect(storage.wrappedValue == testDate)
          #expect(store.object(forKey: TestOptionalDateStored.key) != nil)
        } else {
          Issue.record("AppStorage Date support requires macOS 15.0+")
        }
      #else
        Issue.record("SwiftUI is not available on this platform")
      #endif
    }

    @Test(.enabled(if: AppStorageDateTests.isAppStorageDateAvailable))
    internal func testOptionalDateStorageWithNil() async throws {
      #if canImport(SwiftUI)
        if #available(macOS 15.0, iOS 18.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *) {
          guard let store = UserDefaults(suiteName: #function) else {
            Issue.record("Failed to create UserDefaults")
            return
          }
          defer { store.removePersistentDomain(forName: #function) }

          let storage = AppStorage(
            for: TestOptionalDateStored.self,
            store: store
          )

          #expect(storage.wrappedValue == nil)

          let retrievedValue = store.object(
            forKey: TestOptionalDateStored.key
          )
          #expect(retrievedValue == nil)
        } else {
          Issue.record("AppStorage Date support requires macOS 15.0+")
        }
      #else
        Issue.record("SwiftUI is not available on this platform")
      #endif
    }

    @Test(.enabled(if: AppStorageDateTests.isAppStorageDateAvailable))
    internal func testOptionalDateSetToNil() async throws {
      #if canImport(SwiftUI)
        if #available(macOS 15.0, iOS 18.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *) {
          guard let store = UserDefaults(suiteName: #function) else {
            Issue.record("Failed to create UserDefaults")
            return
          }
          defer { store.removePersistentDomain(forName: #function) }

          let testDate = Date(timeIntervalSince1970: 1_704_067_200)
          let storage = AppStorage(
            for: TestOptionalDateStored.self,
            store: store
          )

          storage.wrappedValue = testDate
          #expect(storage.wrappedValue == testDate)

          storage.wrappedValue = nil
          #expect(storage.wrappedValue == nil)

          let retrievedValue = store.object(
            forKey: TestOptionalDateStored.key
          )
          #expect(retrievedValue == nil)
        } else {
          Issue.record("AppStorage Date support requires macOS 15.0+")
        }
      #else
        Issue.record("SwiftUI is not available on this platform")
      #endif
    }

    @Test(.enabled(if: AppStorageDateTests.isAppStorageDateAvailable))
    internal func testOptionalDateWithReflectingKey() async throws {
      #if canImport(SwiftUI)
        if #available(macOS 15.0, iOS 18.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *) {
          guard let store = UserDefaults(suiteName: #function) else {
            Issue.record("Failed to create UserDefaults")
            return
          }
          defer { store.removePersistentDomain(forName: #function) }

          let testDate = Date(timeIntervalSince1970: 1_704_067_200)
          let storage = AppStorage(
            for: TestReflectingOptionalDateStored.self,
            store: store
          )

          storage.wrappedValue = testDate
          #expect(storage.wrappedValue == testDate)

          let key = TestReflectingOptionalDateStored.key
          #expect(key.contains("TestReflectingOptionalDateStored"))
          #expect(store.object(forKey: key) != nil)
        } else {
          Issue.record("AppStorage Date support requires macOS 15.0+")
        }
      #else
        Issue.record("SwiftUI is not available on this platform")
      #endif
    }
  }
}
