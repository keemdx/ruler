//
//  Lenghth.swift
//  rulerview
//
//  Created by Dohyun Kim on 2021/12/03.
//

import UIKit

class Length {

    // MARK: - Types
    
    enum Unit {
        case centimeter
        case inch
    }
    
    // MARK: - Constants
        
    private struct Constants {
        static let pixelInCentimetre: CGFloat = 100
        static let pixelInInch: CGFloat = 80
    }

    // MARK: - Convenience
    static func pixels(fromInch value: CGFloat) -> CGFloat {
        return value * Constants.pixelInInch
    }
    
    static func pixels(fromCentimeter value: CGFloat) -> CGFloat {
        return value * Constants.pixelInCentimetre
    }
    
    static func inch(fromPixels value: CGFloat) -> CGFloat {
        return value / Constants.pixelInInch
    }
    
    static func centimeter(fromPixels value: CGFloat) -> CGFloat {
        return value / Constants.pixelInCentimetre
    }
}
