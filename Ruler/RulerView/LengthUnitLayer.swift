//
//  LengthUnitLayer.swift
//  rulerview
//
//  Created by Dohyun Kim on 2021/12/03.
//

import UIKit

class LengthUnitLayer: CALayer {
    
    // MARK: - Properties
    
    private let unit: Length.Unit
    private let lineWidth: CGFloat
    private let lineColor: CGColor
    
    // 자의 길이 단위
    private var unitWidth: CGFloat {
        switch unit {
        case .centimeter:
            return Length.pixels(fromCentimeter: 1.0)
            
        case .inch:
            return Length.pixels(fromInch: 1.0)
        }
    }
    
    // 두 줄 사이의 길이
    private var spaceBetweenLines: CGFloat {
        return unitWidth/10
    }
    
    // 이 레이어의 픽셀 단위
    private var layerWidth: CGFloat {
        return (unitWidth + lineWidth)
    }
    
    // MARK: - View Life Cycle
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(unit: Length.Unit, lineWidth: CGFloat, lineColor: CGColor, height: CGFloat) {
        self.unit = unit
        self.lineWidth = lineWidth
        self.lineColor = lineColor
        
        super.init()
        
        frame = .init(x: 0, y: 0, width: layerWidth, height: height)
    }
    
    override func draw(in ctx: CGContext) {
        ctx.setStrokeColor(lineColor)
        ctx.setLineWidth(lineWidth)
        ctx.beginPath()
        
        for i in 0...10 {
            let x = lineWidth/2 + CGFloat(i)*spaceBetweenLines
            
            let y: CGFloat = {
                switch unit {
                case .centimeter:
                    if (i % 10 == 0) {
                        return bounds.height
                    } else if (i % 5 == 0) {
                        return bounds.height * 0.7
                    } else {
                        return bounds.height * 0.5
                    }
                    
                case .inch:
                    if (i % 10 == 0) {
                        return bounds.height
                    } else if (i % 2 == 0) {
                        return bounds.height * 0.7
                    } else {
                        return bounds.height * 0.5
                    }
                }
            }()
            
            ctx.move(to: .init(x: x, y: 0))
            ctx.addLine(to: .init(x: x, y: y))
        }
        
        ctx.strokePath()
        ctx.flush()
    }
}
