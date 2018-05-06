//
//  ViewController.swift
//  ImageScroller
//
//  Created by sumofighter666 on 25.04.18.
//  Copyright © 2018 sumofighter666. All rights reserved.
//

import UIKit
import ReusableScrollView

class ViewController: UIViewController, UIScrollViewDelegate, ScrollEngineDelegate, ScrollEngineDataSource {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    let scrollEngine:ScrollEngine = ScrollEngine(index: 7)
    let viewsCount:UInt = 10
    
    lazy private var _size:CGSize = {
        return scrollView.bounds.size
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        scrollEngine.delegate = self
        scrollEngine.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Calling scroll engine here after layout was updated with all constraints included
        
        let contentWidth = _size.width * CGFloat(viewsCount)
        
        scrollView.contentSize = CGSize(width: contentWidth, height: _size.height)
        scrollView.layer.borderColor = UIColor.black.cgColor
        scrollView.layer.borderWidth = 1
        
        scrollEngine.build()
    }
    
    // MARK: Private
    
    func updateEngine() {
        
        let adjustVariable = scrollEngine.currentIndex - _currentIndex
        
        for _ in 0..<abs(adjustVariable) {
            adjustVariable > 0 ? scrollEngine.previous() : scrollEngine.next()
            print("\(scrollEngine.currentIndex) - \(_currentIndex)")
        }
        
    }
    
    // MARK: UIScrollViewdelegate
    
    private var _lastContentOffset:CGFloat?
    private var _currentIndex:Int {
        get {
            return Int(scrollView.contentOffset.x / _size.width)
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        _lastContentOffset = scrollView.contentOffset.x
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // Simply check the half of the width of view was scrolled by defining what is going to be following index
        // If the following index is the same as cached index then the scroll should not happen
        let followingIndex = Int(floor((self.scrollView.contentOffset.x - _size.width / 2) / _size.width))
        
        guard _currentIndex != followingIndex else {
            return
        }
        
        updateEngine()
    }
    
    // MARK: ScrollEngineDelegate
    
    func didUpdateRelativeIndices(direction: ScrollingDirection, models:[ScrollViewModel]) -> Void {
        
        var contentViews:[ContentView] = scrollView.subviews as! [ContentView]
        
        for i in 0 ..< models.count {
            contentViews[i].viewModel = models[i]
            contentViews[i].updateFrame()
        }
    }
    
    func didRequestView(engine: ScrollEngine, model: ScrollViewModel) -> Void {
        
        let frame = CGRect(x: model.position.x, y: model.position.y, width: _size.width, height: _size.height)
        
        let contentView:ContentView     = ContentView(frame: frame)
        contentView.viewModel           = model
        contentView.backgroundColor     = UIColor.white
        contentView.alpha               = model.relativeIndex == RelativeIndex.current ? 1 : 0.5
        contentView.layer.borderColor   = UIColor.red.cgColor
        contentView.layer.borderWidth   = 1
        scrollView.addSubview(contentView)
    }
    
    func didFinishViewDecalration(engine: ScrollEngine, models:[ScrollViewModel]) -> Void {
        models.forEach { model in
            if model.relativeIndex == RelativeIndex.current {
                self.scrollView.contentOffset = model.position
            }
        }
    }
    
    // MARK: ScrollEngineDataSource
    
    var size: CGSize {
        return _size
    }
    
    var numberOfViews: UInt {
        return viewsCount
    }
    
}

