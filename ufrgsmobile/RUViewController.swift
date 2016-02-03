//
//  RUViewController.swift
//  ufrgsmobile
//
//  Created by Theodoro L. Mota on 07/08/15.
//  Copyright (c) 2015 Theodoro L. Mota. All rights reserved.
//

import UIKit

class RUViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSURLConnectionDelegate

 {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    let ruNames = ["Centro", "Saúde", "Vale", "Agronomia", "Esef", "Bloco 4"]
    
    var ruCardapios : [String] = []
    
    var cellHeight : [Int] = [0, 0, 0, 0, 0, 0]
    
    var mutableData : NSMutableData?
    var currentElementName:NSString = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadRu()
        
        self.title = "RU"
        self.navigationItem.title = "UFRGS Mobile"
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.tableView.estimatedRowHeight = 100.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // **************************************************************************************
    // MARK: - TableView Delegates
    // **************************************************************************************
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell : RuTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("ruCell", forIndexPath: indexPath) as! RuTableViewCell
        
        cell.ruTitle.text = ruNames[indexPath.row]
        cell.ruImage.image = UIImage(named: "ru" + String(indexPath.row + 1))
        cell.cardapio.numberOfLines = 0
        if ruCardapios.count > 2 {
            cell.cardapio.text = ruCardapios[indexPath.row]
        
        }

        
        //cell.heightConstrain.constant = 80 + cell.cardapio.frame.height + 16
        //self.cellHeight[indexPath.row] = 80 + Int(cell.cardapio.frame.height) + 16 + 20
        //self.view.layoutIfNeeded()
        
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.layoutIfNeeded()
    }
    

    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 25.0
    }
    // *********************************************************************************
    // MARK: - Funções aux -------------------------------------------------------
    // *********************************************************************************
    
    func loadRu () {
        
        let url : String = "https://www1.ufrgs.br/WS/siteUFRGS/getCardapioRU"
        let request : NSMutableURLRequest = NSMutableURLRequest()
        request.URL = NSURL(string: url)
        request.HTTPMethod = "GET"
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
            
            let json = JSON(data: data!)
            
            if json["ru1"]["cardapio"].asString != nil {
                let ru1 = json["ru1"]["cardapio"].asString
                let ru2 = json["ru2"]["cardapio"].asString
                let ru3 = json["ru3"]["cardapio"].asString
                let ru4 = json["ru4"]["cardapio"].asString
                let ru5 = json["ru5"]["cardapio"].asString
                let ru6 = json["ru6"]["cardapio"].asString
                
                self.ruCardapios.append(ru1!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()))
                self.ruCardapios.append(ru2!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()))
                self.ruCardapios.append(ru3!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()))
                self.ruCardapios.append(ru4!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()))
                self.ruCardapios.append(ru5!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()))
                self.ruCardapios.append(ru6!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()))
            } else {
                self.ruCardapios.append("Cardápio não disponível")
                self.ruCardapios.append("Cardápio não disponível")
                self.ruCardapios.append("Cardápio não disponível")
                self.ruCardapios.append("Cardápio não disponível")
                self.ruCardapios.append("Cardápio não disponível")
                self.ruCardapios.append("Cardápio não disponível")
            }
            
            self.tableView.reloadData()

        }
        

    }
    

}
