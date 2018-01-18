//
//  BiblioController.swift
//  ufrgsmobile
//
//  Created by Lucas Flores on 02/01/17.
//  Copyright © 2017 CPD UFRGS. All rights reserved.
//

import UIKit
//import Kingfisher

class BiblioController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emprLabel: UILabel!
    @IBOutlet weak var reservLabel: UILabel!
    @IBOutlet weak var debtLabel: UILabel!
    @IBOutlet weak var autorrenovacao: UIButton!
    //var refreshControl: UIRefreshControl!
    
    let getBooks = GetBooks()
    let logout = Logout()
    let renovarAgora = RenovarAgora()
    let autorrenova = autorrenovacaoCall()
    let aceita = AceitaTermo()
    let putDespositivo = PutDispositivo()
    let status = GetStatus()
    var userInfo = User()
    var books = [Book]()
    
    override func  viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.backgroundView = refreshControl
        }

        
        self.showWaitOverlay()
        aceita.aceitaTerm(completionHandler: {(resposeObject, error) in
            self.putDespositivo.putDispositivos(completionHandler: {(responseObject, error) in
                self.status.getSt(completionHandler: {(responseObject, error) in })
                
                if UserDefUtils.getAuto() == "S"{
                    self.autorrenovacao.setTitle("Desativar autorrenovação", for: .normal)
                }
                else {
                    self.autorrenovacao.setTitle("Ativar autorrenovação", for: .normal)
                }
                
            })
            
            
            self.getBooks.getEmprestimos(completionHandler: { (responseObject, error) in
                self.userInfo = responseObject!
                self.nameLabel.text = self.userInfo.name
                self.emprLabel.text = self.userInfo.qtdEmpr + " emprestimo(s)"
                self.reservLabel.text = self.userInfo.qtdResv + " reserva(s)"
                self.debtLabel.text = "Débito: R$ " + self.userInfo.debt
                self.books = self.userInfo.emprs
                self.tableView.reloadData()
                self.removeAllOverlays()
            })
            
        })
        
        self.tableView.allowsSelection = false
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.title = "Biblioteca"
        self.navigationItem.title = "UFRGS Mobile"
        
        self.navigationItem.hidesBackButton = true
        self.view.window?.isUserInteractionEnabled = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateInfo()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        updateInfo()
    }
    
    
    @IBAction func renovarAgora(_ sender: Any) {
        
        self.showWaitOverlay()
        renovarAgora.renovar(completionHandler: { (responseObject, error) in
            self.removeAllOverlays()
            let alert = UIAlertController(title: "Resultado", message: responseObject, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            self.tableView.reloadData()
        })
        
        updateInfo()
        
    }
    
    
    @IBAction func autorrenovacaoAction(_ sender: Any) {
        
        
        if UserDefUtils.getAuto() == "S" {
            
            let alert = UIAlertController(title: "Desativar autorrenovação:", message: "Não haverá mais renovação automática diária dos empréstimos em seu nome. Você realmente deseja desativar a autorrenovação?", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "SIM", style: UIAlertActionStyle.default, handler: {(action: UIAlertAction!) in self.autorrenovaAction()}))
            alert.addAction(UIAlertAction(title: "Não", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
            
        else {
            
            let alert = UIAlertController(title: "Ativar autorrenovação:", message: "Os empréstimos em seu nome serão renovados diariamente, desde que não haja qualquer impedimento. Mantenha-se sempre logado para receber notificações de autorrenovação. É de sua responsabilidade verificar se todos os empréstimos foram renovados.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Sim", style: UIAlertActionStyle.default, handler: {(action: UIAlertAction!) in self.autorrenovaAction()}))
            alert.addAction(UIAlertAction(title: "Não", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
        
        
    }
    
    func autorrenovaAction(){
        self.showWaitOverlay()
        autorrenova.autorrenova(completionHandler: { (responseObject, error) in
            self.updateButton(updateReason: UserDefUtils.getAuto())
            self.removeAllOverlays()
        })
        
    }
    
    func updateButton(updateReason: String){
        
        if UserDefUtils.getAuto() == "S"{
            autorrenovacao.setTitle("Desativar autorrenovação", for: .normal)
            
        }
            
        else {
            autorrenovacao.setTitle("Ativar autorrenovação", for: .normal)
        }
        
    }
    
    
    @IBAction func actiontest(_ sender: Any) {
        
        let alert = UIAlertController(title: "Logout", message: "Ao sair você não receberá notificação de autorrenovação. Deseja sair?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Não", style: UIAlertActionStyle.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Sim", style: UIAlertActionStyle.default, handler: {(action: UIAlertAction!) in self.logoutAction()}))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func logoutAction(){
        
        self.showWaitOverlay()
        logout.logout(completionHandler: {(responseObject, error) in
            UserDefUtils.deleteToken()
            self.removeAllOverlays()
            self.navigationController?.popToRootViewController(animated: true)
        })
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:BiblioCell = self.tableView.dequeueReusableCell(withIdentifier: "biblioCell") as! BiblioCell
        
        let imageURL = URL(string: "http://images.amazon.com/images/P/" + self.books[indexPath.item].isbn + ".01.20TRZZZZ.jpg")
        
        cell.bookImage?.kf_setImage(with: imageURL)
        
        cell.bookAuthor.text = self.books[indexPath.item].autor
        cell.bookName.text = self.books[indexPath.item].titulo
        cell.date.text = self.books[indexPath.item].dataEntrega
        
        return cell
    }
    
    func updateInfo(){
        self.showWaitOverlay()
            self.getBooks.getEmprestimos(completionHandler: { (responseObject, error) in
                self.userInfo = responseObject!
                self.nameLabel.text = self.userInfo.name
                self.emprLabel.text = self.userInfo.qtdEmpr + " emprestimo(s)"
                self.reservLabel.text = self.userInfo.qtdResv + " reserva(s)"
                self.debtLabel.text = "Débito: R$ " + self.userInfo.debt
                self.books = self.userInfo.emprs
                self.tableView.reloadData()
                self.removeAllOverlays()
            })
        }
    
    func refresh(_ refreshControl: UIRefreshControl) {
        // Do your job, when done:
        updateInfo()
        refreshControl.endRefreshing()
    }
    
}

