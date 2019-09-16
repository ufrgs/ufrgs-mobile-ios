//
//  ExpandableCell.swift
//  ExpandableCellTest
//
//  Created by Augusto Boranga on 08/02/19.
//  Copyright © 2019 Augusto Boranga. All rights reserved.
//

import Foundation
import UIKit

class RuExpandableCell: UITableViewCell {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var labelsBackgroundView: UIView!

    @IBOutlet weak var ruNumberLabel: UILabel!
    @IBOutlet weak var ruNameLabel: UILabel!
    @IBOutlet weak var menuLabel: UILabel!

    @IBOutlet weak var ruImageView: UIImageView!

    @IBOutlet var menuViewHeightConstraint: NSLayoutConstraint!

    let cornerRadiusValue: CGFloat = 4.0

    func configure(isExpanded: Bool, ruNumber: Int, ruName: String, menu: String, ruImage: UIImage?, color: UIColor?) {

        selectionStyle = .none
        backgroundColor = .clear

        configureCardView()
        print("> will configure expansion")
        configureExpansion(isExpanded: isExpanded)
        configureLabels(ruNumber: ruNumber, ruName: ruName, menu: menu)
        configureImageView(ruImage: ruImage)
        configureLabelsBackgroundView(color: color)
    }

    func configure(isExpanded: Bool, ru: RUModel) {
        self.configure(isExpanded: isExpanded, ruNumber: ru.number, ruName: ru.shortName, menu: ru.menu, ruImage: ru.getImage(), color: ru.getColor())
    }

    private func configureCardView() {
        cardView.clipsToBounds = true
        cardView.layer.cornerRadius = cornerRadiusValue
    }

    private func configureExpansion(isExpanded: Bool) {
        
        if isExpanded {
            menuViewHeightConstraint.isActive = false
            configureMenuView()

        } else {
            menuViewHeightConstraint.isActive = true
            menuViewHeightConstraint.constant = 3.0
        }
    }

    private func configureLabels(ruNumber: Int, ruName: String, menu: String) {
        ruNameLabel.text = ruName
        ruNumberLabel.text = "RU " + String(ruNumber)
        menuLabel.text = menu
    }

    private func configureImageView(ruImage: UIImage?) {
        ruImageView.image = ruImage
        ruImageView.clipsToBounds = true
        ruImageView.contentMode = .scaleAspectFill
    }

    private func configureMenuView() {
        menuView.clipsToBounds = true
        menuView.layer.cornerRadius = cornerRadiusValue

        menuView.layer.borderWidth = 1.0
        menuView.layer.borderColor = UIColor(red: 205/255.0, green: 205/255.0, blue: 205/255.0, alpha: 1.0).cgColor

    }

    private func configureLabelsBackgroundView(color: UIColor?) {
        labelsBackgroundView.backgroundColor = color
    }

}
