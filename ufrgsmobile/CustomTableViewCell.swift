//
//  CustomTableViewCell.swift
//  ufrgsmobile
//
//  Created by Theodoro L. Mota on 07/08/15.
//  Copyright (c) 2015 Theodoro L. Mota. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var imgNews: UIImageView!
    @IBOutlet weak var lblNewsText: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
