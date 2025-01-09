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

  @MainActor @Observable
  public final class FileOperationProgress<ValueType: BinaryInteger>: Identifiable {
    public let operation: any ProgressOperation<ValueType>

    public nonisolated var id: URL { operation.id }

    public var totalValueBytes: Int64? { operation.totalValue.map(Int64.init) }

    public var currentValueBytes: Int64 { Int64(operation.currentValue) }

    internal var currentValue: Double { Double(operation.currentValue) }

    internal var totalValue: Double? { operation.totalValue.map(Double.init) }

    public init(_ operation: any ProgressOperation<ValueType>) { self.operation = operation }
  }
#endif
