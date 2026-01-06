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

#if canImport(SwiftUI)

  import Foundation
  import RadiantKit
  import SwiftUI
  import Testing

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

  // MARK: - Tests

  @MainActor
  internal struct AppStorageDateTests {
    // MARK: - Non-Optional Date Tests

    @Test
    internal func testNonOptionalDateStorage() async throws {
      guard let store = UserDefaults(suiteName: #function) else {
        Issue.record("Failed to create UserDefaults")
        return
      }
      defer { store.removePersistentDomain(forName: #function) }

      let testDate = Date(timeIntervalSince1970: 1_704_067_200)
      let storage = AppStorage(
        wrappedValue: testDate,
        for: TestDateStored.self,
        store: store
      )

      #expect(storage.wrappedValue == testDate)
    }

    @Test
    internal func testNonOptionalDateUpdate() async throws {
      guard let store = UserDefaults(suiteName: #function) else {
        Issue.record("Failed to create UserDefaults")
        return
      }
      defer { store.removePersistentDomain(forName: #function) }

      let initialDate = Date(timeIntervalSince1970: 1_704_067_200)
      var storage = AppStorage(
        wrappedValue: initialDate,
        for: TestDateStored.self,
        store: store
      )

      #expect(storage.wrappedValue == initialDate)

      let newDate = Date(timeIntervalSince1970: 1_735_689_600)
      storage.wrappedValue = newDate

      #expect(storage.wrappedValue == newDate)
      #expect(store.object(forKey: TestDateStored.key) != nil)
    }

    @Test
    internal func testNonOptionalDateWithReflectingKey() async throws {
      guard let store = UserDefaults(suiteName: #function) else {
        Issue.record("Failed to create UserDefaults")
        return
      }
      defer { store.removePersistentDomain(forName: #function) }

      let testDate = Date(timeIntervalSince1970: 1_704_067_200)
      let storage = AppStorage(
        wrappedValue: testDate,
        for: TestReflectingDateStored.self,
        store: store
      )

      #expect(storage.wrappedValue == testDate)

      let key = TestReflectingDateStored.key
      #expect(key.contains("TestReflectingDateStored"))
    }

    // MARK: - Optional Date Tests

    @Test
    internal func testOptionalDateStorageWithValue() async throws {
      guard let store = UserDefaults(suiteName: #function) else {
        Issue.record("Failed to create UserDefaults")
        return
      }
      defer { store.removePersistentDomain(forName: #function) }

      let testDate = Date(timeIntervalSince1970: 1_704_067_200)
      var storage = AppStorage(
        for: TestOptionalDateStored.self,
        store: store
      )

      #expect(storage.wrappedValue == nil)

      storage.wrappedValue = testDate

      #expect(storage.wrappedValue == testDate)
      #expect(store.object(forKey: TestOptionalDateStored.key) != nil)
    }

    @Test
    internal func testOptionalDateStorageWithNil() async throws {
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
    }

    @Test
    internal func testOptionalDateSetToNil() async throws {
      guard let store = UserDefaults(suiteName: #function) else {
        Issue.record("Failed to create UserDefaults")
        return
      }
      defer { store.removePersistentDomain(forName: #function) }

      let testDate = Date(timeIntervalSince1970: 1_704_067_200)
      var storage = AppStorage(
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
    }

    @Test
    internal func testOptionalDateWithReflectingKey() async throws {
      guard let store = UserDefaults(suiteName: #function) else {
        Issue.record("Failed to create UserDefaults")
        return
      }
      defer { store.removePersistentDomain(forName: #function) }

      let testDate = Date(timeIntervalSince1970: 1_704_067_200)
      var storage = AppStorage(
        for: TestReflectingOptionalDateStored.self,
        store: store
      )

      storage.wrappedValue = testDate
      #expect(storage.wrappedValue == testDate)

      let key = TestReflectingOptionalDateStored.key
      #expect(key.contains("TestReflectingOptionalDateStored"))
      #expect(store.object(forKey: key) != nil)
    }
  }

#endif
