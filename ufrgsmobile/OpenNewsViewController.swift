//
//  OpenNewsViewController.swift
//  ufrgsmobile
//
//  Created by Theodoro L. Mota on 21/08/15.
//  Copyright (c) 2015 Theodoro L. Mota. All rights reserved.
//

import UIKit

class OpenNewsViewController: UIViewController, UIWebViewDelegate, UIGestureRecognizerDelegate, ASMediasFocusDelegate {
    
    var mTitle : String = ""
    var mImage : String = ""
    var mText : String = ""
    var mLink : String = ""
    var mData : String = ""
    var mLegendaFoto : String = ""
    var mediaFocusManager : ASMediaFocusManager?

    @IBOutlet weak var newsImage: UIImageView!

    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var webView: UIWebView!
    
    @IBOutlet weak var sv: UIScrollView!
    @IBOutlet weak var photoHeight: NSLayoutConstraint!
    
    @IBOutlet weak var webViewConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newsTitle.text = self.mTitle
        newsTitle.font = UIFont.systemFontOfSize(22)
        //newsImage.setImageWithUrl(NSURL(string: mImage)!)
        newsImage.setImageWithUrlRequest(NSURLRequest(URL: NSURL(string: mImage)!), placeHolderImage: nil, success: { (request, response, image, fromCache) -> Void in
            
            print(response)
            
            self.newsImage.image = image
            
            }) { (request, response, error) -> Void in
                
                print("fail!")
                print(response)
                self.photoHeight.constant = 0
                self.view.layoutIfNeeded()
                
        }

        mediaFocusManager = ASMediaFocusManager()
        mediaFocusManager?.delegate = self
        mediaFocusManager?.installOnView(newsImage)
        
        
        webView.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: Selector("handleTap:"))
        tap.delegate = self
        newsImage.userInteractionEnabled = true
        newsImage.addGestureRecognizer(tap)
        
    
    }
    
    override func viewDidAppear(animated: Bool) {
        self.loadNews()
        self.sv.contentSize = CGSizeMake(self.view.frame.width, 360 + webView.bounds.height)
        //print(newsText.frame.height)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // *********************************************************************************
    // ------------- Tap Func -------------------------------------------------------
    // *********************************************************************************
    func handleTap(sender: UITapGestureRecognizer? = nil) {
        
        self.mediaFocusManager?.elasticAnimation = false
        self.mediaFocusManager?.zoomEnabled = true
        self.mediaFocusManager?.startFocusingView(self.newsImage)
        
        
        
    }
    
    func mediaFocusManager(mediaFocusManager: ASMediaFocusManager!, mediaURLForView view: UIView!) -> NSURL! {
        return NSURL(string: self.mImage)
    }
    
    func mediaFocusManager(mediaFocusManager: ASMediaFocusManager!, titleForView view: UIView!) -> String! {
        return self.mLegendaFoto
    }
    
    
    func parentViewControllerForMediaFocusManager(mediaFocusManager: ASMediaFocusManager!) -> UIViewController! {
        return self.parentViewController?.parentViewController
    }
    // *********************************************************************************
    // ------------- Funções aux -------------------------------------------------------
    // *********************************************************************************
    
    func loadNews() {
        
        let url : String = "https://www1.ufrgs.br/ws/siteUFRGS/getInfoNoticiaSiteUFRGS?nomeNoticia=" + self.mLink
        let request : NSMutableURLRequest = NSMutableURLRequest()
        request.URL = NSURL(string: url)
        request.HTTPMethod = "GET"
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
            
            let json = JSON(data: data!)
            let imagem = json["imagem"]
            
            
            let imagemUrl = imagem["url"].asString
            if json["data"].asString != nil {
                self.mData = json["data"].asString!
                
                
            }
            
            let noticia = json["texto"].asString
            let noticiaTeste = "<font face='Avenir' size='3'>" + noticia!
            
            if imagemUrl == nil {
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    self.photoHeight.constant = 0
                    self.view.layoutIfNeeded()
                })
            } else {
                if imagem["legenda"].asString != nil {
                    self.mLegendaFoto = imagem["legenda"].asString!
                }
            }
            
            self.webView.loadHTMLString(noticiaTeste, baseURL: nil)
            
        }

    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if navigationType == UIWebViewNavigationType.LinkClicked {
            UIApplication.sharedApplication().openURL(request.URL!)
            return false
        }
        return true
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        
        let newHeightString = self.webView.stringByEvaluatingJavaScriptFromString("document.body.scrollHeight")!
        let newHeight = (newHeightString as NSString).floatValue
        self.webViewConstraint.constant = CGFloat(newHeight)
        
        self.webView.layoutIfNeeded()
        self.sv.contentSize = CGSizeMake(self.view.frame.width, 360 + CGFloat(newHeight))
        
        print(CGFloat(newHeight))

        
    }
    

}
