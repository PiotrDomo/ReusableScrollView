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
 absolute index: 8
 number of views: 15
 
 Test includes:
 1. Initialization, request next, next, request previous, previous all in one test case
 
 Test Expectation
 1. Number of models: 5
 2. Current model: defined
 3. Current model absolute index: 8
 4. Current model relative index: RelativeIndex.current
 5. Current model view position x: 800.0
 6. Next model view position x: 900.0
 7. Next next model view position x: 1000.0
 8. Appended next index: 11
 9. Appended next next index: 12
 10. Relative shift for next: RelativeShift.fromLeftToRight
 11. Relative shift for next next: RelativeShift.fromLeftToRight
 12. Previous model view position x: 900.0
 13. Previous previous model view position x: 900.0
 14. Appended previous index: 7
 15. Appended previous previous index: 6
 16. Relative shift for previous: RelativeShift.fromRightToLeft
 17. Relative shift for previous previous: RelativeShift.fromRightToLeft
 
 */

class ScrollEngine_9_Tests : ScrollEngineBase {
    
    let expectedNumberOfModels                  = 5
    let expectedRelativeIndices                 = [-2,-1,0,1,2]
    let expectedCurrentRelativeIndex            = RelativeIndex.current
    let expectedCurrentXPosition                = CGFloat(800)
    let expectedNextXPosition                   = CGFloat(900)
    let expectedNextNextXPosition               = CGFloat(1000)
    let expectedPreviousXPosition               = CGFloat(900)
    let expectedPreviousPreviousXPosition       = CGFloat(800)
    let expectedApendedNextIndex                = 11
    let expectedApendedNextNextIndex            = 12
    let expectedApendedPreviousIndex            = 7
    let expectedApendedPreviousPreviousIndex    = 6
    let relativeShiftForNext                    = RelativeShift.fromLeftToRight
    let relativeShiftForPrevious                = RelativeShift.fromRightToLeft
    let expectedNextAbsoluteIndex               = 9
    let expectedNextNextAbsoluteIndex           = 10
    let expectedPreviousAbsoluteIndex           = 9
    let expectedPreviousPreviousAbsoluteIndex   = 8
    
    override func setUp() {
        super.setUp()
        
        absoluteIndex                = test_9_config.absoluteIndex
        viewsCount                   = test_9_config.numberOfViews
        
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
        
        // Test appended index
        XCTAssertEqual(appendedIndex, expectedApendedNextIndex, "\nTest Failed: appendedIndex should be `\(expectedApendedNextIndex)` but given \(appendedIndex ?? -9999)\n")
        
        // Test all models are marked with relative index and relative shift
        for i in 0...self.models.count-1 {
            
            XCTAssertEqual(self.models[i].relativeIndex.rawValue, expectedRelativeIndices[i], "\nTest Failed: Expected relative index to be `\(expectedRelativeIndices[i])` but given `\(self.models[i].relativeIndex.rawValue)`\n")
            
            // Only forst marked to be shifted
            if i == self.models.count-1 {
                XCTAssertEqual(self.models[i].shift, relativeShiftForNext, "\nTest Failed: Expected to be shifted `From Left To Right`\n")
                continue
            }
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
        
        // Test appended index
        XCTAssertEqual(appendedIndex, expectedApendedNextNextIndex, "\nTest Failed: appendedIndex should be `\(expectedApendedNextNextIndex)` but given \(appendedIndex ?? -9999)\n")
        
        // Test all models are marked with relative index and relative shift
        for i in 0...self.models.count-1 {
            
            XCTAssertEqual(self.models[i].relativeIndex.rawValue, expectedRelativeIndices[i], "\nTest Failed: Expected relative index to be `\(expectedRelativeIndices[i])` but given `\(self.models[i].relativeIndex.rawValue)`\n")
            
            // Only forst marked to be shifted
            if i == self.models.count-1 {
                XCTAssertEqual(self.models[i].shift, relativeShiftForNext, "\nTest Failed: Expected to be shifted `From Left To Right`\n")
                continue
            }
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
        
        // Test appended index
        XCTAssertEqual(appendedIndex, expectedApendedPreviousIndex, "\nTest Failed: appendedIndex should be `\(expectedApendedPreviousIndex)` but given \(appendedIndex ?? -9999)\n")
        
        // Test all models are marked with relative index and relative shift
        for i in 0...self.models.count-1 {
            
            XCTAssertEqual(self.models[i].relativeIndex.rawValue, expectedRelativeIndices[i], "\nTest Failed: Expected relative index to be `\(expectedRelativeIndices[i])` but given `\(self.models[i].relativeIndex.rawValue)`\n")
            
            // Only forst marked to be shifted
            if i == 0 {
                XCTAssertEqual(self.models[i].shift, relativeShiftForPrevious, "\nTest Failed: Expected to be shifted `From Right To Left`\n")
                continue
            }
            // All other models are not marked to be shifted
            XCTAssertEqual(self.models[i].shift, RelativeShift.none, "\nTest Failed: Expected not to be shifted at all\n")
        }
    }
    
    func _previous_previous() {
        
        self.previous()
        
        // Test model marked `current` was found
        XCTAssertNotNil(currentModel, "\nTest Failed: Model marked `current` not found\n")
        
        // Test absoluteIndex of current view is not the same as absoluteIndex in config
        XCTAssertEqual(currentModel?.absoluteIndex, expectedPreviousPreviousAbsoluteIndex, "\nTest Failed: Expected `\(expectedPreviousPreviousAbsoluteIndex)` scroll view current model index but given `\(String(describing: currentModel?.absoluteIndex))`\n")
        
        // Test scrolling direction is set up
        XCTAssertNotNil(scrollingDirection, "\nTest Failed: Scrolling direction not defined\n")
        
        // Test x positions of the current view
        XCTAssertEqual(currentModel?.position.x, expectedPreviousPreviousXPosition, "\nTest Failed: Expected `\(expectedPreviousPreviousXPosition)` x position of the current view, but given `\(currentModel?.position.x ?? CGFloat(-9999.0))`\n")
        
        // Test appended index
        XCTAssertEqual(appendedIndex, expectedApendedPreviousPreviousIndex, "\nTest Failed: appendedIndex should be `\(expectedApendedPreviousPreviousIndex)` but given \(appendedIndex ?? -9999)\n")
        
        // Test all models are marked with relative index and relative shift
        for i in 0...self.models.count-1 {
            
            XCTAssertEqual(self.models[i].relativeIndex.rawValue, expectedRelativeIndices[i], "\nTest Failed: Expected relative index to be `\(expectedRelativeIndices[i])` but given `\(self.models[i].relativeIndex.rawValue)`\n")
            
            // Only forst marked to be shifted
            if i == 0 {
                XCTAssertEqual(self.models[i].shift, relativeShiftForPrevious, "\nTest Failed: Expected to be shifted `From Right To Left`\n")
                continue
            }
            // All other models are not marked to be shifted
            XCTAssertEqual(self.models[i].shift, RelativeShift.none, "\nTest Failed: Expected not to be shifted at all\n")
        }
    }
    
}
