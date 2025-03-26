//
//  ProgressOperationProperties.swift
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

  /// A structure that represents the properties of a progress operation.
  public struct ProgressOperationProperties: Identifiable, Sendable {
    /// The name of the image associated with the progress operation.
    internal let imageName: String
    /// The text associated with the progress operation.
    internal let text: any (StringProtocol & Sendable)
    /// The progress of the operation.
    internal let progress: FileOperationProgress<Int>

    /// The identifier of the progress operation, which is a URL.
    public let id: URL

    /// Initializes a new instance of `ProgressOperationProperties`.
    ///
    /// - Parameters:
    /// - imageName: The name of the image associated with the progress
    /// operation.
    ///   - text: The text associated with the progress operation.
    ///   - url: The URL used as the identifier for the progress operation.
    ///   - progress: The progress of the operation.
    public init(
      imageName: String,
      text: any (StringProtocol & Sendable),
      url: URL,
      progress: FileOperationProgress<Int>
    ) {
      self.imageName = imageName
      self.text = text
      self.progress = progress
      self.id = url
    }
  }

  #if canImport(SwiftUI)
    extension ProgressOperationView {
      /// The properties of a progress operation.
      public typealias Properties = ProgressOperationProperties

      /// Initializes a new instance of `ProgressOperationView`.
      ///
      /// - Parameters:
      ///   - properties: The properties of the progress operation.
      ///   - text: A closure that generates the progress text.
      ///   - image: A closure that generates the progress image.
      public init(
        _ properties: Properties,
        text: @escaping (FileOperationProgress<Int>) -> ProgressText,
        image: @escaping (String) -> Icon
      ) {
        self.init(progress: properties.progress, title: properties.text, text: text) {
          image(properties.imageName)
        }
      }
    }
  #endif
#endif
