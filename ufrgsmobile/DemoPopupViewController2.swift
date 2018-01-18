//
//  DemoPopupViewController2.swift
//  PopupController
//
//  Created by 佐藤 大輔 on 2/4/16.
//  Copyright © 2016 Daisuke Sato. All rights reserved.
//

import UIKit

class DemoPopupViewController2: UIViewController, PopupContentViewController, UITableViewDataSource {
    
    var fruits = resultTiquetes
    let check = InternetCheck()

    @IBOutlet weak var updateLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.updateLabel.text = ""
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.layer.cornerRadius = 4
    }
    
    class func instance() -> DemoPopupViewController2 {
        let storyboard = UIStoryboard(name: "DemoPopupViewController2", bundle: nil)
        return storyboard.instantiateInitialViewController() as! DemoPopupViewController2
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sizeForPopup(_ popupController: PopupController, size: CGSize, showingKeyboard: Bool) -> CGSize {
        return CGSize(width: 300, height: 300)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fruits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if check.isInternetAvailable() {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! DemoPopup2Cell
            
            var adLabel = " adquiridos"
            var dispLabel = " disponíveis"
            
            if fruits[(indexPath as NSIndexPath).row].total == "1" {
                adLabel = " adquirido"
            }
            
            if fruits[(indexPath as NSIndexPath).row].restam == "1" {
                dispLabel = " disponível"
            }
            
            updateLabel.isHidden = true
            
            cell.nroLabel.text = fruits[(indexPath as NSIndexPath).row].nro
            cell.totLabel.text = fruits[(indexPath as NSIndexPath).row].total + adLabel
            cell.dispoLabel.text = fruits[(indexPath as NSIndexPath).row].restam + dispLabel
            cell.tiqueteImage.image = #imageLiteral(resourceName: "tiquetes")
            
            return cell
        }
        
        
        else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! DemoPopup2Cell
            
            let nros = UserDefUtils.getTics()
            
            cell.nroLabel.text = nros[(indexPath as NSIndexPath).row]
            cell.totLabel.text = ""
            cell.dispoLabel.text = ""
            cell.tiqueteImage.image = #imageLiteral(resourceName: "tiquetes")
            
            updateLabel.text = UserDefUtils.getData()
            
            return cell
            
            
            
        }
        
        
    }
    
}

class DemoPopup2Cell: UITableViewCell {
    @IBOutlet weak var tiqueteImage: UIImageView!
    @IBOutlet weak var nroLabel: UILabel!
    @IBOutlet weak var totLabel: UILabel!
    @IBOutlet weak var dispoLabel: UILabel!
}
