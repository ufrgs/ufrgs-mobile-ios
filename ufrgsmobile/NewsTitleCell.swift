//
//  NewsTitleCell.swift
//  tablevieww test
//
//  Created by Lucas Flores on 09/01/17.
//  Copyright © 2017 cpd.br. All rights reserved.
//

import UIKit

// MARK: - Cell for when there is image

class NewsTitleImageCell: UITableViewCell {
    
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var imageheightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.backgroundColor = UIColor.clear
        self.newsTitle.numberOfLines = 0
    }
    
    func configure(image: UIImage?) {
        if let i = image {
            newsImage.image = i
            imageheightConstraint.constant = 220.0
        } else {
            newsImage.image = nil
            imageheightConstraint.constant = 0.0
        }
    }
    
}

// MARK: - Cell for the date

class NewsDateCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.backgroundColor = UIColor.clear
    }
    
}
