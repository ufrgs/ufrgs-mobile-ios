//
//  BiblioController.swift
//  ufrgsmobile
//
//  Created by Lucas Flores on 02/01/17.
//  Copyright © 2017 CPD UFRGS. All rights reserved.
//

import UIKit
//import Kingfisher

class BiblioController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    
    let getBooks = GetBooks()
    let logout = Logout()
    let renovarAgora = RenovarAgora()
    let autorrenova = autorrenovacaoCall()
    let aceita = AceitaTermo()
    let putDespositivo = PutDispositivo()
    let status = GetStatus()
    let network = InternetCheck()
    var userInfo = User()
    var books = [Book]()
    var refreshControl = UIRefreshControl()
    
    var hasFetched = false
    
    // MARK: - Overrides
    
    override func  viewDidLoad() {
        
        super.viewDidLoad()
        
        self.configureTableView()
        
        self.showWaitOverlay()
        
        aceita.aceitaTerm(completionHandler: {(resposeObject, error) in
            
            self.putDespositivo.putDispositivos(completionHandler: {(responseObject, error) in
                
                self.status.getSt(completionHandler: {(responseObject, error) in })
                
                self.tableView.reloadData()
                
            })
            
            self.showWaitOverlay()
            self.updateInfo()
            
        })
        
        self.tableView.allowsSelection = false
        
        self.title = "Biblioteca"
        self.navigationItem.title = "UFRGS Mobile"
        
        self.navigationItem.hidesBackButton = true
        self.view.window?.isUserInteractionEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // se não tiver token ou estiver expirado, volta para a tela de login
        if !UserDefUtils.tokenIsValid() {
            UserDefUtils.deleteAll()
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    // MARK: - Actions
    
    @IBAction func renovarAgora(_ sender: Any) {
        
        if self.books.count > 0 {
            self.showWaitOverlay()
            renovarAgora.renovar(completionHandler: { (responseObject, error) in
                self.removeAllOverlays()
                let alert = UIAlertController(title: "Resultado", message: responseObject, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                self.tableView.reloadData()
            })
            
            updateInfo()
        } else {
            let alert = UIAlertController(title: "", message: "Você não possui nenhum livro para renovar.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    
    @IBAction func autorrenovacaoAction(_ sender: Any) {
        
        if UserDefUtils.getAuto() == "S" {
            
            let alert = UIAlertController(title: "Desativar autorrenovação", message: "Não haverá mais renovação automática diária dos empréstimos em seu nome. Você realmente deseja desativar a autorrenovação?", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Não", style: UIAlertActionStyle.default, handler: nil))
            alert.addAction(UIAlertAction(title: "Sim", style: UIAlertActionStyle.default, handler: {(action: UIAlertAction!) in self.autorrenovaAction()}))
            
            self.present(alert, animated: true, completion: nil)
            
        }
            
        else {
            
            let alert = UIAlertController(title: "Ativar autorrenovação", message: "Os empréstimos em seu nome serão renovados diariamente, desde que não haja qualquer impedimento. Mantenha-se sempre logado para receber notificações de autorrenovação. É de sua responsabilidade verificar se todos os empréstimos foram renovados.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Não", style: UIAlertActionStyle.default, handler: nil))
            alert.addAction(UIAlertAction(title: "Sim", style: UIAlertActionStyle.default, handler: {(action: UIAlertAction!) in self.autorrenovaAction()}))
            
            self.present(alert, animated: true, completion: nil)
            
        }
        
        
    }
    
    func autorrenovaAction(){
        self.showWaitOverlay()
        
        autorrenova.autorrenova(completionHandler: { (responseObject, error) in
            self.tableView.reloadData()
            self.removeAllOverlays()
        })
        
    }
    
    @IBAction func actiontest(_ sender: Any) {
        
        let alert = UIAlertController(title: "Logout", message: "Ao sair você não receberá notificação de autorrenovação. Deseja sair?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Não", style: UIAlertActionStyle.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Sim", style: UIAlertActionStyle.default, handler: {(action: UIAlertAction!) in self.logoutAction()}))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func logoutAction() {
        
        self.showWaitOverlay()
        
        logout.logout(completionHandler: {(responseObject, error) in
            UserDefUtils.deleteAll()
            
            self.removeAllOverlays()
            self.navigationController?.popToRootViewController(animated: true)
        })
        
    }
    
    func updateInfo() {
        
        if !network.isInternetAvailable() {
            let sadOwl = SadOwlView(frame: tableView.frame, text: "Parece que você está sem conexão com a internet.")
            tableView.addSubview(sadOwl)
            
            self.removeAllOverlays()
            self.refreshControl.endRefreshing()
            
            return
        }
        
        // remove the error subview in tableview
        for view in tableView.subviews {
            if view is SadOwlView {
                view.removeFromSuperview()
            }
        }
        
        self.getBooks.getEmprestimos(completionHandler: { (responseObject, error) in
            self.userInfo = responseObject!
            self.books = self.userInfo.emprs
            
            self.tableView.reloadData()
            
            self.removeAllOverlays()
            self.refreshControl.endRefreshing()
        })
    }
    
    @objc func refresh(_ refreshControl: UIRefreshControl) {
//        refreshControl.endRefreshing()
        updateInfo()
    }
    
}

// MARK: - Table View Data Source methods

extension BiblioController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if books.count > 0 {
            return books.count + 1
        } else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "biblioUserCell") as! BiblioUserCell
            
            cell.configure(
                name: userInfo.name,
                loans: userInfo.qtdEmpr,
                reservations: userInfo.qtdResv,
                debit: userInfo.debt,
                renovationState: UserDefUtils.getAuto()
            )
            
            return cell
        }
        
        // segunda célula quando não há livro
        else if (indexPath.row == 1 && books.count == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "noLoanCell") as! NoLoanCell
            return cell
        }
            
        else {
            print("tem livro!\n\n\n\n\n")
            let book = books[indexPath.row - 1]
            let cell = tableView.dequeueReusableCell(withIdentifier: "biblioCell") as! BiblioCell
            
            cell.configure(
                title: book.titulo,
                author: book.autor,
                isbn: book.isbn,
                devolutionDate: book.dataEntrega
            )
            
            return cell
        }
    }
    
}

// MARK: - UI configuration methods

extension BiblioController {
    
    func configureTableView() {
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 12, right: 0)
        
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        
        self.tableView.insertSubview(refreshControl, at: 0)
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 80.0
        
        self.tableView.tableHeaderView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: tableView.bounds.width, height: 1.0)))
        self.tableView.tableHeaderView?.isHidden = false
    }
    
}
