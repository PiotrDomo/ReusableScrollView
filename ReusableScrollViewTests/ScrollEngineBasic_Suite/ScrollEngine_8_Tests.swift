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
 absolute index: 7
 number of views: 13
 
 Test includes:
 1. Initialization, request next, request previous all in one test case
 
 Test Expectation
 1. Number of models: 5
 2. Current model: defined
 3. Current model absolute index: 7
 4. Current model relative index: RelativeIndex.current
 5. Current model view position x: 700.0
 6. Next model view position x: 800.0
 7. Appended next index: 10
 8. Previous model view position x: 700.0
 9. Appended previous index: 5
 10. Model view position y: 0.0
 
 */

class ScrollEngine_8_Tests : ScrollEngineBase {
    
    let expectedNumberOfModels          = 5
    let expectedRelativeIndices         = [-2,-1,0,1,2]
    let expectedCurrentRelativeIndex    = RelativeIndex.current
    let expectedCurrentXPosition        = CGFloat(700)
    let expectedNextXPosition           = CGFloat(800)
    let expectedPreviousXPosition       = CGFloat(700)
    let expectedYPosition               = CGFloat(0)
    let expectedApendedNextIndex        = 10
    let expectedApendedPreviousIndex    = 5
    
    override func setUp() {
        super.setUp()
        
        absoluteIndex                = test_8_config.absoluteIndex
        viewsCount                   = test_8_config.numberOfViews
        
        self.prepare()
    }
    
    func test_01_initialization_next_previous() {
        
        ////////// INITIALIZATION //////////
        
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
        
        
        
        ////////// NEXT //////////
        
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
        XCTAssertEqual(appendedIndex, expectedApendedNextIndex, "\nTest Failed: appendedIndex should be `\(expectedApendedNextIndex)` but given \(appendedIndex ?? -9999)\n")
        
        
        ////////// PREVIOUS //////////
        
        self.previous()
        
        // Test model marked `current` was found
        XCTAssertNotNil(currentModel, "\nTest Failed: Model marked `current` not found\n")
        
        // Test absoluteIndex of current view is not the same as absoluteIndex in config
        XCTAssertEqual(currentModel?.absoluteIndex, absoluteIndex, "\nTest Failed: Expected `\(absoluteIndex)` scroll view current model index but given `\(String(describing: currentModel?.absoluteIndex))`\n")
        
        // Test scrolling direction is set up
        XCTAssertNotNil(scrollingDirection, "\nTest Failed: Scrolling direction not defined\n")
        
        // Test x, y positions of the current view
        XCTAssertEqual(currentModel?.position.x, expectedPreviousXPosition, "\nTest Failed: Expected `\(expectedPreviousXPosition)` x position of the current view, but given `\(currentModel?.position.x ?? CGFloat(-9999.0))`\n")
        XCTAssertEqual(currentModel?.position.y, expectedYPosition, "\nTest Failed: Expected `\(expectedYPosition)` y position of the current view, but given `\(currentModel?.position.y ?? CGFloat(-9999.0))`\n")
        
        // Test appended index
        XCTAssertEqual(appendedIndex, expectedApendedPreviousIndex, "\nTest Failed: appendedIndex should be `\(expectedApendedPreviousIndex)` but given \(appendedIndex ?? -9999)\n")
        
    }
    
}
