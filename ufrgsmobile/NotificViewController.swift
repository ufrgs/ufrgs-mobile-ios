//
//  NotificViewController.swift
//  ufrgsmobile
//
//  Created by Lucas Flores on 23/08/17.
//  Copyright © 2017 CPD UFRGS. All rights reserved.
//

import Foundation
import UIKit

class NotificViewController: UITableViewController, UIWebViewDelegate, UIGestureRecognizerDelegate{
    
    var notfic = [NotificItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        self.navigationItem.title = "Notificações"
        
        tableView.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notfic.count * 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row % 2 == 0 {
            let index = indexPath.row / 2
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "Ntitle", for: indexPath) as! NotificTitleCell
            cell.title.text = notfic[index].titulo
            
            return cell
        }
        
        else {
            let index = (indexPath.row - 1) / 2
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "Ncontent", for: indexPath) as! NotificContentCell
            cell.labelConstraint.text = notfic[index].texto
            
            cell.labelConstraint.isHidden = true
            
            cell.webView.delegate = self
            cell.webView.isHidden = false
            cell.webView.loadHTMLString("<font face='Avenir' size='4'>" + notfic[index].texto, baseURL: nil)
            
            cell.webView.scrollView.isScrollEnabled = false
            
            return cell
        }
        
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if navigationType == UIWebViewNavigationType.linkClicked {
            UIApplication.shared.openURL(request.url!)
            return false
        }
        return true
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
}
