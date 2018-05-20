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
    
    @objc public var contentView:UIView? {
        get {
            return _contentView
        }
        set {
            if _contentView?.isDescendant(of: self) != nil {
                _contentView?.removeFromSuperview()
            }
            
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
        
        self.frame = CGRect(x: model.position.x, y: model.position.y, width: self.bounds.width, height: self.bounds.height)
        
        // !!!: Temorpary. Remove later
        
        if model.relativeIndex == RelativeIndex.current {
            self.alpha = 1
        } else {
            self.alpha = 0.5
        }
    }
    
}
