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
    
    override open func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        
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
    
    // MARK: Overriding
    
    override open func responds(to aSelector: Selector) -> Bool {
        
        print("responds called for selector", aSelector)
        
        let respondesToSelector: Bool = super.responds(to: aSelector) ||  _delegate?.responds(to: aSelector) == true
        
        return respondesToSelector
    }
    
    override open func forwardingTarget(for aSelector: Selector!) -> Any? {
        print("forwardingTarget called for selector", aSelector)
        
        if _delegate?.responds(to: aSelector) == true {
            return _delegate
        }
        else {
            return super.forwardingTarget(for: aSelector)
        }
    }
}

extension ReusableScrollView: UIScrollViewDelegate {
    
    // MARK: UIScrollViewdelegate
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        _lastContentOffset = scrollView.contentOffset.x
        
        _delegate?.scrollViewWillBeginDragging?(scrollView)
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // Simply check the half of the width of view was scrolled by defining what is going to be following index
        // If the following index is the same as cached index then the scroll should not happen
        let followingIndex = Int(floor((self.contentOffset.x - size.width / 2) / size.width))
        
        guard _currentIndex != followingIndex else {
            return
        }
        
        updateEngine()
        
        _delegate?.scrollViewDidScroll?(scrollView)
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let offset = _lastContentOffset else {
            return
        }
        
        if offset > scrollView.contentOffset.x {
            scrollEngine.previous()
        } else if offset < scrollView.contentOffset.x {
            scrollEngine.next()
        }
        
        _delegate?.scrollViewDidEndDecelerating?(scrollView)
    }
    
}

extension ReusableScrollView {
    
    // MARK: ScrollEngineProtocol
    
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
