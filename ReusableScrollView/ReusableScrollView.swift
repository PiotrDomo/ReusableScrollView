//  ReusableScrollView.swift

/*
 
 MIT License
 
 Copyright (c) 2018 ReusableScrollView (https://github.com/sumofighter666/ReusableScrollView)
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 
 */

import UIKit

@objc public protocol ReusableScrollViewDataSource: class {
    
    /**
     
     Asks the data source to return the number of views in the reusable scroll view.
     
     */
    
    var numberOfViews:UInt { get }
    
    /**
     
     Required to define starting index of the scroll view.
     
     */
    
    var initialIndex:Int { get }
    
    /**
     
     Asks the data source to return the delay time after which the current view will be replaced. Provide value 0 to invalidate delay.
     
     - seealso: `reusableViewDidFocus(reusableView:ReusableView)`
     
     */
    
    var focusDelay:TimeInterval { get }
    
}

@objc public protocol ReusableScrollViewDelegate: UIScrollViewDelegate {
    
    /**
     
     Called every time when the view needs to be represented by index that is not included in the pool.
     I.e. It is called in the initialization step for all the views necessary.
     If the number of views is 10 and current index is 3 it will be called 5 times - 2 for previous views, 1 for current and 2 for following views.
     
     When scroll view is scrolled in whichever direction, it will call the method (if necessary) to request the view for new index in the pool.
     Use this method to set up placeholder view .
     
     - parameters:
     
        - reusableView: reference to reusable view which is going to be called
        - atIndex: index of reusable view that is going to be called
     
     */
    
    func scrollViewDidRequestView(reusableScrollView:ReusableScrollView, atIndex:Int) -> UIView
    
    /**
     
     This delegate method is called for every visible view after `focus delay` time elapsed. If the view is scrolled to the next view before `focus delay` has elapsed this method will not be called. Use this method to replace placeholder view with active view
     
     - parameters:
     
        - reusableView: current reusable view
     
     - seealso: `focusDelay:TimeInterval`
     
    */
    
    func reusableViewDidFocus(reusableView:ReusableView) -> Void
}

open class ReusableScrollView: UIScrollView {
    
    // MARK: - Private properties
    
    private weak var _delegate:ReusableScrollViewDelegate?
    
    private var _isLandscape:Bool?
    private var _scrollEngine:ScrollEngine = ScrollEngine()
    private var _didFinishDeclaration: Bool = false
    private var _task:DispatchWorkItem?
    private var _lastContentOffset:CGFloat?
    private var _cachedIndex:Int?
    private var _contentViews:[ReusableView] = [ReusableView]()
    
    private var _currentIndex:Int {
        get {
            return Int(contentOffset.x / size.width)
        }
    }
    
    private var shouldUpdateScrollView:Bool {
        if let isLandscape = _isLandscape,
            (isLandscape == DeviceInfo.Orientation.isLandscape || !isLandscape == DeviceInfo.Orientation.isPortrait) {
            return false
        }
        
        _isLandscape = DeviceInfo.Orientation.isLandscape
        
        return true
    }
    
    lazy private var _build: () = {
        self._scrollEngine.delegate = self
        self._scrollEngine.dataSource = self
        self._scrollEngine.build()
        self._contentViews = self.subviews as! [ReusableView]
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }()
    
    // MARK: - Public properties
    
    @IBOutlet open var dataSource:ReusableScrollViewDataSource?
    
    override open var contentSize: CGSize {
        get {
            return super.contentSize
        }
        set {
            
            if newValue != super.contentSize {
                super.contentSize = newValue
                _didFinishDeclaration = false
                _ = _build
            }
        }
    }
    
    override weak open var delegate: UIScrollViewDelegate? {
        get {
            return _delegate
        }
        set {
            _delegate = newValue as? ReusableScrollViewDelegate
            super.delegate = self
        }
    }
    
    // MARK: Lifecycle
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.isDirectionalLockEnabled = true
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    // MARK: - Public
    
    /**
     
     Requests reuasable view associated to relative index.
     
     - parameters:
     
     - atRelativeIndex: relative index at which view should be returned
     
     - returns: reuasable view for provided index. If view is not available returns `nil`
     
     */
    @objc public func reusableView(atRelativeIndex:RelativeIndex) -> ReusableView? {
        var contentViews:[ReusableView] = self.subviews as! [ReusableView]
        
        logDebug("\n-ReusableScrollView.reusableView(atRelativeIndex:)")
        
        for i in 0 ..< contentViews.count {
            guard let viewModel = contentViews[i].viewModel else {
                continue
            }
            if viewModel.relativeIndex == atRelativeIndex {
                return contentViews[i]
            }
        }
        
        logDebug("   reusableView at relative index \(atRelativeIndex) not yet added")
        
        return nil
    }
    
    /**
     
     Requests reuasable view associated to absolute index.
     
     - parameters:
     
     - atAbsoluteIndex: absolute index at which view should be returned
     
     - returns: reuasable view for provided index. If view is not available returns `nil`
     
     */
    @objc public func reusableView(atAbsoluteIndex:Int) -> ReusableView? {
        var contentViews:[ReusableView] = self.subviews as! [ReusableView]
        
        logDebug("\n-ReusableScrollView.reusableView(atIndex:)")
        
        for i in 0 ..< contentViews.count {
            guard let viewModel = contentViews[i].viewModel else {
                continue
            }
            if viewModel.absoluteIndex == atAbsoluteIndex {
                return contentViews[i]
            }
        }
        
        logDebug("   reusableView at index \(atAbsoluteIndex) not yet added")
        
        return nil
    }
    
