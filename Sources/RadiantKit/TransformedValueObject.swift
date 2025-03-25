//
//  TransformedValueObject.swift
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

  /// An observable class that transforms an input value of type `InputValue` to an output value of type `OutputValue`, and provides a formatted representation of the output value as `FormattableValue`.
  @Observable
  public class TransformedValueObject<InputValue, OutputValue, FormattableValue> {
    /// The default transformation function from `InputValue` to `OutputValue`.
    private let defaultTransform: (InputValue) -> OutputValue

    /// The formatting function from `OutputValue` to `FormattableValue`.
    private let formattable: (OutputValue) -> FormattableValue

    /// The custom transformation function from `InputValue` to `OutputValue`, or `nil` if the default transformation is used.
    @ObservationIgnored private var transform: ((InputValue) -> OutputValue)?

    /// The binding to the input value of type `InputValue?`, or `nil` if not bound.
    @ObservationIgnored private var bindingValue: Binding<InputValue?>?

    /// The input value of type `InputValue`.
    public var inputValue: InputValue {
      didSet {
        assert(self.transform != nil)
        self.bindingValue?.wrappedValue = inputValue
        self.outputValue = (self.transform ?? self.defaultTransform)(inputValue)
      }
    }

    /// The output value of type `OutputValue`.
    public private(set) var outputValue: OutputValue {
      didSet { self.formattedValue = self.formattable(outputValue) }
    }

    /// The formatted representation of the output value as `FormattableValue`.
    public private(set) var formattedValue: FormattableValue

    /// Initializes a `TransformedValueObject` instance.
    ///
    /// - Parameters:
    ///   - defaultTransform: The default transformation function from `InputValue` to `OutputValue`.
    ///   - formattable: The formatting function from `OutputValue` to `FormattableValue`.
    ///   - inputValue: The initial input value of type `InputValue`.
    ///   - outputValue: The initial output value of type `OutputValue`, or `nil` to use the default transformation.
    ///   - fomrattedValue: The initial formatted representation of the output value as `FormattableValue`, or `nil` to use the result of the `formattable` function.
    ///   - polynomial: The custom transformation function from `InputValue` to `OutputValue`, or `nil` to use the default transformation.
    public init(
      defaultTransform: @escaping (InputValue) -> OutputValue,
      formattable: @escaping (OutputValue) -> FormattableValue,
      inputValue: InputValue,
      outputValue: OutputValue? = nil,
      fomrattedValue: FormattableValue? = nil,
      polynomial: ((InputValue) -> OutputValue)? = nil
    ) {
      self.formattable = formattable
      self.defaultTransform = defaultTransform
      self.transform = polynomial
      self.inputValue = inputValue
      let outputValue =
        outputValue ?? transform?(inputValue) ?? defaultTransform(inputValue)
      self.outputValue = outputValue
      self.formattedValue = fomrattedValue ?? self.formattable(outputValue)
    }

    /// Binds the `TransformedValueObject` to a `Binding<InputValue?>` and sets the custom transformation function.
    ///
    /// - Parameters:
    ///   - bindingValue: The binding to the input value of type `InputValue?`.
    ///   - transform: The custom transformation function from `InputValue` to `OutputValue`.
    public func bindTo(
      _ bindingValue: Binding<InputValue?>,
      using transform: @escaping (InputValue) -> OutputValue
    ) {
      assert(self.bindingValue == nil)
      assert(self.transform == nil)
      self.transform = transform
      self.inputValue = bindingValue.wrappedValue ?? self.inputValue
      self.bindingValue = bindingValue
    }
  }

#endif
