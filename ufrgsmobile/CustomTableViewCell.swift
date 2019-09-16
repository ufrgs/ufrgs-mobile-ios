//
//  NewsItemCell.swift
//  ufrgsmobile
//
//  Created by Lucas Flores on 04/01/17.
//  Copyright © 2017 CPD UFRGS. All rights reserved.
//

import UIKit

class NewsItemCell: UITableViewCell {
    
    @IBOutlet weak var imgNews: UIImageView!
    @IBOutlet weak var lblNewsText: UILabel!
    @IBOutlet weak var imgWidthConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgNews.clipsToBounds = true
        imgNews.layer.cornerRadius = 2.0
    }
    
}
