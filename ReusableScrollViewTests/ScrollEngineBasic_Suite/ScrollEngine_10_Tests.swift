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
 number of views: 5
 
 Test includes:
 1. Initialization, request next, next, request previous, previous all in one test case
 
 Test Expectation
 1. Number of models: 5
 2. Current model: defined
 3. Current model absolute index: 2
 4. Current model relative index: RelativeIndex.current
 5. Current model view position x: 200.0
 6. Next model view position x: 300.0
 7. Next next model view position x: 400.0
 8. Appended next index: nil
 9. Relative shift for next: RelativeShift.none
 10. Relative shift for next next: RelativeShift.none
 11. Previous model view position x: 300.0
 12. Previous previous model view position x: 200.0
 13. Appended previous index: nil
 14. Relative shift for previous: RelativeShift.none
 15. Relative shift for previous previous: RelativeShift.none
 
 */

class ScrollEngine_10_Tests : ScrollEngineBase {
    
    let expectedNumberOfModels                  = 5
    let expectedRelativeIndices                 = [-2,-1,0,1,2]
    let expectedRelativeIndicesNext             = [-3,-2,-1,0,1]
    let expectedRelativeIndicesNextNext         = [-4,-3,-2,-1,0]
    let expectedRelativeIndicesPrevious         = [-3,-2,-1,0,1]
    let expectedRelativeIndices2xPrevious       = [-2,-1,0,1,2]
    let expectedRelativeIndices3xPrevious       = [-1,0,1,2,3]
    let expectedRelativeIndices4xPrevious       = [0,1,2,3,4]
    
    let expectedCurrentRelativeIndex            = RelativeIndex.current
    let expectedCurrentXPosition                = CGFloat(200)
    let expectedNextXPosition                   = CGFloat(300)
    let expectedNextNextXPosition               = CGFloat(400)
    let expectedPreviousXPosition               = CGFloat(300)
    let expected2xPreviousXPosition             = CGFloat(200)
    let expected3xPreviousXPosition             = CGFloat(100)
    let expected4xPreviousXPosition             = CGFloat(0)
    let expectedNextAbsoluteIndex               = 3
    let expectedNextNextAbsoluteIndex           = 4
    let expectedPreviousAbsoluteIndex           = 3
    let expected2xPreviousAbsoluteIndex         = 2
    let expected3xPreviousAbsoluteIndex         = 1
    let expected4xPreviousAbsoluteIndex         = 0
    
    override func setUp() {
        super.setUp()
        
        absoluteIndex                = test_10_config.absoluteIndex
        viewsCount                   = test_10_config.numberOfViews
        
        self.prepare()
    }
    
    func test_01_initialization_next_previous() {
        
        ////////// INITIALIZATION //////////
        _initialization()
        
        ////////// NEXT //////////
        _next()
        
        ////////// NEXT NEXT //////////
        _next_next()
        
        ////////// PREVIOUS //////////
        _previous()

        ////////// PREVIOUS //////////
        _previous_previous()
        
        ////////// PREVIOUS //////////
        _previous_previous_previous()
        
        ////////// PREVIOUS //////////
        _previous_previous_previous_previous()
        
    }
    
    func _initialization() {
        
        // Test number of models returned
        XCTAssertEqual(countOfModels, expectedNumberOfModels, "\nTest Failed: Expected `\(expectedNumberOfModels)` scroll view models but given `\(countOfModels)`\n")
        
        // Test model marked `current` was found
        XCTAssertNotNil(currentModel, "\nTest Failed: Model marked `current` not found\n")
        
        // Test absolute index for current model
        XCTAssertEqual(currentModel?.absoluteIndex, absoluteIndex, "\nTest Failed: Expected `\(absoluteIndex)` absolute index but given different\n")
        
        // Test x positions of the current view
        XCTAssertEqual(currentModel?.position.x, expectedCurrentXPosition, "\nTest Failed: Expected `\(expectedCurrentXPosition)` x position of the current view, but given `\(currentModel?.position.x ?? CGFloat(-9999.0))`\n")
        
        // Test relative indices
        
        var i = 0
        
        self.models.forEach { viewModel in
            XCTAssertEqual(viewModel.relativeIndex.rawValue, expectedRelativeIndices[i],
                           "\nTest Failed: Expected \(expectedRelativeIndices[i]) relative index but given \(viewModel.relativeIndex.rawValue)\n")
            
            // All models should not be marked to be shifted in the initialization process
            XCTAssertEqual(viewModel.shift, RelativeShift.none, "\nTest Failed: Expected not to be shifted at all\n")
            
            i += 1
        }
    }
    
