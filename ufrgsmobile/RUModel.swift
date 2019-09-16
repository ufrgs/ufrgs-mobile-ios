//
//  File.swift
//  ufrgsmobile
//
//  Created by Lucas Flores on 09/01/17.
//  Copyright © 2017 CPD UFRGS. All rights reserved.
//

import Foundation
import UIKit

public enum RU {
    case centro, vale, bloco4, saude, agro, esef, litoral
    
    func title() -> String {
        switch self {
        case .centro:
            return "Centro"
        case .vale:
            return "Vale"
        case .bloco4:
            return "Bloco 4"
        case .saude:
            return "Saúde"
        case .agro:
            return "Agro"
        case .esef:
            return "Esefid"
        case .litoral:
            return "Litoral"
        }
    }
}

class RUModel: NSObject {
    
    var shortName : String = ""
    var name : String = ""
    var number: Int = -1
    var menu : String = ""
    
    func getColor() -> UIColor? {
        switch number {
        case 1:
            return UIColor(red: 225/255.0, green: 171/255.0, blue: 29/255.0, alpha: 1.0)
        case 2:
            return UIColor(red: 24/255.0, green: 47/255.0, blue: 58/255.0, alpha: 1.0)
        case 3:
            return UIColor(red: 94/255.0, green: 154/255.0, blue: 71/255.0, alpha: 1.0)
        case 4:
            return UIColor(red: 208/255.0, green: 125/255.0, blue: 14/255.0, alpha: 1.0)
        case 5:
            return UIColor(red: 225/255.0, green: 62/255.0, blue: 60/255.0, alpha: 1.0)
        case 6:
            return UIColor(red: 88/255.0, green: 91/255.0, blue: 92/255.0, alpha: 1.0)
        case 7:
            return UIColor(red: 12/255.0, green: 79/255.0, blue: 136/255.0, alpha: 1.0)
        default:
            return nil
        }
    }
    
    func getImage() -> UIImage? {
        if number > 0 && number <= 7 {
            let ilustraName = "ru" + String(number) + "-ilustra.jpg"
            
            if let ilustra = UIImage(named: ilustraName) {
                return ilustra
            } else {
                return nil
            }
        }
        return nil
    }
    
}
