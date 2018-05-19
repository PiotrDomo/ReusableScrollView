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

open class ReusableView:UIView {
    
    var viewModel:ScrollViewModel?
    
    func updateFrame() {
        guard let model = viewModel else {
            return
        }
        
        self.frame = CGRect(x: model.position.x, y: model.position.y, width: self.bounds.width, height: self.bounds.height)
        
        // TODO: Remove later
        
        if model.relativeIndex == RelativeIndex.current {
            self.alpha = 1
        } else {
            self.alpha = 0.5
        }
    }
    
}
