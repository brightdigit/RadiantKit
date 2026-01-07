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

  /// A SwiftUI view that displays a value with a formatted text bubble.
  public struct ValueTextBubble<
    ShapeStyleType: ShapeStyle,
    ValueType: Equatable,
    FormatStyleType: FormatStyle
  >: View
  where
    FormatStyleType.FormatInput == ValueType,
    FormatStyleType.FormatOutput == String
  {
    /// The value to be displayed.
    public let value: ValueType

    /// The format style to be applied to the value.
    public let format: FormatStyleType

    /// The background style of the text bubble.
    public let backgroundStyle: ShapeStyleType

    /// The corner radius of the text bubble.
    public let cornerRadius: CGFloat

    /// The content and behavior of the view.
    public var body: some View {
      Text(value, format: format)
        .background {
          RoundedRectangle(cornerRadius: cornerRadius)
            .padding(-2)
            .padding(.horizontal, -4)
            .foregroundStyle(backgroundStyle)
        }
        .padding(.horizontal, 2)
    }

    /// Initializes a `ValueTextBubble` with the specified value, format,
    /// background style, and corner radius.
    /// - Parameters:
    ///   - value: The value to be displayed.
    ///   - format: The format style to be applied to the value.
    ///   - backgroundStyle: The background style of the text bubble.
    ///   - cornerRadius: The corner radius of the text bubble. Defaults to 18.
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

    /// Initializes a `ValueTextBubble` with the specified value, format,
    /// background color, and corner radius.
    /// - Parameters:
    ///   - value: The value to be displayed.
    ///   - format: The format style to be applied to the value.
    ///   - backgroundColor: The background color of the text bubble. Defaults to
    ///     `Color.primary.opacity(0.25)`.
    ///   - cornerRadius: The corner radius of the text bubble. Defaults to 18.
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

    /// Initializes a `ValueTextBubble` with the specified integer value, format,
    /// background color, and corner radius.
    /// - Parameters:
    ///   - value: The integer value to be displayed.
    ///   - format: The integer format style to be applied to the value. Defaults
    ///     to `FormatStyleType.number`.
    ///   - backgroundColor: The background color of the text bubble. Defaults to
    ///     `Color.primary.opacity(0.25)`.
    ///   - cornerRadius: The corner radius of the text bubble. Defaults to 18.
    public init(
      value: Int,
      format: IntegerFormatStyle<Int> = FormatStyleType.number,
      backgroundColor: Color = Color.primary.opacity(0.25),
      cornerRadius: CGFloat = 18
    )
    where
      ValueType == Int,
      ShapeStyleType == Color,
      FormatStyleType == IntegerFormatStyle<Int>
    {
      self.value = value
      self.format = format
      self.cornerRadius = cornerRadius
      self.backgroundStyle = backgroundColor
    }
  }

#endif
