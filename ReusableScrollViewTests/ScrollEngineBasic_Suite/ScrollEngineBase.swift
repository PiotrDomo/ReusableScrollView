//
//  ImagesScrollEngineTests.swift
//  ImagesScrollEngineTests
//
//  Created by sumofighter666 on 11.04.18.
//  Copyright © 2018 sumofighter666. All rights reserved.
//

import XCTest
@testable import ReusableScrollView

extension ScrollEngineBase: ScrollEngineDataSource {
    var initialIndex: Int {
        return absoluteIndex
    }
    
    var numberOfViews: UInt {
        return self.viewsCount
    }
    
    var size:CGSize {
        return self.innerViewSize
    }
}

extension ScrollEngineBase: ScrollEngineDelegate {
    
    func didUpdateRelativeIndices(direction: ScrollingDirection, models:[ScrollViewModel], addedIndex:Int?) {
        appendedIndex = addedIndex
        scrollingDirection = direction
        relativeIndicesUpdateExpectation.fulfill()
    }
    
    func didRequestView(engine: ScrollEngine, model: ScrollViewModel) {
        models.append(model)
    }
    
    func didFinishViewDecalration(engine: ScrollEngine, models:[ScrollViewModel]) -> Void {
        declarationExpectation.fulfill()
    }
    
}


class ScrollEngineBase: XCTestCase {
    
    var absoluteIndex:Int   = 0
    var viewsCount:UInt     = 1
    var declarationExpectation: XCTestExpectation!
    var relativeIndicesUpdateExpectation: XCTestExpectation!
    var innerViewSize:CGSize = CGSize(width: 100.0, height: 100.0) // Default
    
    // Properties to test
    var models:[ScrollViewModel] = [ScrollViewModel]()
    var scrollingDirection:ScrollingDirection?
    var appendedIndex:Int?
    
    lazy var scrollEngine:ScrollEngine = {
        
        let scrollEngine = ScrollEngine()
        scrollEngine.dataSource = self
        scrollEngine.delegate = self
            
        return scrollEngine
        
    }()
    
    var countOfModels:Int {
        
        get {
            return self.models.count
        }
        
    }
    
    var currentModel:ScrollViewModel? {
        
        get {
            
            var model:ScrollViewModel?
            
            self.models.forEach { viewModel in
                if viewModel.relativeIndex == RelativeIndex.current {
                    model = viewModel
                }
            }
            
            return model
        }
        
    }
    
    func prepare() {
        declarationExpectation = expectation(description: "Declaration expectation")
        scrollEngine.build()
        waitForExpectations(timeout: 100)
        
    }
    
    func next() {
        
        relativeIndicesUpdateExpectation = expectation(description: "Relative Indices Update Expectation")
        scrollEngine.next()
        waitForExpectations(timeout: 100)
        
    }
    
    func previous() {
        
        relativeIndicesUpdateExpectation = expectation(description: "Relative Indices Update Expectation")
        scrollEngine.previous()
        waitForExpectations(timeout: 100)
        
    }
    
    // MARK: Plan
    let test_1_config = (absoluteIndex: 2, numberOfViews: UInt(6))
    let test_2_config = (absoluteIndex: 1, numberOfViews: UInt(4))
    let test_3_config = (absoluteIndex: 1, numberOfViews: UInt(5))
    let test_4_config = (absoluteIndex: 2, numberOfViews: UInt(5))
    let test_5_config = (absoluteIndex: 3, numberOfViews: UInt(5))
    let test_6_config = (absoluteIndex: 2, numberOfViews: UInt(4))
    
}