    func _next() {
        
        self.next()
        
        // Test model marked `current` was found
        XCTAssertNotNil(currentModel, "\nTest Failed: Model marked `current` not found\n")
        
        // Test absoluteIndex of current view is not the same as absoluteIndex in config
        XCTAssertEqual(currentModel?.absoluteIndex, expectedNextAbsoluteIndex, "\nTest Failed: Expected `\(expectedNextAbsoluteIndex)` scroll view current model index but given `\(String(describing: currentModel?.absoluteIndex))`\n")
        
        // Test scrolling direction is set up
        XCTAssertNotNil(scrollingDirection, "\nTest Failed: Scrolling direction not defined\n")
        
        // Test x positions of the current view
        XCTAssertEqual(currentModel?.position.x, expectedNextXPosition, "\nTest Failed: Expected `\(expectedNextXPosition)` x position of the current view, but given `\(currentModel?.position.x ?? CGFloat(-9999.0))`\n")
        
        // Test appended index is nil
        XCTAssertNil(appendedIndex, "\nTest Failed: appendedIndex should be `nil`\n")
        
        // Test all models are marked with relative index and relative shift
        for i in 0...self.models.count-1 {
            
            XCTAssertEqual(self.models[i].relativeIndex.rawValue, expectedRelativeIndicesNext[i], "\nTest Failed: Expected relative index to be `\(expectedRelativeIndicesNext[i])` but given `\(self.models[i].relativeIndex.rawValue)`\n")
            
            // All other models are not marked to be shifted
            XCTAssertEqual(self.models[i].shift, RelativeShift.none, "\nTest Failed: Expected not to be shifted at all\n")
        }
    }
    
    func _next_next() {
        
        self.next()
        
        // Test model marked `current` was found
        XCTAssertNotNil(currentModel, "\nTest Failed: Model marked `current` not found\n")
        
        // Test absoluteIndex of current view is not the same as absoluteIndex in config
        XCTAssertEqual(currentModel?.absoluteIndex, expectedNextNextAbsoluteIndex, "\nTest Failed: Expected `\(expectedNextNextAbsoluteIndex)` scroll view current model index but given `\(String(describing: currentModel?.absoluteIndex))`\n")
        
        // Test scrolling direction is set up
        XCTAssertNotNil(scrollingDirection, "\nTest Failed: Scrolling direction not defined\n")
        
        // Test x positions of the current view
        XCTAssertEqual(currentModel?.position.x, expectedNextNextXPosition, "\nTest Failed: Expected `\(expectedNextNextXPosition)` x position of the current view, but given `\(currentModel?.position.x ?? CGFloat(-9999.0))`\n")
        
        // Test appended index is nil
        XCTAssertNil(appendedIndex, "\nTest Failed: appendedIndex should be `nil`\n")
        
        // Test all models are marked with relative index and relative shift
        for i in 0...self.models.count-1 {
            
            XCTAssertEqual(self.models[i].relativeIndex.rawValue, expectedRelativeIndicesNextNext[i], "\nTest Failed: Expected relative index to be `\(expectedRelativeIndicesNextNext[i])` but given `\(self.models[i].relativeIndex.rawValue)`\n")
            
            // All other models are not marked to be shifted
            XCTAssertEqual(self.models[i].shift, RelativeShift.none, "\nTest Failed: Expected not to be shifted at all\n")
        }
    }
    
    func _previous() {
        
        self.previous()
        
        // Test model marked `current` was found
        XCTAssertNotNil(currentModel, "\nTest Failed: Model marked `current` not found\n")
        
        // Test absoluteIndex of current view is not the same as absoluteIndex in config
        XCTAssertEqual(currentModel?.absoluteIndex, expectedPreviousAbsoluteIndex, "\nTest Failed: Expected `\(expectedPreviousAbsoluteIndex)` scroll view current model index but given `\(String(describing: currentModel?.absoluteIndex))`\n")
        
        // Test scrolling direction is set up
        XCTAssertNotNil(scrollingDirection, "\nTest Failed: Scrolling direction not defined\n")
        
        // Test x positions of the current view
        XCTAssertEqual(currentModel?.position.x, expectedPreviousXPosition, "\nTest Failed: Expected `\(expectedPreviousXPosition)` x position of the current view, but given `\(currentModel?.position.x ?? CGFloat(-9999.0))`\n")
        
        // Test appended index is nil
        XCTAssertNil(appendedIndex, "\nTest Failed: appendedIndex should be `nil`\n")
        
        // Test all models are marked with relative index and relative shift
        for i in 0...self.models.count-1 {
            
            XCTAssertEqual(self.models[i].relativeIndex.rawValue, expectedRelativeIndicesPrevious[i], "\nTest Failed: Expected relative index to be `\(expectedRelativeIndicesPrevious[i])` but given `\(self.models[i].relativeIndex.rawValue)`\n")
            
            // All other models are not marked to be shifted
            XCTAssertEqual(self.models[i].shift, RelativeShift.none, "\nTest Failed: Expected not to be shifted at all\n")
        }
    }
    
