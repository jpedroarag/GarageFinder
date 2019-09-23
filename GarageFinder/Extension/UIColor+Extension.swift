//
//  UIColor+Extension.swift
//  GarageFinder
//
//  Created by João Pedro Aragão on 04/09/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit

extension UIColor {
    
    /// Initializer for int RGBA values
    ///
    /// - Parameters:
    ///   - red: Color's red int value (0...255)
    ///   - green: Color's green int value (0...255)
    ///   - blue: Color's blue int value (0...255)
    ///   - alpha: Color's alpha int value (0...100)
    convenience init(red: Int, green: Int, blue: Int, alpha: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        assert(alpha >= 0 && alpha <= 100, "Invalid alpha component")
        
        self.init(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: CGFloat(alpha)/100)
    }
    
    /// Initializer for hex value
    ///
    /// - Parameters:
    ///   - rgb: Hex value
    ///   - alpha: Color opacity (0...100)
    convenience init(rgb: Int, alpha: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF,
            alpha: alpha
        )
    }
    
    static var customDarkGray = UIColor(rgb: 0x666666, alpha: 100)
    
    static var textFieldBorderGray = UIColor(rgb: 0xEEEEEE, alpha: 100)
    
    static var customLightGray = UIColor(rgb: 0xBEBEBE, alpha: 100)
    
    static var customYellow = UIColor(rgb: 0xFFCE00, alpha: 100)
    
}
