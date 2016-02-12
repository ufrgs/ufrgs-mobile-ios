//
//  NewsViewController.swift
//  ufrgsmobile
//
//  Created by Theodoro L. Mota on 07/08/15.
//  Copyright (c) 2015 Theodoro L. Mota. All rights reserved.
//

import UIKit

class NewsViewController: UIViewController , UITableViewDelegate, UITableViewDataSource, MWFeedParserDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var items = [MWFeedItem]()
    @IBOutlet weak var tvCoverView: UIView!
    var overlayView : MRProgressOverlayView?
    var eduRoamCount = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.title = "Notícias"
        self.navigationItem.title = "UFRGS Mobile"
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            self.request()
        }
        
        self.tvCoverView.hidden = false
        MRProgressOverlayView.showOverlayAddedTo(self.parentViewController?.parentViewController?.view, animated: true)

    }
    
    override func viewDidAppear(animated: Bool) {
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // **************************************************************************************
    // MARK: - ParseFeed Delegates
    // **************************************************************************************

    
    func request() {
        let URL = NSURL(string: "http://www.ufrgs.br/ufrgs/noticias/noticias/RSS/")
        let feedParser = MWFeedParser(feedURL: URL);
        feedParser.delegate = self
        feedParser.feedParseType = ParseTypeFull
        feedParser.parse()
    }
    
    func feedParserDidStart(parser: MWFeedParser) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true;
        self.items = [MWFeedItem]()
    }
    
    func feedParserDidFinish(parser: MWFeedParser) {

        UIApplication.sharedApplication().networkActivityIndicatorVisible = true;
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            MRProgressOverlayView.dismissOverlayForView(self.parentViewController?.parentViewController?.view, animated: true)
            self.tvCoverView.hidden = true
            self.tableView.reloadData()
        }
        
        print("acabou parse")
        
    }
    
    
    func feedParser(parser: MWFeedParser, didParseFeedInfo info: MWFeedInfo) {
        //println(info)
        //self.title = info.title
    }
    
    func feedParser(parser: MWFeedParser, didParseFeedItem item: MWFeedItem) {
        //println(item)
        self.items.append(item)
    }
    
    func feedParser(parser: MWFeedParser!, didFailWithError error: NSError!) {
        if eduRoamCount < 10 {
            eduRoamCount += 1
            request()
        } else {
            print("mostrar dialogo de internet")
        }
        print("parse falhou miseravelmente!")
    }
    
    

    // **************************************************************************************
    // MARK: - TableView Delegates
    // **************************************************************************************
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:CustomTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("Cell") as! CustomTableViewCell
        
        let tempCell = items[indexPath.row] as MWFeedItem
        
        cell.lblNewsText.text = tempCell.title
        
        cell.imgNews.setImageWithUrlRequest(NSURLRequest(URL: NSURL(string: tempCell.link + "/image_thumb")!), placeHolderImage: nil, success: { (request, response, image, fromCache) -> Void in
                cell.imgNews.image = image
            
            }) { (request, response, error) -> Void in
                print("fail!")
        }
        
        //cell.imgNews.setImageWithUrl(NSURL(string: tempCell.link + "/image_thumb")!)
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.performSegueWithIdentifier("openNews", sender: indexPath.row)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "openNews") {
            if let destinationVC = segue.destinationViewController as? OpenNewsViewController{
                let row : Int = sender as! Int
                let tempNews = items[row] as MWFeedItem
                print(tempNews.title)
                
                let link = tempNews.link.stringByReplacingOccurrencesOfString("http://www.ufrgs.br/ufrgs/noticias/", withString: "")
                
                destinationVC.mTitle = tempNews.title
                destinationVC.mImage = tempNews.link + "/image_large"
                destinationVC.mLink = link
            }
        }
    }


}
