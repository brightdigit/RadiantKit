//
//  FileOperationProgress.swift
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

#if canImport(Observation)

  public import Foundation
  public import Observation

  @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
  @MainActor
  @Observable
  public final class FileOperationProgress<ValueType: BinaryInteger>: Identifiable {
    /// The progress operation associated with this object.
    public let operation: any ProgressOperation<ValueType>

    /// The unique identifier for this progress object.
    public let id: URL

    /// The total value of the operation in bytes, if available.
    public var totalValueBytes: Int64? {
      operation.totalValue.map {
        Int64($0)
      }
    }

    /// The current value of the operation in bytes.
    public var currentValueBytes: Int64 { Int64(operation.currentValue) }

    internal var currentValue: Double { Double(operation.currentValue) }

    internal var totalValue: Double? {
      operation.totalValue.map {
        Double($0)
      }
    }

    /// Initializes a new `FileOperationProgress` object with the given progress
    /// operation.
    /// - Parameter operation: The progress operation to associate with this
    /// object.
    public init(_ operation: any ProgressOperation<ValueType>) {
      self.operation = operation
      self.id = operation.id
    }
  }
#endif
