//
//  Logger.swift
//  ReusableScrollView
//
//  Created by sumofighter666 on 19.05.18.
//  Copyright © 2018 sumofighter666. All rights reserved.
//

import Foundation

public enum LegLevel:Int {
    case none
    case warning
    case debug
    case verbose
}

public let LOG_LEVEL:LegLevel = .debug

func logWarning(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    if LOG_LEVEL.rawValue >= LegLevel.warning.rawValue {
        #if DEBUG
        Swift.print("⚠️ Warning: \(items[0])", separator:separator, terminator: terminator)
        #else
        NSLog("Warning: \(items[0])")
        #endif
    }
}

func logDebug(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    if LOG_LEVEL.rawValue >= LegLevel.debug.rawValue {
        Swift.print(items[0], separator:separator, terminator: terminator)
    }
}

func logVerbose(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    if LOG_LEVEL.rawValue >= LegLevel.verbose.rawValue {
        Swift.print(items[0], separator:separator, terminator: terminator)
    }
}
