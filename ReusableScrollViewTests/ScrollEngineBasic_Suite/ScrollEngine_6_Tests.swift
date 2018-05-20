//
//  ScrollEngine_6_Tests.swift
//  ScrollEngineTests
//
//  Created by sumofighter666 on 23.04.18.
//  Copyright © 2018 sumofighter666. All rights reserved.
//

import XCTest
@testable import ReusableScrollView

/*
 Test configuration:
 absolute index: 2
 number of views: 4
 
 Test includes:
 1. Initialization
 2. Request next
 3. Request previous
 
 Test Expectation
 1. Number of models: 4
 2. Current model: defined
 3. Current model absolute index: 2
 4. Current model relative index: RelativeIndex.current
 5. Current model view position x: 200.0
 6. Next model view position x: 300.0
 7. Appended index: nil
 8. Previous model view position x: 100.0
 9. Appended index: nil
 10. Model view position y: 0.0
 
 */

class ScrollEngine_6_Tests : ScrollEngineBase {
    
    let expectedNumberOfModels          = 4
    let expectedRelativeIndices         = [-2,-1,0,1]
    let expectedCurrentRelativeIndex    = RelativeIndex.current
    let expectedCurrentXPosition        = CGFloat(200)
    let expectedNextXPosition           = CGFloat(300)
    let expectedPreviousXPosition       = CGFloat(100)
    let expectedYPosition               = CGFloat(0)
    
    override func setUp() {
        super.setUp()
        
        absoluteIndex                = test_6_config.absoluteIndex
        viewsCount                   = test_6_config.numberOfViews
        
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
            XCTAssertEqual(viewModel.relativeIndex.rawValue, expectedRelativeIndices[i],
                           "\nTest Failed: Expected \(expectedRelativeIndices[i]) relative index but given \(viewModel.relativeIndex.rawValue)\n")
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
        
        // Test appended index
        XCTAssertNil(appendedIndex, "\nTest Failed: appendedIndex should be `nil`, because either number of views are equal or less than the pool of reusable views\n")
        
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
        
        // Test appended index
        XCTAssertNil(appendedIndex, "\nTest Failed: appendedIndex should be `nil`, because either number of views are equal or less than the pool of reusable views\n")
    }
    
}
