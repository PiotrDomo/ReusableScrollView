// ScrollEngine.swift

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

extension Notification.Name {
    static let update = Notification.Name("update indices")
}

public enum ScrollingDirection:Int {
    case previous = -1
    case none = 0
    case next = 1
}

public protocol ScrollEngineDataSource: class {
    
    var size:CGSize {get}
    
    var numberOfViews:UInt {get}
    
    var initialIndex:Int {get}
    
}

public protocol ScrollEngineDelegate: class {
    
    func didFinishViewDecalration(engine:ScrollEngine, models:[ScrollViewModel]) -> Void

    func didUpdateRelativeIndices(direction:ScrollingDirection, models:[ScrollViewModel], addedIndex:Int?) -> Void
    
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
    static var _maxPool:UInt = 5
    
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
    
    // MARK: Lifecycle
    
    public override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(updateIndices(notfication:)), name: .update, object: nil)
    }
    
    // MARK: Private
    
    @objc private func updateIndices(notfication: NSNotification) {
        let _ = _models?.update(_absoluteIndex, _numberOfViews, ScrollingDirection.none)
    }
    
    // MARK: Public
    
    public func build() -> Void {
        
        logDebug("\n-ScrollEngine.build()")
        
        let maxPool:UInt = _numberOfViews > ScrollEngine._maxPool ? ScrollEngine._maxPool : _numberOfViews
        
        _models = ScrollViewModel.modelSet(size: _screenSize, count: maxPool)
        
        let _ = _models?.update(_absoluteIndex, _numberOfViews, ScrollingDirection.none)
        
        _models?.forEach { model in
            self.delegate?.didRequestView(engine:self, model: model)
        }
        
        if let models = _models,
            models.count > 0 {
        
            delegate?.didFinishViewDecalration(engine: self, models: models)
        }
        
    }
    
    public func next() -> Void {
        
        logDebug("\n-ScrollEngine.next()")
        
        guard
            _numberOfViews > 0,
            _numberOfViews > _absoluteIndex+1,
            _absoluteIndex+1 < _numberOfViews
        else {
            return
        }
        
        guard let models = _models else {
            return
        }
        
        _absoluteIndex += 1
        
        let addedIndex = models.prepareForSwipe(_absoluteIndex, _numberOfViews, ScrollingDirection.next)
        
        logVerbose("   Added index: \(addedIndex ?? -1)")
        _models = models
        
        delegate?.didUpdateRelativeIndices(direction: ScrollingDirection.next, models: models, addedIndex: addedIndex)
        
    }
    
    public func previous() -> Void {
        
        logDebug("\n-ScrollEngine.previous()")
        
        _absoluteIndex -= 1
        
        guard
            _numberOfViews > 0,
            _numberOfViews > _absoluteIndex+1,
            _absoluteIndex >= 0
            else {
                return
        }
        
        guard let models = _models else {
            return
        }
        
        let addedIndex = models.prepareForSwipe(_absoluteIndex, _numberOfViews, ScrollingDirection.previous)
    
        logVerbose("   Added index: \(addedIndex ?? -1)")
        _models = models
        
        delegate?.didUpdateRelativeIndices(direction: ScrollingDirection.previous, models: models, addedIndex: addedIndex)
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
    
    fileprivate func updateModel(_ absoluteIndex:Int, _ relativeIndex:RelativeIndex) {
        self.absoluteIndex = absoluteIndex
        self.relativeIndex = relativeIndex
    }
    
}

extension Array where Iterator.Element == ScrollViewModel {
    
    /**
 
     Returns only new added index, otherwise returns nil
 
    */
    
    fileprivate func prepareForSwipe(_ absoluteIndex:Int, _ numberOfViews:UInt, _ direction: ScrollingDirection) -> Int? {
        return prepare(absoluteIndex: absoluteIndex, numberOfViews: numberOfViews, direction: direction, handler: { () -> ([Int]?) in
            return self.prepareModels(numberOfViews: numberOfViews,
                                      direction: direction,
                                      absoluteIndex: absoluteIndex)
        })
    }
    
