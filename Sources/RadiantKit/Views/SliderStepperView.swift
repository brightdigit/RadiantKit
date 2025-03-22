//
//  SliderStepperView.swift
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

#if canImport(SwiftUI) && !os(tvOS)
  public import SwiftUI

  @MainActor public struct SliderStepperView<Content: View, Label: View, TitleType>: View {
    private let title: TitleType
    private let label: @Sendable (TitleType) -> Label
    private let bounds: ClosedRange<Float>
    private let step: Float
    private let content: @Sendable @MainActor (TitleType) -> Content
    @Binding private var value: Float
    private var safeBounds: ClosedRange<Float> {
      guard isValidBounds else { return 0...2 }
      return bounds
    }
    private var isValidBounds: Bool {
      let isValid = bounds.upperBound - bounds.lowerBound > 0
      if !isValid {
        assert(bounds.upperBound == bounds.lowerBound)
        assert(bounds.lowerBound == 1)
      }
      return isValid
    }
    private var blurRadius: CGFloat { return isValidBounds ? 0 : 1 }

    public var body: some View {
      LabeledContent {
        HStack {
          Slider(value: $value, in: safeBounds, step: step).blur(radius: blurRadius)
          self.content(self.title).labelsHidden().frame(width: 50).padding(.horizontal, 6.0)

          Stepper(value: $value, in: safeBounds, step: 1.0, label: { self.label(self.title) })
            .labelsHidden().blur(radius: blurRadius)
        }
        .disabled(!isValidBounds)
      } label: {
        self.label(self.title)
      }
    }

    public init(
      title: TitleType,
      label: @escaping @Sendable (TitleType) -> Label,
      value: Binding<Float>,
      bounds: ClosedRange<Float>,
      step: Float,
      content: @escaping @MainActor @Sendable (TitleType) -> Content
    ) {
      self.title = title
      self.label = label
      self._value = value
      self.bounds = bounds
      self.step = step
      self.content = content
    }
  }
  #Preview {
    @Previewable @State var value: Float = 1.0
    SliderStepperView(
      title: "Hello World",
      label: { text in Text(text) },
      value: $value,
      bounds: 1...1,
      step: 1.0
    ) { _ in Text("\(value, format: .number)") }
  }
  #Preview {
    @Previewable @State var value: Float = 1.0
    SliderStepperView(
      title: "Hello World",
      label: { text in Text(text) },
      value: $value,
      bounds: 1...20,
      step: 1.0
    ) { _ in Text("\(value, format: .number)") }
  }
#endif
