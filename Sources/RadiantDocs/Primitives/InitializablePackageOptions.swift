//
//  InitializablePackageOptions.swift
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

public import Foundation

public struct InitializablePackageOptions: OptionSet, Sendable {
  /// An option to write data to an auxiliary file first and
  /// then replace the original file
  /// with the auxiliary file when the write completes.
  public static let atomic = InitializablePackageOptions(rawValue: 1 << 0)
  /// An option that attempts to write data to a file and fails with an error if the
  /// destination file already exists.
  public static let withoutOverwriting = InitializablePackageOptions(rawValue: 1 << 1)
  /// An option to not encrypt the file when writing it out.
  public static let noFileProtection = InitializablePackageOptions(rawValue: 1 << 2)
  /// An option to make the file accessible only while the device is unlocked.
  public static let completeFileProtection = InitializablePackageOptions(rawValue: 1 << 3)
  /// An option to allow the file to be accessible while the device is unlocked
  /// or the file is already open.
  public static let completeFileProtectionUnlessOpen =
    InitializablePackageOptions(rawValue: 1 << 4)
  /// An option to allow the file to be accessible after a user first unlocks the device.
  public static let completeFileProtectionUntilFirstUserAuthentication =
    InitializablePackageOptions(rawValue: 1 << 5)
  /// An option the system uses when determining the file protection options that
  /// the system assigns to the data.
  public static let fileProtectionMask = InitializablePackageOptions(rawValue: 0x0F << 2)
  /// An option to create any necessary intermediate directories in the write path.
  public static let withIntermediateDirectories =
    InitializablePackageOptions(rawValue: 1 << 6)
  // Common combinations
  public static let none: InitializablePackageOptions = []
  public let rawValue: Int
  /// Returns true if the withIntermediateDirectories option is enabled
  public var withIntermediateDirectoriesIsEnabled: Bool {
    contains(.withIntermediateDirectories)
  }
  public init(rawValue: Int) { self.rawValue = rawValue }
}

extension Data.WritingOptions {
  /// Initialize Data.WritingOptions from InitializablePackageOptions
  public init(options: InitializablePackageOptions) {
    var dataOptions: Data.WritingOptions = []
    if options.contains(.atomic) { dataOptions.insert(.atomic) }
    if options.contains(.withoutOverwriting) { dataOptions.insert(.withoutOverwriting) }
    if options.contains(.noFileProtection) { dataOptions.insert(.noFileProtection) }
    if options.contains(.completeFileProtection) { dataOptions.insert(.completeFileProtection) }
    if options.contains(.completeFileProtectionUnlessOpen) {
      dataOptions.insert(.completeFileProtectionUnlessOpen)
    }
    if options.contains(.completeFileProtectionUntilFirstUserAuthentication) {
      dataOptions.insert(.completeFileProtectionUntilFirstUserAuthentication)
    }
    self = dataOptions
  }
}
