//
//  OpenNewsController.swift
//  ufrgsmobile
//
//  Created by Lucas Flores on 02/01/17.
//  Copyright © 2017 CPD UFRGS. All rights reserved.
//

import UIKit

class OpenNewsController: UITableViewController, UIWebViewDelegate, UIGestureRecognizerDelegate{

    var news = NewsItem(title: "", newsDescription: "", imgThumb: "", imgLarge: "", autor: "", data: "", subPhoto: "")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "image", for: indexPath) as! ImageCell
            let imageURL = URL(string: news.imgLarge)
            cell.newsImage.kf_setImage(with: imageURL)
            
            if news.subPhoto == "null"{
                cell.subPhoto.text = ""
            }
            
            else{
                
                cell.subPhoto.text = news.subPhoto
            }
            
            return cell
            
        }
            
        else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "title", for: indexPath) as! TitleCell
            cell.newsTitle.text = news.title
            
            return cell
        }
        else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "content", for: indexPath) as! ContentCell
            cell.labelConstraint.text = news.newsDescription
            cell.webView.delegate = self
            cell.webView.loadHTMLString("<font face='Avenir' size='4'>" + news.newsDescription, baseURL: nil)
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
        
        let section = indexPath.section
        let row = indexPath.row
        if section == 0 && row == 0{
            
            if news.photoW != 0{
            
                let x = (CGFloat(news.photoH) * UIScreen.main.bounds.width)/CGFloat(news.photoW)
            
                return x
            }
            
            else {
                
                return UITableViewAutomaticDimension
                
            }
            
        }
        
        else if section == 1 && row == 0{
            
            return UITableViewAutomaticDimension
        }
        
        return UITableViewAutomaticDimension
    }
}
