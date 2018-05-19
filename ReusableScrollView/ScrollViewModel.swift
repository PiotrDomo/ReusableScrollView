//
//  ScrollViewModel.swift
//  ImagesScrollEngine
//
//  Created by sumofighter666 on 13.04.18.
//  Copyright © 2018 sumofighter666. All rights reserved.
//

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

@objc public final class ScrollViewModel:NSObject {
    
    @objc public var absoluteIndex:Int = 0
    @objc public var relativeIndex:RelativeIndex = RelativeIndex.current
    
    @objc public var position:CGPoint {
        get {
            var x:CGFloat = 0.0
            
            if absoluteIndex > 0 {
                x = _size.width * CGFloat(absoluteIndex)
            }
            
            return CGPoint(x: x, y: 0.0)
        }
    }

    // MARK: Private properties
    
    private let _size:CGSize
    
    @objc public init(size:CGSize) {
        _size = size
    }
}
