//
//  BiblioViewController.swift
//  ufrgsmobile
//
//  Created by Theodoro L. Mota on 07/08/15.
//  Copyright (c) 2015 Theodoro L. Mota. All rights reserved.
//

import UIKit

class BiblioViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var emprestimos: UILabel!
    @IBOutlet weak var reservas: UILabel!
    @IBOutlet weak var multas: UILabel!
    @IBOutlet weak var backgroundLogin: UIView!
    @IBOutlet weak var loginId: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var backgroudTopConstrain: NSLayoutConstraint!
    
    var mUser : String?
    var mPass : String?
    
    var mNome = "nome"
    var mEmprestimos = "emprestimos"
    var mReservas = "reservas"
    var mMulta = "multa"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Biblioteca"
        self.navigationItem.title = "UFRGS Mobile"
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        backgroundLogin.addGestureRecognizer(tap)
        
        mUser = NSUserDefaults.standardUserDefaults().objectForKey("user") as? String
        mPass = NSUserDefaults.standardUserDefaults().objectForKey("password") as? String

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logoutButton(sender: AnyObject) {
        
        NSUserDefaults.standardUserDefaults().removeObjectForKey("user")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("password")
        self.backgroundLogin.hidden = false
        
    }
    
    @IBAction func loginButton(sender: AnyObject) {
        print(loginId.text)
        print(password.text)
        
        self.DismissKeyboard()
        
        let l : String = loginId.text!
        let p : String = password.text!
        
        
        if (!l.isEmpty) && (!p.isEmpty) {
            NSUserDefaults.standardUserDefaults().setObject(loginId.text, forKey: "user")
            NSUserDefaults.standardUserDefaults().setObject(password.text, forKey: "password")
            
            self.backgroundLogin.hidden = true
            loginAssync()
        }
        
    }
    
    // **************************************************************************************
    // MARK: - TableView Delegates
    // **************************************************************************************
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: BiblioCell = self.tableView.dequeueReusableCellWithIdentifier("biblioCell") as! BiblioCell
        
        
        return cell
    }
    
    // *************************************************************************************
    // MARK: - Aux Funcs
    // *************************************************************************************
    
    //Calls this function when the tap is recognized.
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    // *************************************************************************************
    // MARK: - Parse Sabi =(
    // *************************************************************************************
    
    func loginAssync () {
        postLogin(getSession())

    }
    
    func getSession () -> String {
        
        var finalLink : String = "temporario"
        
        let r = Int(arc4random_uniform(99999999))
        let rNSNumber = r as NSNumber
        let rString : String = rNSNumber.stringValue
        let urlString = String("http://sabi.ufrgs.br/F?RN=" + rString)
        let url = NSURL(string: urlString)
        
        let html = NSData(contentsOfURL: url!)
        let doc = TFHpple(HTMLData: html)
        let elements = doc.searchWithXPathQuery("/html/body/table[1]//@href") as? [TFHppleElement]
        
        if let link = elements![2].content {
            finalLink = link
        }
        return finalLink
    }
    
    func postLogin(sessionUrl : String) {
        let postString = "ssl_flag=Y&func=login-session&login_source=bor-info&bor_library=URS50&bor_id=" + "00173230" + "&bor_verification=" + "07011988" + "&x=32&y=5"
        
        let loginUrl = NSURL(string: sessionUrl)
        
        let requestLogin = NSMutableURLRequest(URL: loginUrl!)
        requestLogin.HTTPMethod = "POST"
        requestLogin.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(requestLogin) {
            data, response, error in
            
            let nameDoc = TFHpple(HTMLData: data!)
            let name = nameDoc.searchWithXPathQuery("/html/body/div[2]") as? [TFHppleElement]
            
            //nome do usuário
            self.mNome = name![0].content.stringByReplacingOccurrencesOfString("Informações do usuário ", withString:"", options: NSStringCompareOptions.LiteralSearch, range: nil)
            
            self.mNome = self.mNome.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            
            print(self.mNome)
            
            //emprestimos
            let empDoc = TFHpple(HTMLData: data!)
            let emprestimos = empDoc.searchWithXPathQuery("/html/body/table/tbody/tr[584]/td[2]") as? [TFHppleElement]
            
            for node in emprestimos! {
                print(node.content)
            }
            
            
            
            
            
        }
        
        task.resume()
        
        
    
    }
    
    
    

}
