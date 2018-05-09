//
//  ViewController.swift
//  ImageScroller
//
//  Created by sumofighter666 on 25.04.18.
//  Copyright © 2018 sumofighter666. All rights reserved.
//

import UIKit
import ReusableScrollView

class ViewController: UIViewController, ReusableScrollViewDelegate, ReusableScrollViewDataSource {
    
    @IBOutlet weak var scrollView: ReusableScrollView!
    
    let viewsCount:UInt = 10
    
    lazy private var _size:CGSize = {
        return scrollView.bounds.size
    }()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let contentWidth = _size.width * CGFloat(viewsCount)
        
        scrollView.contentSize = CGSize(width: contentWidth, height: _size.height)
        scrollView.layer.borderColor = UIColor.black.cgColor
        scrollView.layer.borderWidth = 1

    }

    
    // MARK: ReusableScrollViewDelegate
    
    func reusableScrollViewDidRequestView(reusableScrollView:ReusableScrollView, model:ScrollViewModel) -> ReusableView {
        let frame = CGRect(x: model.position.x, y: model.position.y, width: _size.width, height: _size.height)
        
        let reusableView:ReusableView    = ReusableView(frame: frame)
        reusableView.backgroundColor     = UIColor.white
        reusableView.alpha               = model.relativeIndex == RelativeIndex.current ? 1 : 0.5
        reusableView.layer.borderColor   = UIColor.red.cgColor
        reusableView.layer.borderWidth   = 1
        
        return reusableView
    }
    
    func reusableViewDidFocus(reusableView:ReusableView) -> Void {
        //
    }
    
    // MARK: ScrollEngineDataSource
    
    var initialIndex: Int {
        return 7
    }
    
    var numberOfViews: UInt {
        return 10
    }
    
}

