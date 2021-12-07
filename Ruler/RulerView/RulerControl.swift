//
//  RulerControl.swift
//  rulerview
//
//  Created by Dohyun Kim on 2021/12/03.
//

import UIKit
import SnapKit

class RulerControl: UIControl {
    
    // MARK: - Properties
    
    override var tintColor: UIColor! {
        didSet {
            _updateStyle()
        }
    }
    
    var newValueReceived: ((CGFloat) -> Void)?
    var value: CGFloat = 0
    let stepValue: CGFloat
    let rulerView: RulerView
    
    private let scrollView: UIScrollView = .init()
    
    private let indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.cornerRadius = 2.5
        view.layer.masksToBounds = true
        return view
    }()
    
    // MARK: - View Life Cycle
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(unit: Length.Unit, length: CGFloat, step: CGFloat = 0.1, lineWidth: CGFloat = 1.0) {
        self.stepValue = step
        self.rulerView = RulerView(unit: unit, length: length, lineWidth: lineWidth)
        
        super.init(frame: .init(
            x: 0,
            y: 0,
            width: rulerView.bounds.width * 2,
            height: rulerView.bounds.height))
        
        _addScrollView()
        _addRulerView()
        _addIndicatorView()
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        
        _updateStyle()
        
        scrollView.contentSize = .init(
            width: scrollView.bounds.width + rulerView.bounds.width,
            height: scrollView.bounds.height)
        _updateScrollOffset(false)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        scrollView.contentSize = .init(
            width: scrollView.bounds.width + rulerView.bounds.width,
            height: scrollView.bounds.height)
        _updateScrollOffset(false)
    }
    
    // MARK: - Setup
    
    @discardableResult
    private func _addScrollView() -> Self {
        scrollView.delegate = self
        addSubview(scrollView)
        
        scrollView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(96)
        }

        return self
    }
    
    @discardableResult
    private func _addRulerView() -> Self {
        scrollView.addSubview(rulerView)
        
        rulerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(scrollView.snp.centerX)
            make.width.equalTo(rulerView.bounds.width)
            make.height.equalToSuperview()
        }
        
        return self
    }
    
    @discardableResult
    private func _addIndicatorView() -> Self {
        addSubview(indicatorView)
        
        indicatorView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(-2)
            make.centerX.equalToSuperview()
            make.width.equalTo(5)
            make.height.equalTo(45)
        }
        
        return self
    }
    
    // MARK: - Layout
    
    @discardableResult
    private func _updateStyle() -> Self {
        scrollView.showsHorizontalScrollIndicator = false
        rulerView.backgroundColor = .clear
        rulerView.tintColor = tintColor
        
        return self
    }
    
    @discardableResult
    private func _updateScrollOffset(_ animated: Bool) -> Self {
        let newOffset: CGFloat = {
            switch rulerView.unit {
            case .centimeter:
                return Length.pixels(fromCentimeter: value)
            case .inch:
                return Length.pixels(fromInch: value)
            }
        }()
        
        scrollView.setContentOffset(.init(x: newOffset, y: 0), animated: animated)
        
        return self
    }
    
    // MARK: - Convenience
    
    @discardableResult
    internal func setValue(_ newValue: CGFloat, animated: Bool) -> Self {
        let boundedValue = min(max(newValue, 0), rulerView.length)
        value = boundedValue
        
        _updateScrollOffset(animated)
        
        return self
    }
}

extension RulerControl: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        _updateValueFromScrolling()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            _updateValueFromScrolling()
            _updateScrollOffset(true)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if !scrollView.isDragging && !scrollView.isTracking {
            _updateValueFromScrolling()
            _updateScrollOffset(true)
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        _updateValueFromScrolling(isDidEndScrollingAnimation: true)
        _updateScrollOffset(true)
    }
    
    @discardableResult
    private func _updateValueFromScrolling(isDidEndScrollingAnimation: Bool? = false) -> Self {
        let beforeSetValue = value
        
        value = {
            let newValue: CGFloat = {
                switch rulerView.unit {
                case .centimeter:
                    return Length.centimeter(fromPixels: scrollView.contentOffset.x)
                case .inch:
                    return Length.inch(fromPixels: scrollView.contentOffset.x)
                }
            }()
            
            let boundedValue = min(max(newValue, 0), rulerView.length)
            
            if let isDidEndScrollingAnimation = isDidEndScrollingAnimation, isDidEndScrollingAnimation {
                return round(boundedValue / stepValue) * stepValue
            } else {
                return round(boundedValue / 0.1) * 0.1
            }
        }()
        
        if value != beforeSetValue {
            sendActions(for: .valueChanged)
        }
        
        return self
    }
    
}
