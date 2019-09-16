//
//  BiblioCell.swift
//  ufrgsmobile
//
//  Created by Lucas Flores on 18/01/17.
//  Copyright © 2017 CPD UFRGS. All rights reserved.
//

import Foundation
import UIKit


class BiblioCell: UITableViewCell{
    
    // MARK: - Properties
    
    @IBOutlet weak var bookName: UILabel!
    @IBOutlet weak var bookAuthor: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var bookImage: UIImageView!
    
    let BASE_IMG_URL = "http://images.amazon.com/images/P/"
    let END_IMG_URL = ".01.20TRZZZZ.jpg"
    
    // MARK: - Configuration methods
    
    func configure(title: String, author: String, isbn: String, devolutionDate: String) {

        let imageUrl = URL(string: BASE_IMG_URL + isbn + END_IMG_URL)
        
        bookImage.kf.setImage(with: imageUrl)
        bookName.text = title
        bookAuthor.text = author
        date.text = "Devolução: " + devolutionDate
        
        self.backgroundColor = .clear
    }
    
}

class BiblioTitleCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    func configure() {
        self.backgroundColor = .clear
    }
    
}

class BiblioUserCell: UITableViewCell {
    
    // MARK: - Properties
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var loansLabel: UILabel!
    @IBOutlet weak var reservationsLabel: UILabel!
    @IBOutlet weak var debitLabel: UILabel!
    @IBOutlet weak var renewNowButton: UIButton!
    @IBOutlet weak var toggleRenovation: UIButton!
    
    let buttonColor = UIColor(red: 229/255.0, green: 67/255.0, blue: 58/255.0, alpha: 1.0)
    
    // MARK: - Configuration methods
    
    func configure(name: String, loans: String, reservations: String, debit: String, renovationState: String) {
        
        nameLabel.text = name.capitalized
        loansLabel.text = loans + " empréstimo\((loans == "1" ? "" : "s"))"
        reservationsLabel.text = reservations + " reserva\((reservations == "1" ? "" : "s"))"
        debitLabel.text = "Débito: R$ " + debit
        
        configureButtons()
        configureButtonsTitle(renovationState: renovationState)
        
    }
    
    private func configureButtons() {
        
        // adds border around button
        for button in [toggleRenovation, renewNowButton] {
            button?.layer.borderColor = buttonColor.cgColor
            button?.layer.borderWidth = 1.25
            button?.layer.cornerRadius = 8.0
        }
        
        // make button diminish font size to respect constraints
        toggleRenovation?.titleLabel?.adjustsFontSizeToFitWidth = true
        
        // add targets
        toggleRenovation.addTarget(nil, action: #selector(toggleRenovationClicked), for: .touchUpInside)
        renewNowButton.addTarget(nil, action: #selector(renewNowClicked), for: .touchUpInside)
        
    }
    
    private func configureButtonsTitle(renovationState: String) {
        
        if renovationState == "S" {
            toggleRenovation.setTitle("  Desativar autorrenovação  ", for: .normal)
        } else {
            toggleRenovation.setTitle("  Ativar autorrenovação  ", for: .normal)
        }
        
        renewNowButton.setTitle("  Renovar agora  ", for: .normal)
    }
    
    @objc private func toggleRenovationClicked() {
        print("> toggle renovation")
    }
    
    @objc private func renewNowClicked() {
        print("> renew now")
    }
    
}
