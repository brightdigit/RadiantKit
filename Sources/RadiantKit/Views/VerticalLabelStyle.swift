//
//  VerticalLabelStyle.swift
//  RadiantKit
//
//  Created by Leo Dion.
//  Copyright © 2024 BrightDigit.
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

  public struct VerticalLabelStyle: LabeledContentStyle {
    let alignment: HorizontalAlignment
    let labelFont: Font
    let labelPaddingEdgeInsets: EdgeInsets

    public init(
      alignment: HorizontalAlignment = .leading,
      labelFont: Font = .subheadline,
      labelPaddingEdgeInsets: EdgeInsets = .init(top: 0, leading: 4.0, bottom: 0.0, trailing: 0.0)
    ) {
      self.alignment = alignment
      self.labelFont = labelFont
      self.labelPaddingEdgeInsets = labelPaddingEdgeInsets
    }

    public func makeBody(configuration: Configuration) -> some View {
      VStack(alignment: alignment) {
        configuration.content.labelsHidden()
        configuration.label.font(labelFont).padding(labelPaddingEdgeInsets)
      }
    }
  }

  extension LabeledContentStyle {
    public static func vertical(
      alignment: HorizontalAlignment = .leading,
      labelFont: Font = .subheadline,
      labelPaddingEdgeInsets: EdgeInsets = .init(top: 0, leading: 2.0, bottom: 0.0, trailing: 0.0)
    ) -> Self where Self == VerticalLabelStyle {
      .init(
        alignment: alignment,
        labelFont: labelFont,
        labelPaddingEdgeInsets: labelPaddingEdgeInsets
      )
    }
  }
#endif
