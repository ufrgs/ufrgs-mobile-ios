//
//  RestaurantController.swift
//  ufrgsmobile
//
//  Created by Augusto on 23/01/2019.
//  Copyright © 2019 CPD UFRGS. All rights reserved.
//

import Foundation
import UIKit

class RestaurantController: UIViewController {
    
    // MARK: - Properties
    
    let RUS = GetRU()
    let TIC = GetTiquetes()
    var items = [RUModel]()
    var cellsExpanded = [Bool]()
    let refreshControl = UIRefreshControl()
    
    let bannerUrl: String = "https://www.ufrgs.br/laranjanacolher/"
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var ticketsButton: UIBarButtonItem!
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showWaitOverlay()
        
        // fetch items
        
        fetchItems {
            self.removeAllOverlays()
            self.tableView.reloadData()
        }
        
        // UI config
        
        configureNavBar()
        configureTableView()
        
        tableView.reloadData()
        
    }
    
    
    // MARK: - Actions
    
    @IBAction func dalButtonAction(_ sender: Any) {
        UIApplication.shared.openURL(URL(string: bannerUrl)!)
    }

    @IBAction func ticketsAction(_ sender: Any) {

        if UserDefUtils.tokenIsValid() {
         
            self.showWaitOverlay()
            self.ticketsButton.isEnabled = false

            TIC.getTickets { (tickets, error) in
                self.removeAllOverlays()
                
                // if fetch was succesfull
                if let t = tickets {
                    self.tiquetesPopup(tickets: t, ticketsString: nil)
                }
                
                // if not, check if there is some older info saved
                else {
                    if let ticketsInfo = UserDefUtils.getTics() {
                        self.tiquetesPopup(tickets: nil, ticketsString: ticketsInfo)
                    } else {
                        self.alertTicketFetchFailed()
                    }
                }
            }
        }

        else {
            UserDefUtils.deleteAll()
            
            // mostra tela de login
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginController = storyboard.instantiateViewController(withIdentifier: "loginController") as! LoginController
            let navBarOnModal: UINavigationController = UINavigationController(rootViewController: loginController)
            
            loginController.configureCancelButton()
            navBarOnModal.navigationBar.isTranslucent = false
            
            self.present(navBarOnModal, animated: true, completion: nil)
            
            
//            let alert = UIAlertController(title: "Você não está logado!", message: "Para ver seus tickets, faça login e tente novamente.", preferredStyle: UIAlertControllerStyle.alert)
//            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {(action: UIAlertAction!) in self.tabBarController!.selectedIndex = 2}))
//            self.present(alert, animated: true, completion: nil)
        }

    }

    @objc func refresh(_ refreshControl: UIRefreshControl) {
        fetchItems {
            self.removeAllOverlays()
            self.refreshControl.endRefreshing()
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Other methods
    
    func fetchItems(completion: @escaping () -> ()) {
        RUS.getOrders { (responseObject, error) in
            
            // remove the owl subview in tableview
            for view in self.tableView.subviews {
                if view is SadOwlView {
                    view.removeFromSuperview()
                }
            }
            
            // if got a valid response
            if let items = responseObject {
                self.items = items
                
                // reset array that indicates wheter a cell in position i is expanded or not
                self.cellsExpanded.removeAll()
                
                for _ in 0..<self.items.count {
                    self.cellsExpanded.append(false)
                }
            } else {
                // if is already showing items, just alert that couldn't get more (to keep showing the old version just in case)
                if self.items.count > 0 {
                    self.alertMenuUnavailable()
                } else {
                    self.showMenuUnavailableView()
                }
            }
            
            completion()
        }
    }
    
    func alertMenuUnavailable() {
        let alert = UIAlertController(title: "Erro", message: "Não foi possível obter as novas informações do RU.", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showMenuUnavailableView() {
        
        if DateHelper.todayIsWeekend() {
            let sadOwl = SadOwlView(frame: tableView.frame, text: "Os RUs estão fechados hoje.")
            tableView.addSubview(sadOwl)
            return
        }
        
        if !InternetCheck().isInternetAvailable() {
            let sadOwl = SadOwlView(frame: tableView.frame, text: "Parece que você está sem conexão com a internet.")
            tableView.addSubview(sadOwl)
            return
        }
        
        let sadOwl = SadOwlView(frame: tableView.frame, text: "Os cardápios não estão disponíveis no momento.")
        tableView.addSubview(sadOwl)
    }

    func tiquetesPopup(tickets: [Tiquete]?, ticketsString: [String]?) {

        let vc = DemoPopupViewController2.instance()
        vc.superviewFrame = self.view.frame
        
        if let t = tickets {
            vc.tickets = t
            vc.isUpdated = true
        } else if let ts = ticketsString {
            vc.ticketsStrings = ts
            vc.isUpdated = false
        } else {
            alertTicketFetchFailed()
            return
        }
        
        PopupController
            .create(self)
            .customize(
                [
                    .animation(.fadeIn),
                    .scrollable(false),
                    .backgroundStyle(.blackFilter(alpha: 0.7)),
                    .layout(.top)
                ]
            )
            .didShowHandler { popup in
                print("showed popup!")
                self.tableView.isScrollEnabled = false
            }
            .didCloseHandler { _ in
                print("closed popup!")
                self.ticketsButton.isEnabled = true
                self.tableView.isScrollEnabled = true
            }
            .registerCloseButton(button: vc.button)
            .show(vc)
    }
    
    func alertTicketFetchFailed() {
        let alert = UIAlertController(title: "Erro", message: "Não foi possível obter as informações dos tíquetes", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alert.addAction(ok)
        
        self.present(alert, animated: true, completion: nil)
    }
    
}

// MARK: Table View Data Source methods

extension RestaurantController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "dalCell") as! DalCell
            return cell
        }
        
        let i = indexPath.row - 1
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! RuExpandableCell
        
        cell.configure(isExpanded: cellsExpanded[i], ru: items[i])
        
        return cell
    }
    
}

// MARK: Table View Delegate methods

extension RestaurantController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if indexPath.row == 0 {
            if let url = URL(string: bannerUrl) {
                UIApplication.shared.openURL(url)
            }
            return
        }

        let index = indexPath.row - 1
        
        cellsExpanded[index] = !cellsExpanded[index]
        
        tableView.reloadRows(at: [indexPath], with: .fade)
        
        // if expanded, scroll to make selected cell visible
        if cellsExpanded[index] {
            self.tableView.scrollToRow(at: indexPath, at: .none, animated: true)
        }
        
    }
    
}

// MARK: - UI Configuration methods

extension RestaurantController {
    
    func configureNavBar() {
        self.title = "Restaurante"
        self.navigationItem.title = "UFRGS Mobile"
    }
    
    func configureTableView() {
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 12, right: 0)
        
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 80.0
        
//        self.tableView.tableHeaderView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: tableView.bounds.width, height: 1.0)))
//        self.tableView.tableHeaderView?.isHidden = false
    }
    
}
