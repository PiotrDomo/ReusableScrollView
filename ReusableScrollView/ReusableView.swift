//  ReusableView.swift

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
        
        if model.relativeIndex == .afterNext || model.relativeIndex == .beforePrevious {
            UIView.animate(withDuration: 0.5) {
                self.frame = CGRect(x: model.position.x, y: model.position.y, width: self.bounds.width, height: self.bounds.height)
            }
        }
    }
    
}
