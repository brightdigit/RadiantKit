//
//  Color.swift
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
  public import SwiftUI

  /// An extension to the `Color` type that adds an initializer to create a
  /// `Color` instance from a hexadecimal string.
  extension Color {
    // swiftlint:disable function_body_length

    /// Initializes a `Color` instance from a hexadecimal string.
    ///
    /// - Parameter hex: A hexadecimal string representation of the color, in the
    /// format of `"RRGGBB"` or `"AARRGGBB"`.
    public init(hex: String) {
      let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
      var int: UInt64 = 0
      Scanner(string: hex).scanHexInt64(&int)
      let alpha: UInt64
      let red: UInt64
      let green: UInt64
      let blue: UInt64

      switch hex.count {
        case 3:  // RGB (12-bit)
          (alpha, red, green, blue) = (
            255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17
          )
        case 6:  // RGB (24-bit)
          (alpha, red, green, blue) =
            (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:  // ARGB (32-bit)
          (alpha, red, green, blue) =
            (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)

        default:
          (alpha, red, green, blue) = (255, 0, 0, 0)
      }

      self.init(
        .sRGB,
        red: Double(red) / 255,
        green: Double(green) / 255,
        blue: Double(blue) / 255,
        opacity: Double(alpha) / 255
      )
    }
    // swiftlint:enable function_body_length
  }
#endif
