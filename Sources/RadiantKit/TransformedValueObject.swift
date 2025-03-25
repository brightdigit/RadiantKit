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

  @Observable
  public class TransformedValueObject<InputValue, OutputValue, FormattableValue> {
    private let defaultTransform: (InputValue) -> OutputValue
    private let formattable: (OutputValue) -> FormattableValue

    @ObservationIgnored private var transform: ((InputValue) -> OutputValue)?

    @ObservationIgnored private var bindingValue: Binding<InputValue?>?

    public var inputValue: InputValue {
      didSet {
        assert(self.transform != nil)
        self.bindingValue?.wrappedValue = inputValue
        self.outputValue = (self.transform ?? self.defaultTransform)(inputValue)
      }
    }

    public private(set) var outputValue: OutputValue {
      didSet { self.formattedValue = self.formattable(outputValue) }
    }

    public private(set) var formattedValue: FormattableValue

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
