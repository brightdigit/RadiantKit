//
//  GuidedLabeledContentDescriptionView.swift
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

  public struct GuidedLabeledContentDescriptionView: View {
    public enum Alignment {
      case leading
      case trailing
    }

    @Environment(\.layoutDirection)
    private var layoutDirection
    private let text: () -> Text
    private let alignment: Alignment?

    private var multilineTextAlignment: TextAlignment {
      switch alignment {
        case .leading: .leading

        case .trailing: .trailing

        case nil: .center
      }
    }

    private var leftSpacer: Bool {
      switch (alignment, layoutDirection) {
        case (.trailing, .leftToRight): true

        case (.leading, .rightToLeft): true

        default: false
      }
    }

    private var rightSpacer: Bool {
      switch (alignment, layoutDirection) {
        case (.leading, .leftToRight): true

        case (.trailing, .rightToLeft): true

        default: false
      }
    }

    public var body: some View {
      HStack {
        if leftSpacer { Spacer() }
        text().font(.callout).multilineTextAlignment(self.multilineTextAlignment)

        if rightSpacer { Spacer() }
      }
    }

    internal init(alignment: Alignment? = nil, text: @escaping () -> Text) {
      self.text = text
      self.alignment = alignment
    }
  }
#endif
