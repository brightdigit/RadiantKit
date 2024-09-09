//
//  AppStorage+ExpressibleByNilLiteral.swift
//  RadiantKit
//
//  Created by Leo Dion.
//  Copyright © 2024 BrightDigit.
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

  extension AppStorage where Value: ExpressibleByNilLiteral {
    public init<AppStoredType: AppStored>(for type: AppStoredType.Type, store: UserDefaults? = nil)
    where
      AppStoredType.Value == Value,
      // swiftlint:disable:next discouraged_optional_boolean
      Value == Bool?
    { self.init(type.key, store: store) }

    public init<AppStoredType: AppStored>(for type: AppStoredType.Type, store: UserDefaults? = nil)
    where AppStoredType.Value == Value, Value == Int? { self.init(type.key, store: store) }

    public init<AppStoredType: AppStored>(for type: AppStoredType.Type, store: UserDefaults? = nil)
    where AppStoredType.Value == Value, Value == Double? { self.init(type.key, store: store) }

    public init<AppStoredType: AppStored>(for type: AppStoredType.Type, store: UserDefaults? = nil)
    where AppStoredType.Value == Value, Value == String? { self.init(type.key, store: store) }

    public init<AppStoredType: AppStored>(for type: AppStoredType.Type, store: UserDefaults? = nil)
    where AppStoredType.Value == Value, Value == URL? { self.init(type.key, store: store) }

    public init<AppStoredType: AppStored>(for type: AppStoredType.Type, store: UserDefaults? = nil)
    where AppStoredType.Value == Value, Value == Data? { self.init(type.key, store: store) }
  }

  extension AppStorage {
    public init<AppStoredType: AppStored, R>(
      for type: AppStoredType.Type,
      store: UserDefaults? = nil
    )
    where
      AppStoredType.Value == R?,
      R: RawRepresentable,
      Value == AppStoredType.Value,
      R.RawValue == String
    { self.init(type.key, store: store) }

    public init<AppStoredType: AppStored, R>(
      for type: AppStoredType.Type,
      store: UserDefaults? = nil
    )
    where
      AppStoredType.Value == R?,
      R: RawRepresentable,
      Value == AppStoredType.Value,
      R.RawValue == Int
    { self.init(type.key, store: store) }
  }
#endif
