//
//  PrivacyPolicyView.swift
//  ufrgsmobile
//
//  Created by Augusto on 31/05/2019.
//  Copyright © 2019 CPD UFRGS. All rights reserved.
//

import Foundation
import UIKit


class PrivacyPolicyView: UIViewController, PopupContentViewController {
    
    // MARK: - Properties
    
    let PRIVACY_POLICY_URL = "https://www.ufrgs.br/cpd/apps-politica-de-privacidade/"
    
    var button = UIButton(frame: .zero)
    var myPopUpController: PopupController?
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    
    // MARK
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFromXib()
        configureLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureCorners()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - Initializers
    
    private func loadFromXib() {
        Bundle.main.loadNibNamed("PrivacyPolicyView", owner: self, options: nil)
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    private func configureLabel() {
        
        var defaulAttr : [NSAttributedString.Key: Any] = [ NSAttributedString.Key.foregroundColor: UIColor.black ]
        if let defaultFont = UIFont(name: "AvenirNext-Regular", size: 18) {
            defaulAttr[NSAttributedString.Key.font] = defaultFont
        }
        
        var linkAttr : [NSAttributedString.Key: Any] = [ NSAttributedString.Key.foregroundColor: view.tintColor ]
        if let linkFont = UIFont(name: "AvenirNext-Medium", size: 18) {
            linkAttr[NSAttributedString.Key.font] = linkFont
        }
        
        let begin = NSAttributedString(string: "Ao utilizar o app você concorda com as nossas ", attributes: defaulAttr)
        let link = NSAttributedString(string: "Políticas de privacidade", attributes: linkAttr)
        let end = NSAttributedString(string: ".", attributes: defaulAttr)
        
        let text = NSMutableAttributedString(attributedString: begin)
        text.append(link)
        text.append(end)
        
        self.label.attributedText = text
    }
    
    private func configureCorners() {
        self.view.layer.borderWidth = 1.0
        self.view.layer.borderColor = UIColor.lightGray.cgColor
        self.view.layer.cornerRadius = 10.0
        self.view.clipsToBounds = true
    }
    
    // MARK: - Actions
    
    @IBAction func openPolicyAction(_ sender: Any) {
        if let url = URL(string: PRIVACY_POLICY_URL) {
            UIApplication.shared.openURL(url)
        }
    }
    
    @IBAction func acceptAction(_ sender: Any) {
        myPopUpController?.dismiss()
    }
    
    // MARK: - PopupContentViewController method
    
    func sizeForPopup(_ popupController: PopupController, size: CGSize, showingKeyboard: Bool) -> CGSize {
        self.myPopUpController = popupController
        return CGSize(width: 280.0, height: 190.0)
    }
    
}
