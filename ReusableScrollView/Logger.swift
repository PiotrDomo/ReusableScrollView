//  Logger.swift

/*
 
 MIT License
 
 Copyright (c) 2018 ReusableScrollView (https://github.com/sumofighter666/ReusableScrollView)
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 
 */

import Foundation

public enum LegLevel:Int {
    case none
    case error
    case warning
    case debug
    case verbose
}

public let LOG_LEVEL:LegLevel = .none

func logError(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    if LOG_LEVEL.rawValue >= LegLevel.error.rawValue {
        #if DEBUG
        Swift.print("❗️Error: \(items[0])", separator:separator, terminator: terminator)
        #else
        NSLog("Error: \(items[0])")
        #endif
    }
}

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
