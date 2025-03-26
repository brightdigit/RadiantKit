//
//  Video.swift
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

#if canImport(SwiftUI) && canImport(AppKit)

  public import AVKit

  public import SwiftUI

  /// A SwiftUI view that represents an AVPlayer.
  public struct Video: NSViewRepresentable {
    private let player: AVPlayer?

    // swiftlint:disable implicitly_unwrapped_optional
    /// Initializes a `Video` instance with an `AVPlayer`.
    ///
    /// - Parameter player: The `AVPlayer` to be used in the video view.
    public init(using player: AVPlayer!) {
      assert(player != nil)
      self.player = player
    }
    // swiftlint:enable implicitly_unwrapped_optional

    /// Creates an `AVPlayerView` to display the video.
    ///
    /// - Parameter context: The context provided by SwiftUI.
    /// - Returns: An `AVPlayerView` instance.
    public func makeNSView(context _: Context) -> AVPlayerView {
      let view = AVPlayerView()
      view.controlsStyle = .none
      view.player = player
      player?.play()
      return view
    }

    /// Updates the `AVPlayerView` if necessary.
    ///
    /// - Parameters:
    ///   - view: The `AVPlayerView` to be updated.
    ///   - context: The context provided by SwiftUI.
    public func updateNSView(_: AVPlayerView, context _: Context) {}
  }

#endif
