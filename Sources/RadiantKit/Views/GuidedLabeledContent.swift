//
//  GuidedLabeledContent.swift
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

  /// A view that combines a labeled content view with a description view,
  /// creating a guided user experience.
  ///
  /// This view is useful for presenting content with additional guidance or
  /// context.
  ///
  /// - Parameters:
  ///   - content: A closure that returns the content view.
  ///   - label: A closure that returns the label view.
  ///   - description: A closure that returns the description view.
  ///
  /// - Returns: A view that presents the labeled content and description.
  @available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
  public struct GuidedLabeledContent<
    Label: View,
    Content: View,
    Description: View
  >: View {
    private let content: () -> Content
    private let label: () -> Label
    private let description: () -> Description

    public var body: some View {
      VStack {
        LabeledContent(content: content, label: label)
        self.description()
      }
    }

    public init(
      _ content: @escaping () -> Content,
      label: @escaping () -> Label,
      description: @escaping () -> Description
    ) {
      self.content = content
      self.label = label
      self.description = description
    }
  }

  @available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
  extension GuidedLabeledContent
  where Description == GuidedLabeledContentDescriptionView {
    /// Initializes a `GuidedLabeledContent` instance with a content view, a
    /// label view, and a text-based description view.
    ///
    /// - Parameters:
    ///   - content: A closure that returns the content view.
    ///   - label: A closure that returns the label view.
    ///   - text: A closure that returns the text-based description view.
    /// - descriptionAlignment: The alignment of the description view (default is
    /// `.leading`).
    ///
    /// - Returns: A `GuidedLabeledContent` instance with the specified content,
    /// label, and description.
    public init(
      _ content: @escaping () -> Content,
      label: @escaping () -> Label,
      text: @escaping () -> Text,
      descriptionAlignment: GuidedLabeledContentDescriptionView.Alignment? = .leading
    ) {
      self.init(content, label: label) {
        GuidedLabeledContentDescriptionView(alignment: descriptionAlignment, text: text)
      }
    }
  }
#endif
