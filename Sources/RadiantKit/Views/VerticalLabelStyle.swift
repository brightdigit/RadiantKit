//
//  VerticalLabelStyle.swift
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
  /// A custom label style that arranges the label and content vertically.
  public struct VerticalLabelStyle: LabeledContentStyle {
    private let alignment: HorizontalAlignment
    private let labelFont: Font
    private let labelPaddingEdgeInsets: EdgeInsets

    /// Initializes a new instance of the `VerticalLabelStyle` struct.
    ///
    /// - Parameters:
    /// - alignment: The horizontal alignment of the label and content. Defaults
    /// to `.leading`.
    /// - labelFont: The font to be used for the label. Defaults to
    /// `.subheadline`.
    /// - labelPaddingEdgeInsets: The edge insets to be used for padding the
    /// label. Defaults to `.defaultLabeledContent`.
    public init(
      alignment: HorizontalAlignment = .leading,
      labelFont: Font = .subheadline,
      labelPaddingEdgeInsets: EdgeInsets? = nil
    ) {
      self.alignment = alignment
      self.labelFont = labelFont
      self.labelPaddingEdgeInsets = labelPaddingEdgeInsets ?? .defaultLabeledContent
    }

    /// Creates the body of the `VerticalLabelStyle`.
    ///
    /// - Parameter configuration: The configuration for the label and content.
    /// - Returns: A `some View` representing the vertical label style.
    public func makeBody(configuration: Configuration) -> some View {
      VStack(alignment: alignment) {
        configuration.content.labelsHidden()
        configuration.label.font(labelFont).padding(labelPaddingEdgeInsets)
      }
    }
  }

  extension LabeledContentStyle {
    /// Creates a vertical label style with the given parameters.
    ///
    /// - Parameters:
    /// - alignment: The horizontal alignment of the label and content. Defaults
    /// to `.leading`.
    /// - labelFont: The font to be used for the label. Defaults to
    /// `.subheadline`.
    /// - labelPaddingEdgeInsets: The edge insets to be used for padding the
    /// label. Defaults to `.defaultLabeledContent`.
    /// - Returns: A `VerticalLabelStyle` instance with the specified parameters.
    public static func vertical(
      alignment: HorizontalAlignment = .leading,
      labelFont: Font = .subheadline,
      labelPaddingEdgeInsets: EdgeInsets? = nil
    ) -> Self where Self == VerticalLabelStyle {
      .init(
        alignment: alignment,
        labelFont: labelFont,
        labelPaddingEdgeInsets: labelPaddingEdgeInsets ?? .defaultLabeledContent
      )
    }
  }

  extension EdgeInsets {
    fileprivate static let defaultLabeledContent: Self = .init(
      top: 0,
      leading: 2.0,
      bottom: 0.0,
      trailing: 0.0
    )
  }

#endif
