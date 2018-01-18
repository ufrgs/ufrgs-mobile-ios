//
//  CustomTableVIewCell.swift
//  ufrgsmobile
//
//  Created by Lucas Flores on 04/01/17.
//  Copyright © 2017 CPD UFRGS. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgNews: UIImageView!
    @IBOutlet weak var lblNewsText: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
