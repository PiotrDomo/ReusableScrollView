//  ReusableScrollView.swift

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

import UIKit

@objc public protocol ReusableScrollViewDataSource: class {
    
    var numberOfViews:UInt { get }
    
    var initialIndex:Int { get }
    
    var focusDelay:TimeInterval { get }
    
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
    var task:DispatchWorkItem?
    
    override weak open var delegate: UIScrollViewDelegate? {
        get {
            return _delegate
        }
        set {
            _delegate = newValue as? ReusableScrollViewDelegate
            super.delegate = self
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
            
            logDebug("\n-updateEngine()")
            logDebug("Scroll engine updated")
            logVerbose("   Current index of view defined by event: \(scrollEngine.currentIndex)")
            logVerbose("   Current index of view calculated from scroll view location: \(_currentIndex)")
        }
    }
    
    private func focus() {
        guard let time = self.dataSource?.focusDelay, let confTask = task else {
            return
        }
        
        // execute task
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time, execute: confTask)
    }
    
    // MARK: Overriding
    
    override open func responds(to aSelector: Selector) -> Bool {
        
        let respondesToSelector: Bool = super.responds(to: aSelector) ||  _delegate?.responds(to: aSelector) == true
        
        return respondesToSelector
    }
    
    override open func forwardingTarget(for aSelector: Selector!) -> Any? {
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
        
        guard let confTask = task else {
            _delegate?.scrollViewWillBeginDragging?(scrollView)
            return
        }
        
        confTask.cancel()
        
        _delegate?.scrollViewWillBeginDragging?(scrollView)
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // Simply check the half of the width of view was scrolled by defining what is going to be following index
        // If the following index is the same as cached index then the scroll should not happen
        let followingIndex = Int(floor((self.contentOffset.x - size.width / 2) / size.width))
        
        guard followingIndex != _currentIndex else {
            return
        }
        
        logVerbose("\n-scrollViewDidScroll")
        logVerbose("   Current index of view calculated from scroll view location: \(_currentIndex)")
        logVerbose("   Current index of view defined by event: \(scrollEngine.currentIndex)")
        logVerbose("   Following index of view calculated from scroll event: \(followingIndex)")
        
        updateEngine()
        
        _delegate?.scrollViewDidScroll?(scrollView)
    }
    
}

//extension ReusableScrollView {
//
//    func delay(time:TimeInterval, closure: @escaping ()->()) ->  dispatch_cancelable_closure? {
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + time) {
//            closure()
//        }
//
//
//        var closure:dispatch_block_t? = closure
//        var cancelableClosure:dispatch_cancelable_closure?
//
//        let delayedClosure:dispatch_cancelable_closure = { cancel in
//            if let clsr = closure {
//                if (cancel == false) {
//                    DispatchQueue.async(DispatchQueue.main, clsr)
//                }
//            }
//            closure = nil
//            cancelableClosure = nil
//        }
//
//        cancelableClosure = delayedClosure
//
//        dispatch_later {
//            if let delayedClosure = cancelableClosure {
//                delayedClosure(cancel: false)
//            }
//        }
//
//        return cancelableClosure;
//    }
//
//    func cancel_delay(closure:dispatch_cancelable_closure?) {
//        if closure != nil {
//            closure!(cancel: true)
//        }
//    }
//}

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
        
        logDebug("\n-didUpdateRelativeIndices(direction:, models:)")
        
        for i in 0 ..< models.count {
            contentViews[i].viewModel = models[i]
            contentViews[i].updateFrame()
            
            logVerbose("   Current relative index of reusable view: \(models[i].relativeIndex.rawValue)")
            
            guard models[i].relativeIndex == RelativeIndex.current else {
                continue
            }
            
            task = DispatchWorkItem {
                self._delegate?.reusableViewDidFocus(reusableView: contentViews[i])
            }
            
            focus()
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
