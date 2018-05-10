//
//  ReusableScrollView.swift
//  ReusableScrollView
//
//  Created by sumofighter666 on 09.05.18.
//  Copyright © 2018 sumofighter666. All rights reserved.
//

import UIKit

@objc public protocol ReusableScrollViewDataSource: class {
    
    var numberOfViews:UInt {get}
    
    var initialIndex:Int {get}
    
}

@objc public protocol ReusableScrollViewDelegate: UIScrollViewDelegate {
    
    func reusableScrollViewDidRequestView(reusableScrollView:ReusableScrollView, model:ScrollViewModel) -> ReusableView
    
    func reusableViewDidFocus(reusableView:ReusableView) -> Void
}

open class ReusableScrollView: UIScrollView, ScrollEngineDelegate, ScrollEngineDataSource {
    
    // MARK: Properties
    
    private let scrollEngine:ScrollEngine = ScrollEngine()
    weak private var _delegate:ReusableScrollViewDelegate?
    @IBOutlet weak open var dataSource:ReusableScrollViewDataSource?
    
    override weak open var delegate: UIScrollViewDelegate? {
        didSet {
            _delegate = delegate as? ReusableScrollViewDelegate
        }
    }
    
    private var _lastContentOffset:CGFloat?
    private var _currentIndex:Int {
        get {
            return Int(self.contentOffset.x / size.width)
        }
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        setup()
        
        scrollEngine.build()
    }
    
    // MARK: Private
    
    private func setup() {
    
        scrollEngine.delegate = self
        scrollEngine.dataSource = self
        
    }
    
    private func updateEngine() {
        
        let adjustVariable = scrollEngine.currentIndex - _currentIndex
        
        for _ in 0..<abs(adjustVariable) {
            adjustVariable > 0 ? scrollEngine.previous() : scrollEngine.next()
            print("\(scrollEngine.currentIndex) - \(_currentIndex)")
        }
        
    }
    
    // MARK: UIScrollViewdelegate
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        _lastContentOffset = scrollView.contentOffset.x
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // Simply check the half of the width of view was scrolled by defining what is going to be following index
        // If the following index is the same as cached index then the scroll should not happen
        let followingIndex = Int(floor((self.contentOffset.x - size.width / 2) / size.width))
        
        guard _currentIndex != followingIndex else {
            return
        }
        
        updateEngine()
    }
}

extension ReusableScrollView {
    
    public var size: CGSize {
        get {
            return self.bounds.size
        }
    }
    
    public var numberOfViews: UInt {
        guard let source = dataSource else {
            return 0
        }
        
        return source.numberOfViews
    }
    
    public var initialIndex: Int {
        
        guard let source = dataSource else {
            return 0
        }
        
        return source.initialIndex
        
    }
    
    public func didFinishViewDecalration(engine: ScrollEngine, models: [ScrollViewModel]) {
        models.forEach { model in
            if model.relativeIndex == RelativeIndex.current {
                self.contentOffset = model.position
            }
        }
    }
    
    public func didUpdateRelativeIndices(direction: ScrollingDirection, models: [ScrollViewModel]) {
        var contentViews:[ReusableView] = self.subviews as! [ReusableView]
        
        for i in 0 ..< models.count {
            contentViews[i].viewModel = models[i]
            contentViews[i].updateFrame()
        }
    }
    
    public func didRequestView(engine: ScrollEngine, model: ScrollViewModel) {
        
        guard let del = _delegate else {
            return
        }
        
        let reusableView:ReusableView    = del.reusableScrollViewDidRequestView(reusableScrollView: self, model: model)
        reusableView.viewModel           = model
        
        self.addSubview(reusableView)
        
    }
}
