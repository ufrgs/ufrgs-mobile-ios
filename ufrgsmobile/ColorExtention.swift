//
//  ColorExtention.swift
//  ufrgsmobile
//
//  Created by Lucas Flores on 13/01/17.
//  Copyright © 2017 CPD UFRGS. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.characters.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
    static func navBarColor() -> UIColor {
        return UIColor(red: 227.0/255.0, green: 69.0/255.0, blue: 64.0/255.0, alpha: 1.0)
    }
    
    func tabBarColor() -> UIColor {
        
        return UIColor(hexString: "#512d59")
    }
    
    func whiteText() -> UIColor {
        
        return UIColor(hexString: "#6b4773")
    }
    
    func blackText() -> UIColor {
        
        return UIColor(hexString: "#27a6b6")
    }
    
    func primaryText() -> UIColor {
        
        return UIColor(hexString: "#212121")
    }
    
    func secondaryText() -> UIColor {
        
        return UIColor(hexString: "#727272")
    }
    
}
