//  ScrollViewModel.swift

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

// TODO: Documentation
@objc public enum RelativeIndex:Int {
    /*
     Overflown cases are usuaully used 
     */
    
    case previousOverflown = -4
    case beforeBeforePrevious = -3
    case beforePrevious = -2
    case previous = -1
    case current = 0
    case next = 1
    case afterNext = 2
    case afterAfterNext = 3
    case nextOverflown = 4
    
    var description:String {
        switch self {
        case .previousOverflown:
            return "`Before Previous Overflown`"
        case .beforeBeforePrevious:
            return "`Before Before Previous`"
        case .beforePrevious:
            return "`Before Previous`"
        case .previous:
            return "`Previous`"
        case .current:
            return "`Current`"
        case .next:
            return "`Next`"
        case .afterNext:
            return "`After Next`"
        case .afterAfterNext:
            return "`After After Next`"
        case .nextOverflown:
            return "`After Next Overflown`"
        }
    }
}

@objc public final class ScrollViewModel:NSObject {
    
    private var _relativeIndex:RelativeIndex = RelativeIndex.current
    private var _absoluteIndex:Int = 0
    public var shouldReposition = false
    @objc public var relativeIndex:RelativeIndex {
        get {
            return _relativeIndex
        }
        set {
            _relativeIndex = newValue
        }
    }
    
    @objc public var absoluteIndex:Int {
        get {
            return _absoluteIndex
        }
        set {
            _absoluteIndex = newValue
        }
    }
    
    
    @objc public var position:CGPoint {
        get {
            
            let x = _size.width * CGFloat(absoluteIndex)

            return CGPoint(x: x, y: 0.0)
        }
    }

    // MARK: Private properties
    
    private let _size:CGSize
    
    @objc public init(size:CGSize) {
        _size = size
    }
}
