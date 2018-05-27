//  ReusableView.swift

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

import Foundation

@objc open class ReusableView:UIView {
    
    private weak var _contentView:UIView?
    
    @objc public var viewModel:ScrollViewModel?
    
    @objc public var absoluteIndex:Int {
        get {
            guard let model = viewModel else {
                return -1
            }
            return model.absoluteIndex
        }
    }
    
    @objc public var contentView:UIView? {
        get {
            return _contentView
        }
        set {
            // Check the same content view is not trying to be added again
            guard _contentView != newValue else {
                return
            }
            
            // If some other content view is already added remove it
            if _contentView?.isDescendant(of: self) == true {
                _contentView?.removeFromSuperview()
            }
            
            // Manke sure the new content view is passed 
            guard let newView = newValue else {
                return
            }
            
            _contentView = newView
            self.addSubview(newView)
        }
    }
    
    func updateFrame() {
        
        guard let model = viewModel else {
            return
        }
        
        if (model.relativeIndex == .afterNext && model.shift != .none) ||
           (model.relativeIndex == .beforePrevious && model.shift != .none) {
            
            UIView.animate(withDuration: 0.5) {
                self.frame = CGRect(x: model.position.x, y: model.position.y, width: self.bounds.width, height: self.bounds.height)
            }
        }
    }
    
}
