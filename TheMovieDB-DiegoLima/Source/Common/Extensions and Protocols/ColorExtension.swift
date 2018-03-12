//
//  ColorExtension.swift
//  TheMovieDB-DiegoLima
//
//  Created by Diego Lima on 09/03/18.
//  Copyright © 2018 Diego Marlon Medeiros Lima. All rights reserved.
//

import UIKit

extension UIColor {
    
    // MARK: - Init
    private convenience init(hex: UInt32) {
        let mask = 0x000000FF
        
        let r = Int(hex >> 16) & mask
        let g = Int(hex >> 8) & mask
        let b = Int(hex) & mask
        
        let red   = CGFloat(r) / 255
        let green = CGFloat(g) / 255
        let blue  = CGFloat(b) / 255
        
        self.init(red: red, green: green, blue: blue, alpha: 1)
    }
    
    private static func handleColor(named colorName: String, hex: UInt32) -> UIColor {
        if #available(iOS 11, *), let color = UIColor(named: colorName) {
            return color
        }
        return UIColor(hex: hex)
    }
    
    // MARK: - class Functions
    
    class func mainColor() -> UIColor {
        return UIColor.handleColor(named: "MainColor", hex: 0x222222)
    }
}
