//
//  ImageExtension.swift
//  ufrgsmobile
//
//  Created by Augusto on 11/04/2019.
//  Copyright © 2019 CPD UFRGS. All rights reserved.
//

import UIKit

extension UIImage {
    func getPixelColor(pos: CGPoint) -> UIColor? {
        
        if let cgImg = self.cgImage {
            if let provider = cgImg.dataProvider {
                let pixelData = provider.data
                let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
                
                let pixelInfo: Int = ((Int(self.size.width) * Int(pos.y)) + Int(pos.x)) * 4
                
                let r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
                let g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
                let b = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
                let a = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)
                
                return UIColor(red: r, green: g, blue: b, alpha: a)
            }
        }
        return nil
    }
}
