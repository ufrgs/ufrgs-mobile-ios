//
//  OpenNewsController.swift
//  ufrgsmobile
//
//  Created by Lucas Flores on 02/01/17.
//  Copyright © 2017 CPD UFRGS. All rights reserved.
//

import UIKit
import Hero

class OpenNewsController: UITableViewController, UIGestureRecognizerDelegate {

    // MARK: - Properties
    
    var news = NewsItem(title: "", newsDescription: "", imgThumb: "", imgLarge: "", autor: "", data: "", subPhoto: "", chamada: "")
    var webViewHeight: CGFloat = 0.0
    var image: UIImage?
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hero.isEnabled = true
        self.title = ""
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 300
        
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openNewsToViewImage" {
            let vc = segue.destination as! ImageZoomViewController
            vc.image = self.image
        }
    }
    
    // MARK: - Actions
    
    @IBAction func share(_ sender: Any) {
    
        let url = self.news.imgThumb.components(separatedBy: "/image_thumb")[0]
        let text = "\(self.news.title)\n\(url)"
        
        let activityViewController = UIActivityViewController(activityItems: [text], applicationActivities: nil)

        activityViewController.popoverPresentationController?.sourceView = self.view
        
        DispatchQueue.main.async {
            self.present(activityViewController, animated: true, completion: nil)
        }
        
    }
    
}

// MARK: - UITableView methods

extension OpenNewsController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "titleImage", for: indexPath) as! NewsTitleImageCell
        
            cell.configure(image: news.thumb)
            cell.newsTitle.text = news.title
            cell.newsTitle.hero.id = HeroId.newsTitle
            
            if news.hasImage {
                let imageURL = URL(string: news.imgLarge)
                cell.newsImage.kf.setImage(with: imageURL, placeholder: news.thumb)
                cell.newsImage.hero.id = HeroId.newsImage
                self.image = cell.newsImage.image
            }
                
            return cell
        
        }
        
        else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPath) as! NewsDateCell
            cell.dateLabel.text = news.data
            return cell
        }
            
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "content", for: indexPath) as! ContentCell
            
            cell.webView.delegate = self
            cell.webView.scrollView.isScrollEnabled = false
            
            var html = "<font face='Avenir' size='4.0'>" + self.news.newsDescription
            html = HtmlUtils.completeRelativeLinks(htmlStr: html)
            
            print(html)
            
            cell.webView.loadHTMLString(html, baseURL: nil)

            return cell
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 2 {
            return webViewHeight + 32
        }
        
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 && self.image != nil {
            self.performSegue(withIdentifier: "openNewsToViewImage", sender: self)
        }
    }
    
}

// MARK: - UIWebView methods

extension OpenNewsController: UIWebViewDelegate {
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if navigationType == UIWebViewNavigationType.linkClicked {
            UIApplication.shared.openURL(request.url!)
            return false
        }
        return true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        let newHeight = webView.scrollView.contentSize.height
        
        if newHeight != webViewHeight {
            webViewHeight = newHeight
            tableView.reloadData()
        }
        
    }
    
}
