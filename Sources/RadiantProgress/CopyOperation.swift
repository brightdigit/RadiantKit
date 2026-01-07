//
//  CopyOperation.swift
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
  public import Observation

  #if canImport(OSLog)
    public import OSLog
  #else
    public import Logging
  #endif

  /// An operation that copies a file from a source URL to a destination URL, and
  /// periodically updates the progress of the operation.
  @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
  @MainActor
  @Observable
  public final class CopyOperation<ValueType: BinaryInteger & Sendable>: Identifiable {
    /// The source URL of the file to be copied.
    private let sourceURL: URL
    /// The destination URL of the copied file.
    private let destinationURL: URL
    /// The total value of the file being copied, if known.
    public let totalValue: ValueType?
    /// The time interval between updates to the progress of the operation.
    private let timeInterval: TimeInterval
    /// A closure that gets the size of the file at the given URL.
    nonisolated private let getSize: @Sendable (URL) throws -> ValueType?
    /// A closure that copies the file from the source URL to the destination
    /// URL.
    private let copyFile: @Sendable (CopyPaths) async throws -> Void
    /// The current value of the operation's progress.
    public var currentValue = ValueType.zero
    /// The timer used to periodically update the progress of the operation.
    private var timer: Timer?
    /// The logger used to log messages during the operation.
    private let logger: Logger?

    /// The URL of the source file, which is used as the unique identifier for
    /// the operation.
    nonisolated public var id: URL { sourceURL }

    /// Initializes a new `CopyOperation` instance.
    ///
    /// - Parameters:
    ///   - sourceURL: The source URL of the file to be copied.
    ///   - destinationURL: The destination URL of the copied file.
    ///   - totalValue: The total value of the file being copied, if known.
    ///   - timeInterval: The time interval between updates to the progress of the
    ///     operation.
    ///   - logger: The logger used to log messages during the operation.
    ///   - getSize: A closure that gets the size of the file at the given URL.
    ///   - copyFile: A closure that copies the file from the source URL to the
    ///     destination URL.
    public init(
      sourceURL: URL,
      destinationURL: URL,
      totalValue: ValueType?,
      timeInterval: TimeInterval,
      logger: Logger?,
      getSize: @escaping @Sendable (URL) throws -> ValueType?,
      copyFile: @escaping @Sendable (CopyPaths) async throws -> Void
    ) {
      self.sourceURL = sourceURL
      self.destinationURL = destinationURL
      self.totalValue = totalValue
      self.timeInterval = timeInterval
      self.getSize = getSize
      self.copyFile = copyFile
      self.logger = logger
    }

    /// Updates the current value of the operation's progress.
    ///
    /// - Parameter currentValue: The new current value of the operation's
    /// progress.
    nonisolated private func updateValue(_ currentValue: ValueType) {
      Task { await self.updatingValue(currentValue) }
    }

    /// Updates the current value of the operation's progress and checks if the
    /// operation is complete.
    ///
    /// - Parameter currentValue: The new current value of the operation's
    /// progress.
    private func updatingValue(_ currentValue: ValueType) {
      self.currentValue = currentValue
      if let totalValue = self.totalValue {
        guard self.currentValue < totalValue else {
          self.logger?.debug("Copy is complete based on size. Quitting timer.")
          self.killTimer()
          return
        }
      } else {
        self.logger?.warning("Total size is missing")
      }
    }

    /// Starts the timer that periodically updates the progress of the operation.
    private func starTimer() {
      timer = Timer.scheduledTimer(
        withTimeInterval: timeInterval,
        repeats: true
      ) { [weak self] timer in
        guard let weakSelf = self else {
          timer.invalidate()
          return
        }
        weakSelf.logger?.debug("Timer On")
        assert(weakSelf.logger != nil)
        Task {
          let currentValue: ValueType?
          do { currentValue = try weakSelf.getSize(weakSelf.destinationURL) } catch {
            weakSelf.logger?.error("Unable to get size: \(error)")
            assertionFailure("Unable to get size: \(error)")
            currentValue = nil
          }
          if let currentValue {
            weakSelf.updateValue(currentValue)
            weakSelf.logger?.debug("Updating size to: \(currentValue)")
          } else {
            weakSelf.logger?.warning("Unable to get size")
          }
        }
      }
    }

    /// Executes the copy operation.
    ///
    /// - Throws: Any errors that occur during the copy operation.
    public func execute() async throws {
      self.logger?.debug("Starting Copy operating")
      starTimer()
      do {
        try await self.copyFile(.init(fromURL: sourceURL, toURL: destinationURL))
      } catch {
        self.logger?.error("Error Copying: \(error)")
        self.killTimer()
        throw error
      }
      self.logger?.debug("Copy is done. Quitting timer.")
      self.killTimer()
    }

    /// Stops the timer used to periodically update the progress of the
    /// operation.
    private func killTimer() {
      timer?.invalidate()
      timer = nil
    }
  }

  @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
  extension CopyOperation: ProgressOperation {}
#endif
