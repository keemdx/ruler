//
//  RulerView.swift
//  rulerview
//
//  Created by Dohyun Kim on 2021/12/03.
//

import UIKit

class RulerView: UIView {
    
    // MARK: - Constants
    
    private enum Constants {
        static let labelWidth: CGFloat = 100
        static let labelHeight: CGFloat = 20
        static let labelMarginTop : CGFloat = 5
        static let rulerHeight: CGFloat = 69
    }
    
    // MARK: - Properties
    
    override var tintColor: UIColor! {
        didSet {
            _updateStyle().setNeedsDisplay()
        }
    }
    
    internal let unit: Length.Unit
    internal let length: CGFloat
    
    private var lineWidth: CGFloat
    private var replicatorLayer: CAReplicatorLayer?
    private var labels: [UILabel]?
    private var lengthUnitWidth: CGFloat {
        switch unit {
        case .centimeter:
            return Length.pixels(fromCentimeter: 1.0)
            
        case .inch:
            return Length.pixels(fromInch: 1.0)
        }
    }
    
    // MARK: - View Life Cycle
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(unit: Length.Unit, length: CGFloat, lineWidth: CGFloat) {
        self.unit = unit
        self.length = length
        self.lineWidth = lineWidth
        
        super.init(frame: .zero)
        
        let rulerWidth = lengthUnitWidth * length
        frame = .init(x: 0, y: 0, width: rulerWidth, height: Constants.rulerHeight)
        _setupLabels()
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        _updateStyle()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        replicatorLayer?.removeFromSuperlayer()
        replicatorLayer = CAReplicatorLayer()
        
        if let replicatorLayer = replicatorLayer {
            replicatorLayer.instanceCount = Int(ceil(length))
            replicatorLayer.instanceTransform = CATransform3DMakeTranslation(lengthUnitWidth, 0, 0)
            
            let unitLayer = LengthUnitLayer(
                unit: unit,
                lineWidth: lineWidth,
                lineColor: tintColor.cgColor,
                height: frame.height)
            
            unitLayer.frame = CGRect(
                x: -lineWidth/2,
                y: 0,
                width: unitLayer.bounds.width,
                height: (bounds.height - Constants.labelHeight - Constants.labelMarginTop))
            unitLayer.setNeedsDisplay()
            replicatorLayer.addSublayer(unitLayer)
            
            layer.addSublayer(replicatorLayer)
        }
        
        labels?.enumerated().forEach { (offset, element) in
            element.frame = .init(
                x: (CGFloat(offset)*lengthUnitWidth - Constants.labelWidth/2),
                y: (bounds.height - Constants.labelHeight),
                width: Constants.labelWidth,
                height: Constants.labelHeight)
        }
    }
    
    // MARK: - Setup
    
    @discardableResult
    private func _setupLabels() -> Self {
        labels?.forEach { $0.removeFromSuperview() }
        labels = [UILabel]()
        
        for i in 0...Int(ceil(length)) {
            let label = UILabel()
            label.text = "\(i)"
            label.textAlignment = .center
            
            addSubview(label)
            
            labels?.append(label)
        }
        
        return self
    }
    
    // MARK: - Layout
    
    @discardableResult
    private func _updateStyle() -> Self {
        labels?.forEach { $0.textColor = tintColor }
        
        return self
    }
    
}
