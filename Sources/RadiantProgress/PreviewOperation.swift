//
//  PreviewOperation.swift
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

/// An operation that represents a progress-based operation.
@MainActor
public struct PreviewOperation<ValueType: BinaryInteger & Sendable>: ProgressOperation {
  /// The current value of the operation.
  public let currentValue: ValueType

  /// The total value of the operation, if available.
  public let totalValue: ValueType?

  /// The unique identifier for the operation.
  public let id: URL

  /// Initializes a new `PreviewOperation` instance.
  ///
  /// - Parameters:
  ///   - currentValue: The current value of the operation.
  ///   - totalValue: The total value of the operation, if available.
  ///   - id: The unique identifier for the operation.
  public init(currentValue: ValueType, totalValue: ValueType?, id: URL) {
    self.currentValue = currentValue
    self.totalValue = totalValue
    self.id = id
  }

  /// Executes the operation.
  public func execute() async throws {
  }

  /// Cancels the operation.
  public func cancel() {
  }
}

#if canImport(FoundationNetworking)
  extension URL: @unchecked Sendable {
  }
#endif
