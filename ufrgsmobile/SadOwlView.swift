//
//  SadOwlView.swift
//  ufrgsmobile
//
//  Created by Augusto on 02/04/2019.
//  Copyright © 2019 CPD UFRGS. All rights reserved.
//

import Foundation
import UIKit

class SadOwlView: UIView {
    
    // MARK: - Properties
    
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet var view: UIView!
    
    // MARK: - Initializers
    
    init(frame: CGRect, text: String) {
        super.init(frame: frame)
        loadFromXib()
        textLabel.text = text
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadFromXib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadFromXib()
    }
    
    private func loadFromXib() {
        Bundle.main.loadNibNamed("SadOwlView", owner: self, options: nil)
        addSubview(view)
        view.frame = self.frame
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        view.backgroundColor = .clear
    }
    
}