    fileprivate func update(_ absoluteIndex:Int, _ numberOfViews:UInt, _ direction: ScrollingDirection) -> Int? {
        return prepare(absoluteIndex: absoluteIndex, numberOfViews: numberOfViews, direction: direction, handler: { () -> ([Int]?) in
            return self.updateModels(numberOfViews: numberOfViews,
                                     direction: direction,
                                     absoluteIndex: absoluteIndex)
        })
    }
    
    fileprivate func prepare(absoluteIndex:Int, numberOfViews:UInt, direction: ScrollingDirection, handler: @escaping ()->([Int]?)) -> Int? {
        
        switch absoluteIndex {
        case 0:
            
            for i in 1...self.count {
                let index = i - 1
                guard let relativeIndex = RelativeIndex(rawValue: index) else {
                    return nil
                }
                self[index].updateModel(absoluteIndex+index, relativeIndex)
            }
            
            return nil
            
        case Int(numberOfViews)-1:
            var index = 0
            for i in stride(from: self.count, through: 1, by: -1) {
                guard let relativeIndex = RelativeIndex(rawValue: index) else {
                    return nil
                }
                self[i - 1].updateModel(absoluteIndex+index, relativeIndex)
                index -= 1
            }
            
            return nil
            
        default:
            
            /*
             This is called whenever the absolute index is neither first of last
            */
            
            /*
             Possibilities:
             
             -1, 0, 1
             -1, 0, 1, 2
             -1, 0, 1, 2, 3
             
             -2, -1, 0, 1
             -3, -2, -1, 0, 1
             
             */
            
            guard self.count >= 4 else {
                logError("Index overflown")
                return nil
            }
            
            let indices = handler()
            
            logVerbose("\n-ScrollViewModel.update(absoluteIndex:, numberOfViews:)")
            
            
            // If total number of views is less than 6
            // maximum amount of indices are already assigned and no new will be added.
            // In this case it is safe to return nil
            if numberOfViews <= ScrollEngine._maxPool {
                return nil
            }
            
            guard
                let idxs = indices,
                let max = idxs.max(),
                let min = idxs.min()
            else {
                logError("Indices not found. Expected at least 5 indices to be present")
                assertionFailure("Indices not found. Expected at least 5 indices to be present")
                return nil
            }
            
            return direction == .next ? max : min
            
        }
    }
    
    private func updateModels(numberOfViews:UInt, direction: ScrollingDirection, absoluteIndex:Int) -> [Int]? {
        let shouldMove3Positions = (absoluteIndex == Int(numberOfViews)-2) && self.count > 4
        let indexShift = absoluteIndex == 1 ? -1 : ( shouldMove3Positions ? -3 : -2)
        
        var indices = [Int]()
        
        for i in 0...self.count-1 {
            let index = i + indexShift
            guard let relativeIndex = RelativeIndex(rawValue: index) else {
                return nil
            }
            
            self[i].relativeIndex = relativeIndex
            self[i].absoluteIndex = absoluteIndex+index
            self[i].shift = .none
            indices.append(absoluteIndex+index)
        }
        
        return indices
    }
    
    private func prepareModels(numberOfViews:UInt, direction: ScrollingDirection, absoluteIndex:Int) -> [Int]? {
        
        guard
            UInt(self.count) < numberOfViews,
            let indices = updateModels(numberOfViews: numberOfViews, direction: direction, absoluteIndex: absoluteIndex)
        else {
            return nil
        }
        
        manageAbsoluteIndices(indices: indices, direction: direction)
        
        return indices
    }
    
    private func manageAbsoluteIndices(indices:[Int], direction:ScrollingDirection) {
        
        guard indices.isEmpty == false else {
            logError("Indices are empty. Expected at least 5 indices to be present")
            assertionFailure("Indices are empty. Expected at least 5 indices to be present")
            return
        }
        
        var sortedIndices = indices
        
        switch direction {
        case .next:
            let removed = sortedIndices.removeLast()
            sortedIndices.insert(removed, at: 0)
            self.first?.shift = .fromLeftToRight
            
        case .previous:
            let removed = sortedIndices.removeFirst()
            sortedIndices.append(removed)
            self.last?.shift = .fromRightToLeft
            
        default:
            print("nothing to do")
        }
        
        for i in 0...self.count-1 {
            self[i].absoluteIndex = sortedIndices[i]
        }
    }
}
