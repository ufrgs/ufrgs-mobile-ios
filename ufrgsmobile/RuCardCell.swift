//
//  RuCardCell.swift
//  ufrgsmobile
//
//  Created by Augusto on 28/01/2019.
//  Copyright © 2019 CPD UFRGS. All rights reserved.
//

import Foundation
import UIKit

class RuCardCell: UITableViewCell {
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var textBackground: UIView!
    
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var ruNumberLabel: UILabel!
    @IBOutlet weak var ruNameLabel: UILabel!
    
    func configure(ruNumber: Int, ruName: String, color: UIColor?, image: UIImage?) {
        
        self.backgroundColor = .clear
        self.selectionStyle = .none
        
        cardView.clipsToBounds = true
        cardView.layer.cornerRadius = 4.0
        
        ruNumberLabel.text = "RU " + String(ruNumber)
        ruNameLabel.text = ruName
        
        if let bgColor = color {
            textBackground.backgroundColor = bgColor
        }
        
        myImageView.image = image
        myImageView.clipsToBounds = true
    }
    
}
