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
    @IBOutlet weak var imgHeightConstraint: NSLayoutConstraint!
    
    let heightWithImage: CGFloat = 95.0
    let heightNoImage: CGFloat = 0.0
    
    let widthWithImage: CGFloat = 140
    let widthNoImage: CGFloat = 0.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgNews.clipsToBounds = true
        imgNews.layer.cornerRadius = 6.0
    }
    
    func setTitle(_ text: String) {
        lblNewsText.text = text
    }
    
    func loadImage(url: URL, completion: @escaping (UIImage?) -> (), failCompletion: @escaping () -> ()) {
        imgNews.kf.setImage(with: url) { (_, error, _, _) in
            if let e = error {
                if let statusCode = e.userInfo["statusCode"] as? Int {
                    if statusCode == 404 {
                        self.imgWidthConstraint.constant = 0
                        self.layoutIfNeeded()
                        failCompletion()
                    }
                }
            } else {
                self.imgWidthConstraint.constant = 114
            }
            
            completion(self.imgNews.image)
        }
    }
    
    private func configureNoImage() {
        self.imgWidthConstraint.constant = widthNoImage
        self.imgHeightConstraint.constant = heightNoImage
        self.layoutIfNeeded()
    }
    
    private func configureHasImage() {
        self.imgWidthConstraint.constant = widthWithImage
        self.imgHeightConstraint.constant = heightWithImage
        self.layoutIfNeeded()
    }
    
}

// MARK: - Cell for news without image

class NewsItemNoImageCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
}

// MARK: - Cell for highlighted news

class NewsItemHighlightCell: UITableViewCell {
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var degradeView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureCardView()
        hero.isEnabled = true
        degradeView.hero.id = HeroId.newsImage
    }
    
    func configure(title: String, subtitle: String, url: URL?, completion: @escaping (UIImage?) -> ()) {
        
        // set labels
        titleLabel.text = title
        subtitleLabel.text = subtitle
        
        // try loading the image
        imgView.kf.setImage(with: url) { (_, error, _, _) in
            if let e = error {
                if let statusCode = e.userInfo["statusCode"] as? Int {
                    if statusCode == 404 {
                        self.configureNoimage()
                    }
                }
            } else {
                self.configureHighlightedTitled(title)
                self.degradeView.isHidden = false
            }
            
            completion(self.imgView.image)
        }
    }
    
    private func configureHighlightedTitled(_ title: String) {
        let color = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.44)
        
        let attributes : [NSAttributedStringKey : Any] = [
            .backgroundColor : color,
        ]
        
        let attributedString = NSAttributedString(string: title, attributes: attributes)
        
        self.titleLabel.attributedText = attributedString
    }
    
    private func configureCardView() {
        cardView.clipsToBounds = true
        cardView.layer.cornerRadius = 6.0
    }
    
    private func configureNoimage() {
        cardView.backgroundColor = UIColor.navBarColor()
        degradeView.isHidden = true
        imgView.image = nil
    }
    
}
