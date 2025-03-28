//
//  AppStorage+DefaultWrapped.swift
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
    /// Initializes an `AppStorage` instance for a `Bool` type.
    ///
    /// - Parameters:
    ///   - type: The type of the stored value.
    /// - store: The `UserDefaults` instance to use, or `nil` to use the standard
    /// `UserDefaults`.
    public init<AppStoredType: DefaultWrapped>(
      for type: AppStoredType.Type,
      store: UserDefaults? = nil
    ) where AppStoredType.Value == Bool, Value == Bool {
      self.init(wrappedValue: AppStoredType.default, type.key, store: store)
    }

    /// Initializes an `AppStorage` instance for an `Int` type.
    ///
    /// - Parameters:
    ///   - type: The type of the stored value.
    /// - store: The `UserDefaults` instance to use, or `nil` to use the standard
    /// `UserDefaults`.
    public init<AppStoredType: DefaultWrapped>(
      for type: AppStoredType.Type,
      store: UserDefaults? = nil
    ) where AppStoredType.Value == Int, Value == Int {
      self.init(wrappedValue: AppStoredType.default, type.key, store: store)
    }

    /// Initializes an `AppStorage` instance for a `Double` type.
    ///
    /// - Parameters:
    ///   - type: The type of the stored value.
    /// - store: The `UserDefaults` instance to use, or `nil` to use the standard
    /// `UserDefaults`.
    public init<AppStoredType: DefaultWrapped>(
      for type: AppStoredType.Type,
      store: UserDefaults? = nil
    ) where AppStoredType.Value == Double, Value == Double {
      self.init(wrappedValue: AppStoredType.default, type.key, store: store)
    }

    /// Initializes an `AppStorage` instance for a `String` type.
    ///
    /// - Parameters:
    ///   - type: The type of the stored value.
    /// - store: The `UserDefaults` instance to use, or `nil` to use the standard
    /// `UserDefaults`.
    public init<AppStoredType: DefaultWrapped>(
      for type: AppStoredType.Type,
      store: UserDefaults? = nil
    ) where AppStoredType.Value == String, Value == String {
      self.init(wrappedValue: AppStoredType.default, type.key, store: store)
    }

    /// Initializes an `AppStorage` instance for a `URL` type.
    ///
    /// - Parameters:
    ///   - type: The type of the stored value.
    /// - store: The `UserDefaults` instance to use, or `nil` to use the standard
    /// `UserDefaults`.
    public init<AppStoredType: DefaultWrapped>(
      for type: AppStoredType.Type,
      store: UserDefaults? = nil
    ) where AppStoredType.Value == URL, Value == URL {
      self.init(wrappedValue: AppStoredType.default, type.key, store: store)
    }

    /// Initializes an `AppStorage` instance for a `Data` type.
    ///
    /// - Parameters:
    ///   - type: The type of the stored value.
    /// - store: The `UserDefaults` instance to use, or `nil` to use the standard
    /// `UserDefaults`.
    public init<AppStoredType: DefaultWrapped>(
      for type: AppStoredType.Type,
      store: UserDefaults? = nil
    ) where AppStoredType.Value == Data, Value == Data {
      self.init(wrappedValue: AppStoredType.default, type.key, store: store)
    }

    /// Initializes an `AppStorage` instance for a type that conforms to
    /// `RawRepresentable` with an `Int` raw value.
    ///
    /// - Parameters:
    ///   - type: The type of the stored value.
    /// - store: The `UserDefaults` instance to use, or `nil` to use the standard
    /// `UserDefaults`.
    public init<AppStoredType: DefaultWrapped>(
      for type: AppStoredType.Type,
      store: UserDefaults? = nil
    ) where AppStoredType.Value == Value, Value: RawRepresentable, Value.RawValue == Int {
      self.init(wrappedValue: AppStoredType.default, type.key, store: store)
    }

    /// Initializes an `AppStorage` instance for a type that conforms to
    /// `RawRepresentable` with a `String` raw value.
    ///
    /// - Parameters:
    ///   - type: The type of the stored value.
    /// - store: The `UserDefaults` instance to use, or `nil` to use the standard
    /// `UserDefaults`.
    public init<AppStoredType: DefaultWrapped>(
      for type: AppStoredType.Type,
      store: UserDefaults? = nil
    )
    where
      AppStoredType.Value == Value,
      Value: RawRepresentable,
      Value.RawValue == String {
      self.init(wrappedValue: AppStoredType.default, type.key, store: store)
    }
  }
#endif
