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
    
    var focusDelay:TimeInterval = 0.5
    var initialIndex: Int = 7
    var numberOfViews: UInt = 12
    
    lazy private var _size:CGSize = {
        return scrollView.bounds.size
    }()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let contentWidth = _size.width * CGFloat(numberOfViews)
        
        scrollView.contentSize = CGSize(width: contentWidth, height: _size.height)
        scrollView.layer.borderColor = UIColor.black.cgColor
        scrollView.layer.borderWidth = 1

    }

    
    // MARK: ReusableScrollViewDelegate
    
    func reusableViewDidFocus(reusableView:ReusableView) -> Void {
        guard reusableView.absoluteIndex >= 0 else {
            return
        }
        
        guard let contentView = reusableView.contentView as? UIImageView else {
            return
        }
        
        contentView.image = image(at: UInt(reusableView.absoluteIndex))
    }
    
    func scrollViewDidRequestView(reusableScrollView: ReusableScrollView, atIndex: Int) -> UIView {
        // In this case first check the reusable view exists already
        let reusableView = reusableScrollView.reusableView(atIndex: atIndex)
        
        // Confirm the content view is type of `UIimageView`
        guard
            let contentView = reusableView?.contentView as? UIImageView
        else {
            
            let thumbs = thumb(at: UInt(atIndex))
            let imageView = UIImageView(image: thumbs)
            imageView.contentMode = .scaleAspectFit

            return imageView;
        }
        
        contentView.image = thumb(at: UInt(reusableView!.absoluteIndex))
        return contentView;
        
    }
    
}

extension ViewController {
    func image(at index:UInt) -> UIImage? {
        return UIImage(named: "image\(index)")
    }
    
    func thumb(at index:UInt) -> UIImage? {
        return UIImage(named: "image\(index)_small")
    }
}

