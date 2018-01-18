//
//  NewsController.swift
//  ufrgsmobile
//
//  Created by Lucas Flores on 02/01/17.
//  Copyright © 2017 CPD UFRGS. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftOverlays

class NewsController: UITableViewController {
    
    let news = GetNews()
    var items = [NewsItem]()
    let notific = GetNotificacoes()
    var notificItens = [NotificItem]()
    let check = InternetCheck()
    @IBOutlet weak var notificButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.showWaitOverlay()
        news.getOrders { (responseObject, error) in
            self.removeAllOverlays()
            self.items = responseObject!
            self.tableView.reloadData()
        }
        
        self.showWaitOverlay()
        notific.getOrders{(responseObject, error) in
            self.removeAllOverlays()
            self.notificItens = responseObject!
        }
        
        self.title = "Notícias"
        self.navigationItem.title = "UFRGS Mobile"
        self.refreshControl?.addTarget(self, action: #selector(NewsController.handleRefresh(refreshControl:)), for: UIControlEvents.valueChanged)
        
        self.notificButton.isEnabled = false
        self.notificButton.image = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "UFRGS Mobile"
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:CustomTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "Cell") as! CustomTableViewCell
        
        let tempCell = items[indexPath.row] 
        
        cell.lblNewsText.text = tempCell.title
        
        let imageURL = URL(string: tempCell.imgThumb)
        
        cell.imgNews.kf_setImage(with: imageURL)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openNews" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let controller = segue.destination as! OpenNewsController
                controller.news = items[indexPath.row]
            }
        }
            
        else {
            if segue.identifier == "notific" {
                let controller = segue.destination as! NotificViewController
                controller.notfic = notificItens
                
            }
        }
    }

    func handleRefresh(refreshControl: UIRefreshControl) {
        news.getOrders { (responseObject, error) in
            self.removeAllOverlays()
            self.items = responseObject!
            self.tableView.reloadData()
            refreshControl.endRefreshing()
        }
    }
}

