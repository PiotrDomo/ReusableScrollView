//  ScrollViewModel.swift

/*
 
 Copyright (c) 2018 ReusableScrollView (https://github.com/sumofighter666/ReusableScrollView)
 
 This file is part of ReusableScrollView.
 
 Foobar is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 
 Foobar is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with Foobar.  If not, see <http://www.gnu.org/licenses/>.
 
 */

import Foundation

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

public enum RelativeShift:Int {
    case left
    case none
    case right
}

@objc public final class ScrollViewModel:NSObject {
    
    public var shift:RelativeShift = .none
    @objc public var absoluteIndex:Int = 0
    @objc public var relativeIndex:RelativeIndex = RelativeIndex.current
    
    @objc public var position:CGPoint {
        get {
            
            switch shift {
            
            case .left:
                if relativeIndex == .afterNext {
                    let x = _size.width * CGFloat(absoluteIndex+5)
                    return CGPoint(x: x, y: 0.0)
                }
                
            case .right:
                if relativeIndex == .beforePrevious {
                    let x = _size.width * CGFloat(absoluteIndex-5)
                    return CGPoint(x: x, y: 0.0)
                }
                
            default:
                let x = _size.width * CGFloat(absoluteIndex)
                return CGPoint(x: x, y: 0.0)
                
            }
            
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