    func _previous_previous() {
        
        self.previous()
        
        // Test model marked `current` was found
        XCTAssertNotNil(currentModel, "\nTest Failed: Model marked `current` not found\n")
        
        // Test absoluteIndex of current view is not the same as absoluteIndex in config
        XCTAssertEqual(currentModel?.absoluteIndex, expected2xPreviousAbsoluteIndex, "\nTest Failed: Expected `\(expected2xPreviousAbsoluteIndex)` scroll view current model index but given `\(String(describing: currentModel?.absoluteIndex))`\n")
        
        // Test scrolling direction is set up
        XCTAssertNotNil(scrollingDirection, "\nTest Failed: Scrolling direction not defined\n")
        
        // Test x positions of the current view
        XCTAssertEqual(currentModel?.position.x, expected2xPreviousXPosition, "\nTest Failed: Expected `\(expected2xPreviousXPosition)` x position of the current view, but given `\(currentModel?.position.x ?? CGFloat(-9999.0))`\n")
        
        // Test appended index is nil
        XCTAssertNil(appendedIndex, "\nTest Failed: appendedIndex should be `nil`\n")
        
        // Test all models are marked with relative index and relative shift
        for i in 0...self.models.count-1 {
            
            XCTAssertEqual(self.models[i].relativeIndex.rawValue, expectedRelativeIndices2xPrevious[i], "\nTest Failed: Expected relative index to be `\(expectedRelativeIndices2xPrevious[i])` but given `\(self.models[i].relativeIndex.rawValue)`\n")
            
            // All other models are not marked to be shifted
            XCTAssertEqual(self.models[i].shift, RelativeShift.none, "\nTest Failed: Expected not to be shifted at all\n")
        }
    }
    
    func _previous_previous_previous() {
        
        self.previous()
        
        // Test model marked `current` was found
        XCTAssertNotNil(currentModel, "\nTest Failed: Model marked `current` not found\n")
        
        // Test absoluteIndex of current view is not the same as absoluteIndex in config
        XCTAssertEqual(currentModel?.absoluteIndex, expected3xPreviousAbsoluteIndex, "\nTest Failed: Expected `\(expected3xPreviousAbsoluteIndex)` scroll view current model index but given `\(String(describing: currentModel?.absoluteIndex))`\n")
        
        // Test scrolling direction is set up
        XCTAssertNotNil(scrollingDirection, "\nTest Failed: Scrolling direction not defined\n")
        
        // Test x positions of the current view
        XCTAssertEqual(currentModel?.position.x, expected3xPreviousXPosition, "\nTest Failed: Expected `\(expected3xPreviousXPosition)` x position of the current view, but given `\(currentModel?.position.x ?? CGFloat(-9999.0))`\n")
        
        // Test appended index is nil
        XCTAssertNil(appendedIndex, "\nTest Failed: appendedIndex should be `nil`\n")
        
        // Test all models are marked with relative index and relative shift
        for i in 0...self.models.count-1 {
            
            XCTAssertEqual(self.models[i].relativeIndex.rawValue, expectedRelativeIndices3xPrevious[i], "\nTest Failed: Expected relative index to be `\(expectedRelativeIndices3xPrevious[i])` but given `\(self.models[i].relativeIndex.rawValue)`\n")
            
            // All other models are not marked to be shifted
            XCTAssertEqual(self.models[i].shift, RelativeShift.none, "\nTest Failed: Expected not to be shifted at all\n")
        }
    }
    
    func _previous_previous_previous_previous() {
        
        self.previous()
        
        // Test model marked `current` was found
        XCTAssertNotNil(currentModel, "\nTest Failed: Model marked `current` not found\n")
        
        // Test absoluteIndex of current view is not the same as absoluteIndex in config
        XCTAssertEqual(currentModel?.absoluteIndex, expected4xPreviousAbsoluteIndex, "\nTest Failed: Expected `\(expected4xPreviousAbsoluteIndex)` scroll view current model index but given `\(String(describing: currentModel?.absoluteIndex))`\n")
        
        // Test scrolling direction is set up
        XCTAssertNotNil(scrollingDirection, "\nTest Failed: Scrolling direction not defined\n")
        
        // Test x positions of the current view
        XCTAssertEqual(currentModel?.position.x, expected4xPreviousXPosition, "\nTest Failed: Expected `\(expected4xPreviousXPosition)` x position of the current view, but given `\(currentModel?.position.x ?? CGFloat(-9999.0))`\n")
        
        // Test appended index is nil
        XCTAssertNil(appendedIndex, "\nTest Failed: appendedIndex should be `nil`\n")
        
        // Test all models are marked with relative index and relative shift
        for i in 0...self.models.count-1 {
            
            XCTAssertEqual(self.models[i].relativeIndex.rawValue, expectedRelativeIndices4xPrevious[i], "\nTest Failed: Expected relative index to be `\(expectedRelativeIndices4xPrevious[i])` but given `\(self.models[i].relativeIndex.rawValue)`\n")
            
            // All other models are not marked to be shifted
            XCTAssertEqual(self.models[i].shift, RelativeShift.none, "\nTest Failed: Expected not to be shifted at all\n")
        }
    }
    
}
