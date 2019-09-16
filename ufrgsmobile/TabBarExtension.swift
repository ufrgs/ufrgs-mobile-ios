//
//  TabBarExtension.swift
//  ufrgsmobile
//
//  Created by Augusto on 08/04/2019.
//  Copyright © 2019 CPD UFRGS. All rights reserved.
//

import Foundation
import UIKit

extension UITabBar {
    
    static let height = 53
    
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        super.sizeThatFits(size)
        
        var sizeThatFits = super.sizeThatFits(size)
        
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            
            case 2436, 2688, 1792:
                guard let window = UIApplication.shared.keyWindow else {
                    return super.sizeThatFits(size)
                }
                
                if #available(iOS 11.0, *) {
                    sizeThatFits.height = CGFloat(UITabBar.height) + window.safeAreaInsets.bottom
                }
                
            default:
                sizeThatFits.height = 53
            }
        }
        
        return sizeThatFits
    }
    
//    override open func sizeThatFits(_ size: CGSize) -> CGSize {
    
//
//        return sizeThatFits
//    }
    
}
