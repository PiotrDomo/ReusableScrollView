//
//  ScrollEngine_4_Tests.swift
//  ScrollEngineTests
//
//  Created by sumofighter666 on 24.04.18.
//  Copyright © 2018 sumofighter666. All rights reserved.
//

import XCTest
@testable import ScrollEngine

/*
 Test configuration:
 absolute index: 2
 number of views: 5
 
 Test includes:
 1. Initialization
 2. Request next
 3. Request previous
 
 Test Expectation
 1. Number of models: 5
 2. Current model: defined
 3. Current model absolute index: 2
 4. Current model relative index: RelativeIndex.current
 5. Current model view position x: 200.0
 6. Next model view position x: 300.0
 7. Previous model view position x: 100.0
 8. Model view position y: 0.0
 
 */

class ScrollEngine_4_Tests : ScrollEngineBase {
    
    let expectedNumberOfModels          = 5
    let expectedRelativeIdices          = [-2,-1,0,1,2]
    let expectedCurrentRelativeIndex    = RelativeIndex.current
    let expectedCurrentXPosition        = CGFloat(200)
    let expectedNextXPosition           = CGFloat(300)
    let expectedPreviousXPosition       = CGFloat(100)
    let expectedYPosition               = CGFloat(0)
    
    override func setUp() {
        super.setUp()
        
        absoluteIndex                = test_4_config.absoluteIndex
        viewsCount                   = test_4_config.numberOfViews
        
        self.prepare()
    }
    
    func test_01_initialization() {
        
        // Test number of models returned
        XCTAssertEqual(countOfModels, expectedNumberOfModels, "\nTest Failed: Expected `\(expectedNumberOfModels)` scroll view models but given `\(countOfModels)`\n")
        
        // Test model marked `current` was found
        XCTAssertNotNil(currentModel, "\nTest Failed: Model marked `current` not found\n")
        
        // Test absolute index for current model
        XCTAssertEqual(currentModel?.absoluteIndex, absoluteIndex, "\nTest Failed: Expected `\(absoluteIndex)` absolute index but given different\n")
        
        // Test x, y positions of the current view
        XCTAssertEqual(currentModel?.position.x, expectedCurrentXPosition, "\nTest Failed: Expected `\(expectedCurrentXPosition)` x position of the current view, but given `\(currentModel?.position.x ?? CGFloat(-9999.0))`\n")
        XCTAssertEqual(currentModel?.position.y, expectedYPosition, "\nTest Failed: Expected `\(expectedYPosition)` y position of the current view, but given `\(currentModel?.position.y ?? CGFloat(-9999.0))`\n")
        
        // Test relative indices
        
        var i = 0
        
        self.models.forEach { viewModel in
            XCTAssertEqual(viewModel.relativeIndex.rawValue, expectedRelativeIdices[i],
                           "\nTest Failed: Expected \(expectedRelativeIdices[i]) relative index but given \(viewModel.relativeIndex.rawValue)\n")
            i += 1
        }
    }
    
    func test_02_requestNext() {
        
        self.next()
        
        // Test model marked `current` was found
        XCTAssertNotNil(currentModel, "\nTest Failed: Model marked `current` not found\n")
        
        // Test absoluteIndex of current view is not the same as absoluteIndex in config
        XCTAssertEqual(currentModel?.absoluteIndex, absoluteIndex+1, "\nTest Failed: Expected `\(absoluteIndex+1)` scroll view current model index but given `\(String(describing: currentModel?.absoluteIndex))`\n")
        
        // Test scrolling direction is set up
        XCTAssertNotNil(scrollingDirection, "\nTest Failed: Scrolling direction not defined\n")
        
        // Test x, y positions of the current view
        XCTAssertEqual(currentModel?.position.x, expectedNextXPosition, "\nTest Failed: Expected `\(expectedNextXPosition)` x position of the current view, but given `\(currentModel?.position.x ?? CGFloat(-9999.0))`\n")
        XCTAssertEqual(currentModel?.position.y, expectedYPosition, "\nTest Failed: Expected `\(expectedYPosition)` y position of the current view, but given `\(currentModel?.position.y ?? CGFloat(-9999.0))`\n")
        
    }
    
    func test_03_requestPrevious() {
        
        self.previous()
        
        // Test model marked `current` was found
        XCTAssertNotNil(currentModel, "\nTest Failed: Model marked `current` not found\n")
        
        // Test absoluteIndex of current view is not the same as absoluteIndex in config
        XCTAssertEqual(currentModel?.absoluteIndex, absoluteIndex-1, "\nTest Failed: Expected `\(absoluteIndex+1)` scroll view current model index but given `\(String(describing: currentModel?.absoluteIndex))`\n")
        
        // Test scrolling direction is set up
        XCTAssertNotNil(scrollingDirection, "\nTest Failed: Scrolling direction not defined\n")
        
        // Test x, y positions of the current view
        XCTAssertEqual(currentModel?.position.x, expectedPreviousXPosition, "\nTest Failed: Expected `\(expectedPreviousXPosition)` x position of the current view, but given `\(currentModel?.position.x ?? CGFloat(-9999.0))`\n")
        XCTAssertEqual(currentModel?.position.y, expectedYPosition, "\nTest Failed: Expected `\(expectedYPosition)` y position of the current view, but given `\(currentModel?.position.y ?? CGFloat(-9999.0))`\n")
        
    }
    
}
