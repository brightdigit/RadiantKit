//
//  AppStorage+AppStored.swift
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

  public import Foundation

  public import SwiftUI

  extension AppStorage {
    /// Initializes an `AppStorage` instance with a wrapped value and an
    /// `AppStored` type.
    ///
    /// - Parameters:
    ///   - wrappedValue: The initial value for the app-stored value.
    ///   - type: The `AppStored` type to associate with the app-stored value.
    ///   - store: The `UserDefaults` instance to use for storing the app-stored
    /// value. If `nil`, the standard `UserDefaults` will be used.
    /// - Requires:
    ///   - `AppStoredType.Value` must be `Bool` and `Value` must be `Bool`.
    public init<AppStoredType: AppStored>(
      wrappedValue: Value,
      for type: AppStoredType.Type,
      store: UserDefaults? = nil
    ) where AppStoredType.Value == Bool, Value == Bool {
      self.init(wrappedValue: wrappedValue, type.key, store: store)
    }

    /// Initializes an `AppStorage` instance with a wrapped value and an
    /// `AppStored` type.
    ///
    /// - Parameters:
    ///   - wrappedValue: The initial value for the app-stored value.
    ///   - type: The `AppStored` type to associate with the app-stored value.
    /// - store: The `UserDefaults` instance to use for storing the app-stored
    /// value. If `nil`, the standard `UserDefaults` will be used.
    /// - Requires:
    ///   - `AppStoredType.Value` must be `Int` and `Value` must be `Int`.
    public init<AppStoredType: AppStored>(
      wrappedValue: Value,
      for type: AppStoredType.Type,
      store: UserDefaults? = nil
    ) where AppStoredType.Value == Int, Value == Int {
      self.init(wrappedValue: wrappedValue, type.key, store: store)
    }

    /// Initializes an `AppStorage` instance with a wrapped value and an
    /// `AppStored` type.
    ///
    /// - Parameters:
    ///   - wrappedValue: The initial value for the app-stored value.
    ///   - type: The `AppStored` type to associate with the app-stored value.
    /// - store: The `UserDefaults` instance to use for storing the app-stored
    /// value. If `nil`, the standard `UserDefaults` will be used.
    /// - Requires:
    ///   - `AppStoredType.Value` must be `Double` and `Value` must be `Double`.
    public init<AppStoredType: AppStored>(
      wrappedValue: Value,
      for type: AppStoredType.Type,
      store: UserDefaults? = nil
    ) where AppStoredType.Value == Double, Value == Double {
      self.init(wrappedValue: wrappedValue, type.key, store: store)
    }

    /// Initializes an `AppStorage` instance with a wrapped value and an
    /// `AppStored` type.
    ///
    /// - Parameters:
    ///   - wrappedValue: The initial value for the app-stored value.
    ///   - type: The `AppStored` type to associate with the app-stored value.
    /// - store: The `UserDefaults` instance to use for storing the app-stored
    /// value. If `nil`, the standard `UserDefaults` will be used.
    /// - Requires:
    ///   - `AppStoredType.Value` must be `String` and `Value` must be `String`.
    public init<AppStoredType: AppStored>(
      wrappedValue: Value,
      for type: AppStoredType.Type,
      store: UserDefaults? = nil
    ) where AppStoredType.Value == String, Value == String {
      self.init(wrappedValue: wrappedValue, type.key, store: store)
    }

    /// Initializes an `AppStorage` instance with a wrapped value and an
    /// `AppStored` type.
    ///
    /// - Parameters:
    ///   - wrappedValue: The initial value for the app-stored value.
    ///   - type: The `AppStored` type to associate with the app-stored value.
    /// - store: The `UserDefaults` instance to use for storing the app-stored
    /// value. If `nil`, the standard `UserDefaults` will be used.
    /// - Requires:
    ///   - `AppStoredType.Value` must be `URL` and `Value` must be `URL`.
    public init<AppStoredType: AppStored>(
      wrappedValue: Value,
      for type: AppStoredType.Type,
      store: UserDefaults? = nil
    ) where AppStoredType.Value == URL, Value == URL {
      self.init(wrappedValue: wrappedValue, type.key, store: store)
    }

    /// Initializes an `AppStorage` instance with a wrapped value and an
    /// `AppStored` type.
    ///
    /// - Parameters:
    ///   - wrappedValue: The initial value for the app-stored value.
    ///   - type: The `AppStored` type to associate with the app-stored value.
    /// - store: The `UserDefaults` instance to use for storing the app-stored
    /// value. If `nil`, the standard `UserDefaults` will be used.
    /// - Requires:
    ///   - `AppStoredType.Value` must be `Data` and `Value` must be `Data`.
    public init<AppStoredType: AppStored>(
      wrappedValue: Value,
      for type: AppStoredType.Type,
      store: UserDefaults? = nil
    ) where AppStoredType.Value == Data, Value == Data {
      self.init(wrappedValue: wrappedValue, type.key, store: store)
    }

    /// Initializes an `AppStorage` instance with a wrapped value and an
    /// `AppStored` type.
    ///
    /// - Parameters:
    ///   - wrappedValue: The initial value for the app-stored value.
    ///   - type: The `AppStored` type to associate with the app-stored value.
    /// - store: The `UserDefaults` instance to use for storing the app-stored
    /// value. If `nil`, the standard `UserDefaults` will be used.
    /// - Requires:
    ///   - `AppStoredType.Value` must be `Date` and `Value` must be `Date`.
    @available(macOS 15.0, iOS 18.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
    public init<AppStoredType: AppStored>(
      wrappedValue: Value,
      for type: AppStoredType.Type,
      store: UserDefaults? = nil
    ) where AppStoredType.Value == Date, Value == Date {
      self.init(wrappedValue: wrappedValue, type.key, store: store)
    }

    /// Initializes an `AppStorage` instance with a wrapped value and an
    /// `AppStored` type.
    ///
    /// - Parameters:
    ///   - wrappedValue: The initial value for the app-stored value.
    ///   - type: The `AppStored` type to associate with the app-stored value.
    /// - store: The `UserDefaults` instance to use for storing the app-stored
    /// value. If `nil`, the standard `UserDefaults` will be used.
    /// - Requires:
    /// - `AppStoredType.Value` must be `Value` and `Value` must be
    /// `RawRepresentable` with a `RawValue` of `Int`.
    public init<AppStoredType: AppStored>(
      wrappedValue: Value,
      for type: AppStoredType.Type,
      store: UserDefaults? = nil
    ) where AppStoredType.Value == Value, Value: RawRepresentable, Value.RawValue == Int {
      self.init(wrappedValue: wrappedValue, type.key, store: store)
    }

    /// Initializes an `AppStorage` instance with a wrapped value and an
    /// `AppStored` type.
    ///
    /// - Parameters:
    ///   - wrappedValue: The initial value for the app-stored value.
    ///   - type: The `AppStored` type to associate with the app-stored value.
    /// - store: The `UserDefaults` instance to use for storing the app-stored
    /// value. If `nil`, the standard `UserDefaults` will be used.
    /// - Requires:
    /// - `AppStoredType.Value` must be `Value` and `Value` must be
    /// `RawRepresentable` with a `RawValue` of `String`.
    public init<AppStoredType: AppStored>(
      wrappedValue: Value,
      for type: AppStoredType.Type,
      store: UserDefaults? = nil
    )
    where
      AppStoredType.Value == Value,
      Value: RawRepresentable,
      Value.RawValue == String {
      self.init(wrappedValue: wrappedValue, type.key, store: store)
    }
  }
#endif
