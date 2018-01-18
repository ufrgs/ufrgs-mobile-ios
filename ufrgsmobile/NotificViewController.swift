//
//  NotificViewController.swift
//  ufrgsmobile
//
//  Created by Lucas Flores on 23/08/17.
//  Copyright © 2017 CPD UFRGS. All rights reserved.
//

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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notfic.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row % 2 == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Ntitle", for: indexPath) as! NotificTitleCell
            cell.title.text = notfic[indexPath.row].titulo
            
            return cell
        }
        
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Ncontent", for: indexPath) as! NotificContentCell
            cell.labelConstraint.text = notfic[indexPath.row].texto
            cell.webView.delegate = self
            cell.webView.isHidden = true
            cell.webView.loadHTMLString("<font face='Avenir' size='3'>" + notfic[indexPath.row].texto, baseURL: nil)
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
