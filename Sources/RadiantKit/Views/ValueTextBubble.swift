//
//  ValueTextBubble.swift
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

  public struct ValueTextBubble<
    ShapeStyleType: ShapeStyle,
    ValueType: Equatable,
    FormatStyleType: FormatStyle
  >: View where FormatStyleType.FormatInput == ValueType, FormatStyleType.FormatOutput == String {
    public let value: ValueType
    public let format: FormatStyleType
    public let backgroundStyle: ShapeStyleType
    public let cornerRadius: CGFloat

    public var body: some View {
      Text(value, format: format)
        .background {
          RoundedRectangle(cornerRadius: cornerRadius).padding(-2).padding(.horizontal, -4)
            .foregroundStyle(backgroundStyle)
        }
        .padding(.horizontal, 2)
    }

    public init(
      value: ValueType,
      format: FormatStyleType,
      backgroundStyle: ShapeStyleType,
      cornerRadius: CGFloat = 18
    ) {
      self.value = value
      self.format = format
      self.cornerRadius = cornerRadius
      self.backgroundStyle = backgroundStyle
    }

    public init(
      value: ValueType,
      format: FormatStyleType,
      backgroundColor: Color = Color.primary.opacity(0.25),
      cornerRadius: CGFloat = 18
    ) where ShapeStyleType == Color {
      self.value = value
      self.format = format
      self.cornerRadius = cornerRadius
      self.backgroundStyle = backgroundColor
    }

    public init(
      value: Int,
      format: IntegerFormatStyle<Int> = FormatStyleType.number,
      backgroundColor: Color = Color.primary.opacity(0.25),
      cornerRadius: CGFloat = 18
    ) where ValueType == Int, ShapeStyleType == Color, FormatStyleType == IntegerFormatStyle<Int> {
      self.value = value
      self.format = format
      self.cornerRadius = cornerRadius
      self.backgroundStyle = backgroundColor
    }
  }
#endif