    // MARK: Private
    
    @objc private func reload() {
        
        guard shouldUpdateScrollView == true else {
            return
        }
        
        subviews.forEach{
            $0.removeFromSuperview()
        }
        
        _scrollEngine = ScrollEngine()
        _scrollEngine.delegate = self
        _scrollEngine.dataSource = self
        _scrollEngine.build()
        _contentViews = self.subviews as! [ReusableView]
    }
    
    private func update(_ scrollView: UIScrollView) {
        guard _didFinishDeclaration == true else {
            return
        }
        
        // Simply check the half of the width of view was scrolled by defining what is going to be following index
        // If the following index is the same as cached index then the scroll should not happen
        let followingIndex = Int(floor((contentOffset.x - size.width / 2) / size.width))
        
        guard followingIndex != _currentIndex else {
            return
        }
        
        logVerbose("\n-ReusableScrollView.scrollViewDidScroll")
        logVerbose("   Current index of view calculated from scroll view location: \(_currentIndex)")
        logVerbose("   Current index of view defined by event: \(_scrollEngine.currentIndex)")
        logVerbose("   Following index of view calculated from scroll event: \(followingIndex)")
        
        updateEngine()
        
        _delegate?.scrollViewDidScroll?(scrollView)
    }
    
    private func updateEngine() {
        
        let adjustVariable = _scrollEngine.currentIndex - _currentIndex
        
        for _ in 0..<abs(adjustVariable) {
            adjustVariable > 0 ? _scrollEngine.previous() : _scrollEngine.next()
            
            logDebug("\n-updateEngine()")
            logDebug("Scroll engine updated")
            logVerbose("   Current index of view defined by event: \(_scrollEngine.currentIndex)")
            logVerbose("   Current index of view calculated from scroll view location: \(_currentIndex)")
        }
    }
    
    private func focus() {
        guard let time = dataSource?.focusDelay, let confTask = _task else {
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
        let actualPosition = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
        
        if actualPosition.y != 0 {
            return
        }
        
        if -5...5 ~= actualPosition.x {
            return
        }
        
        _lastContentOffset = scrollView.contentOffset.x
        
        _task?.cancel()
        
        _delegate?.scrollViewWillBeginDragging?(scrollView)
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // It is ugly, but we need to delay for orientation update.
        // Investigate better solution
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.update(scrollView)
        }
    }
    
}

extension ReusableScrollView: ScrollEngineDelegate, ScrollEngineDataSource {
    
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
        
        if let cachedIndex = _cachedIndex {
            return cachedIndex
        }
        
        guard let source = dataSource else {
            return 0
        }
        
        return source.initialIndex
        
    }
    
    public func didFinishViewDecalration(engine: ScrollEngine, models: [ScrollViewModel]) {
        for i in 0 ..< models.count {
            if models[i].relativeIndex != RelativeIndex.current {
                continue
            }
            
            _didFinishDeclaration = true
            _task?.cancel()
    
            _task = DispatchWorkItem {
                self._delegate?.reusableViewDidFocus(reusableView: self._contentViews[i])
            }
            
            self.contentOffset = models[i].position
            
            focus()
        }
    }
    
    public func didUpdateRelativeIndices(direction: ScrollingDirection, models: [ScrollViewModel], addedIndex: Int?) {
        
        logDebug("\n-ReusableScrollView.didUpdateRelativeIndices(direction:, models:, addedIndex:?)")

        for i in 0 ..< models.count {
            _contentViews[i].viewModel = models[i]
            _contentViews[i].updateFrame()
            
            logVerbose("   Current relative index of reusable view: \(models[i].relativeIndex.rawValue)")
            
            guard models[i].relativeIndex == RelativeIndex.current else {
                continue
            }
            
            _cachedIndex = _scrollEngine.currentIndex
            
            _task?.cancel()
            
            _task = DispatchWorkItem {
                
                guard self._contentViews.isEmpty == false else {
                    return
                }
                
                self._delegate?.reusableViewDidFocus(reusableView: self._contentViews[i])
            }
            
            focus()
        }
        
        // We need to sort the views by index value
        // so when the next time relative indices are called to be updated
        // we can work on the views that are correctly arranged
        _contentViews.sort {
            return $0.absoluteIndex < $1.absoluteIndex
        }
        
        guard
            let newIndex = addedIndex,
            let del = _delegate
        else {
            return
        }
        
        // If there is new index added to the pool we request content of reusable view but we don't add new one
        // as it should be already added to existing reusable view when called in -didRequestView(engine:model:) delegate method
        let _ = del.scrollViewDidRequestView(reusableScrollView:self, atIndex: newIndex)
        
    }
    
    public func didRequestView(engine: ScrollEngine, model: ScrollViewModel) {
        
        guard let del = _delegate else {
            return
        }
        
        let frame = CGRect(x: model.position.x,
                           y: model.position.y,
                           width: self.size.width,
                           height: self.size.height)
        
        let reusableView = ReusableView(frame: frame)
        reusableView.viewModel = model
        
        reusableView.contentView = del.scrollViewDidRequestView(reusableScrollView:self, atIndex: model.absoluteIndex)
        
        self.addSubview(reusableView)
        
    }
}
