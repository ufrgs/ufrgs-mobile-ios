//
//  RUCell.swift
//  ufrgsmobile
//
//  Created by Lucas Flores on 04/01/17.
//  Copyright © 2017 CPD UFRGS. All rights reserved.
//

import UIKit

class RuCell: UITableViewCell {
    
    @IBOutlet weak var ruImage: UIImageView!
    @IBOutlet weak var ruTitle: UILabel!
    @IBOutlet weak var cardapio: UILabel!
    
    func configure() {
//        self.ruImage.contentMode = .scaleAspectFill
        self.clipsToBounds = true
//        self.ruImage.clipsToBounds = true
        self.backgroundColor = .clear
        self.selectionStyle = .none
    }
    
}

class DalCell: UITableViewCell {
    
}

