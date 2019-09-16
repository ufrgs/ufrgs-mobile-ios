//
//  LoginController.swift
//  ufrgsmobile
//
//  Created by Lucas Flores on 02/01/17.
//  Copyright © 2017 CPD UFRGS. All rights reserved.
//
import UIKit

class LoginController: UIViewController {
    
    @IBOutlet var keyboardHeightLayoutConstraint: NSLayoutConstraint?
    @IBOutlet weak var idText: UITextField!
    @IBOutlet weak var passText: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    let login = Login()
    let putDispositivo = PutDispositivo()
    let getst = GetStatus()
    var loginResult = Bool()
    var isModal = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.title = "Biblioteca"
        self.navigationItem.title = "UFRGS Mobile"
        
        idText.text = ""
        passText.text = ""
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        loginButton.clipsToBounds = true
        loginButton.layer.cornerRadius = 12.0
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if UserDefUtils.tokenIsValid() {
            finishLogin()
        } else {
            UserDefUtils.deleteAll()
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func loginAction(_ sender: Any) {   
        if (idText.text != "") && (passText.text != "") {
            self.showWaitOverlay()
            self.login.getOrders(completionHandler: { (responseObject, error) in
                if responseObject == true{
                    self.finishLogin()
                    self.removeAllOverlays()
                }
                else {
                    self.removeAllOverlays()
                    
                    let alert = UIAlertController(title: "Atenção!", message: "Identificação e/ou senha incorretos. Corrija suas informações e tente novamente.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }, id: idText.text!, pass: passText.text!)
        }
    }
    
    
    func finishLogin() {
        if isModal {
            dismissAsModal()
            return
        }
        
        performSegue(withIdentifier: "login", sender: nil)
        
        self.idText.text = ""
        self.passText.text = ""
        
        self.idText.resignFirstResponder()
        self.passText.resignFirstResponder()
        
        self.removeAllOverlays()
    }
    
    func configureCancelButton() {
        isModal = true
        let button = UIBarButtonItem(title: "Cancelar", style: .plain, target: self, action: #selector(LoginController.dismissAsModal))
        self.navigationItem.leftBarButtonItem  = button
    }
    
    @objc func dismissAsModal() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // This constraint ties an element at zero points from the bottom layout gui
    
    @objc func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
                self.keyboardHeightLayoutConstraint?.constant = (endFrame?.size.height)! - 100
            } else {
                self.keyboardHeightLayoutConstraint?.constant = 00.0
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
}

