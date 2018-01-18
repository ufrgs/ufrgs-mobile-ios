//
//  RUController.swift
//  ufrgsmobile
//
//  Created by Lucas Flores on 02/01/17.
//  Copyright © 2017 CPD UFRGS. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftOverlays

class RUController: UITableViewController {
    
    let RUS = GetRU()
    let TIC = GetTiquetes()
    var items = [RUModel]()
    @IBOutlet weak var tiquetesButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.showWaitOverlay()
        RUS.getOrders { (responseObject, error) in
            self.removeAllOverlays()
            self.items = responseObject!
            self.tableView.reloadData()
        }
        
        self.refreshControl?.addTarget(self, action: #selector(RUController.handleRefresh(refreshControl:)), for: UIControlEvents.valueChanged)
        
        self.title = "RU"
        self.navigationItem.title = "UFRGS Mobile"
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 500
        tableView.reloadData()
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    @IBAction func tiquetesAction(_ sender: Any) {
        
        if UserDefUtils.getToken() != "nil"{
            self.showWaitOverlay()
            TIC.getTic { (responseObject, error) in
                self.removeAllOverlays()
                self.tiquetesPopup()
            }
        }
        
        else {
            let alert = UIAlertController(title: "Você não está logado!", message: "Para ver seus tickets, faça login e tente novamente.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {(action: UIAlertAction!) in self.tabBarController!.selectedIndex = 2}))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func tiquetesPopup(){
        PopupController
            .create(self)
            .customize(
                [
                    .animation(.slideUp),
                    .scrollable(false),
                    .backgroundStyle(.blackFilter(alpha: 0.7)),
                    .layout(.top)
                ]
            )
            .didShowHandler { popup in
                self.tiquetesButton.isEnabled = false
                self.tableView.setContentOffset(CGPoint.zero, animated: true)
                self.tableView.isScrollEnabled = false
            }
            .didCloseHandler { _ in
                self.tiquetesButton.isEnabled = true
                self.tableView.isScrollEnabled = true
            }
            .show(DemoPopupViewController2.instance())
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:RuCell = self.tableView.dequeueReusableCell(withIdentifier: "rucell") as! RuCell
        
        cell.cardapio.text = "\n " + items[indexPath.row].cardapio + "\n"
        cell.ruTitle.text = items[indexPath.row].nome
        cell.ruImage.image = UIImage(named: items[indexPath.row].imagem)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return UITableViewAutomaticDimension
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        self.showWaitOverlay()
        RUS.getOrders { (responseObject, error) in
            self.removeAllOverlays()
            self.items = responseObject!
            self.tableView.reloadData()
            refreshControl.endRefreshing()
        }
    }
    
}


