//
//  ContentView.swift
//  ImageScroller
//
//  Created by sumofighter666 on 25.04.18.
//  Copyright © 2018 sumofighter666. All rights reserved.
//

import UIKit
import ReusableScrollView

class ContentView: UIView {
    
    var viewModel:ScrollViewModel?
    
    func updateFrame() {
        guard let model = viewModel else {
            return
        }
        
        self.frame = CGRect(x: model.position.x, y: model.position.y, width: self.bounds.width, height: self.bounds.height)
        
        if model.relativeIndex == RelativeIndex.current {
            self.alpha = 1
        } else {
            self.alpha = 0.5
        }
    }
    
}
