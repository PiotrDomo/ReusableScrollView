// ScrollEngine.swift

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

@objc public enum ScrollingDirection:Int {
    case previous = -1
    case next = 1
}

@objc public protocol ScrollEngineDataSource: class {
    
    var size:CGSize {get}
    
    var numberOfViews:UInt {get}
    
    var initialIndex:Int {get}
    
}

@objc public protocol ScrollEngineDelegate: class {
    
    func didFinishViewDecalration(engine:ScrollEngine, models:[ScrollViewModel]) -> Void

    func didUpdateRelativeIndices(direction:ScrollingDirection, models:[ScrollViewModel]) -> Void
    
    func didRequestView(engine:ScrollEngine, model:ScrollViewModel) -> Void
}

open class ScrollEngine:NSObject {
    
    
    weak public var delegate:ScrollEngineDelegate?
    weak public var dataSource:ScrollEngineDataSource?
    
    public var currentIndex:Int {
        get {
            return _absoluteIndex
        }
    }
    
    private var _models:[ScrollViewModel]?
    private static var _maxPool:UInt = 5
    
    // MARK: Lazy properties
    
    lazy private var _screenSize:CGSize = {
        
        guard
            let size = self.dataSource?.size
            else {
                return CGSize()
        }
        
        return size
        
    }()
    
    lazy private var _numberOfViews:UInt = {
        guard
            let count = self.dataSource?.numberOfViews
            else {
                return 0
        }
        
        return count
    }()
    
    lazy private var _absoluteIndex:Int = {
        guard
            let index = self.dataSource?.initialIndex
            else {
                return 0
        }
        
        return index
    }()
    
    // MARK: Public
    
    public func build() -> Void {
        
        let maxPool:UInt = _numberOfViews > ScrollEngine._maxPool ? ScrollEngine._maxPool : _numberOfViews
        
        _models = ScrollViewModel.modelSet(size: _screenSize, count: maxPool)
        
        _models?.update(_absoluteIndex, _numberOfViews)
        
        _models?.forEach { model in
            self.delegate?.didRequestView(engine:self, model: model)
        }
        
        if let models = _models,
            models.count > 0 {
        
            delegate?.didFinishViewDecalration(engine: self, models: models)
        }
        
    }
    
    public func next() -> Void {
        guard
            _numberOfViews > 0,
            _numberOfViews > _absoluteIndex+1,
            _absoluteIndex+1 < _numberOfViews
        else {
            return
        }
        
        _absoluteIndex += 1
        
        _models?.update(_absoluteIndex, _numberOfViews)
        
        guard let models = _models else {
            return
        }
        
        delegate?.didUpdateRelativeIndices(direction: ScrollingDirection.next, models: models)
        
    }
    
    public func previous() -> Void {
        
        _absoluteIndex -= 1
        
        guard
            _numberOfViews > 0,
            _numberOfViews > _absoluteIndex+1,
            _absoluteIndex >= 0
            else {
                return
        }
        
        _models?.update(_absoluteIndex, _numberOfViews)
        
        guard let models = _models else {
            return
        }
        
        delegate?.didUpdateRelativeIndices(direction: ScrollingDirection.previous, models: models)
    }
    
}

extension ScrollViewModel {
    
    fileprivate static func modelSet(size:CGSize, count:UInt) -> [ScrollViewModel]? {
        
        var models:[ScrollViewModel] = [ScrollViewModel]()
        
        for _ in 1 ... count {
            
            models.append(ScrollViewModel(size: size))
        }
        
        return models
    }
    
    fileprivate func update(_ absoluteIndex:Int, _ relativeIndex:RelativeIndex) {
        self.absoluteIndex = absoluteIndex
        self.relativeIndex = relativeIndex
    }
    
}

extension Array where Iterator.Element == ScrollViewModel {
    
    fileprivate func update(_ absoluteIndex:Int, _ numberOfViews:UInt) {
        
            
            switch absoluteIndex {
            case 0:
                
                for i in 1...self.count {
                    let index = i - 1
                    guard let relativeIndex = RelativeIndex(rawValue: index) else {
                        return
                    }
                    self[index].update(absoluteIndex+index, relativeIndex)
                }
                
                break
                
            case Int(numberOfViews)-1:
                var index = 0
                for i in stride(from: self.count, through: 1, by: -1) {
                    guard let relativeIndex = RelativeIndex(rawValue: index * -1) else {
                        return
                    }
                    self[i - 1].update(absoluteIndex+index, relativeIndex)
                    index -= 1
                }
                
                break
                
            default:
                
                /*
                 Possibilities:
                 
                 -1, 0, 1
                 -1, 0, 1, 2
                 -1, 0, 1, 2, 3
                 
                 -2, -1, 0, 1
                 -3, -2, -1, 0, 1
 
                */
                
                guard self.count >= 4 else {
                    fatalError("Error: Index overflown")
                }
                
                let shouldMove3Positions = (absoluteIndex == Int(numberOfViews)-2) && self.count > 4
                
                let indexShift = absoluteIndex == 1 ? -1 : ( shouldMove3Positions ? -3 : -2)
                
                for i in 1...self.count {
                    let index = i - 1 + indexShift
                    guard let relativeIndex = RelativeIndex(rawValue: index) else {
                        return
                    }
                    self[i-1].update(absoluteIndex+index, relativeIndex)
                }
                
            }
        
        
    }
}
