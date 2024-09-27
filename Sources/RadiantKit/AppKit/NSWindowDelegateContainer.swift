//
//  NSWindowDelegateContainer.swift
//  RadiantKit
//
//  Created by Leo Dion on 9/27/24.
//

#if canImport(AppKit) && canImport(SwiftUI)
  public import AppKit
@MainActor
public protocol NSWindowDelegateContainer : AnyObject {
  var windowDelegate : (any NSWindowDelegate)? {
    get
    set
  }
}
#endif
