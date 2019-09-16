//
//  DemoPopupViewController2.swift
//  PopupController
//
//  Created by 佐藤 大輔 on 2/4/16.
//  Copyright © 2016 Daisuke Sato. All rights reserved.
//

import UIKit

class DemoPopupViewController2: UIViewController, PopupContentViewController, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var outdatedLabel: UILabel!
    @IBOutlet weak var topBarView: UIView!
    
    var isUpdated = false
    var button = UIButton(frame: .zero)
    var ticketsStrings = [String]()
    var tickets = [Tiquete]()
    var superviewFrame: CGRect?
    
    let check = InternetCheck()
    let popupWidth: CGFloat = 300.0

    override func viewDidLoad() {
        super.viewDidLoad()
        configureButton()
        tableView.tableFooterView = UIView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.layer.cornerRadius = 4
    }
    
    func configureButton() {
        let frame = CGRect(origin: CGPoint(x: 0, y: 8), size: CGSize(width: 44.0, height: 44.0))
        
        button.frame = frame
        button.setImage(UIImage(named: "closeIcon"), for: .normal)
        
        topBarView.addSubview(button)
    }
    
    class func instance() -> DemoPopupViewController2 {
        let storyboard = UIStoryboard(name: "DemoPopupViewController2", bundle: nil)
        return storyboard.instantiateInitialViewController() as! DemoPopupViewController2
    }
    
    func sizeForPopup(_ popupController: PopupController, size: CGSize, showingKeyboard: Bool) -> CGSize {
        return CGSize(width: popupWidth, height: calculateHeight())
    }
    
    private func calculateHeight() -> CGFloat {
        
        let headerHeight: CGFloat = 60.0
        let minSize: CGFloat = headerHeight + 68.0
        var maxSize: CGFloat = 380.0
        var contentHeight: CGFloat = 130.0
        
        if let frame = superviewFrame {
            maxSize = frame.size.height - 120.0
        }
        
        let cell = tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        
        if isUpdated && tickets.count > 0 {
            contentHeight = cell.frame.size.height * CGFloat(tickets.count)
        } else if ticketsStrings.count > 0 {
            contentHeight = cell.frame.size.height * CGFloat(ticketsStrings.count)
        }
        
        let height: CGFloat = contentHeight + headerHeight

        return max(minSize, min(height, maxSize))
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // in either case, if there is no ticket, return 1 cell to warn user that there is no ticket
        if isUpdated && tickets.count > 0 {
            return tickets.count
        } else if ticketsStrings.count > 0 {
                return ticketsStrings.count
        } else {
            return 1
        }

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // if fetch was done correctly
        if isUpdated {
            outdatedLabel.text = nil
            
            // if there is no ticket
            if tickets.count == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "noTicketCell") as! NoTicketCell
                cell.configure()
                return cell
            }
            
            // if there is ticket, just make sure index is in bounds
            if indexPath.row < tickets.count {
                // show ticket
                let ticket = tickets[indexPath.row]
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! DemoPopup2Cell
                
                cell.configure(nro: ticket.nro, total: ticket.total, restam: ticket.restam)
                
                return cell
            } else {
                return UITableViewCell()
            }
        }
        
        // if !upDated, then fetch failed
        else if ticketsStrings.count > 0 {
            
            // if there is no old ticket saved
            if ticketsStrings.count == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "noTicketCell") as! NoTicketCell
                cell.configure()
                cell.label.text = "Não foi possível obter os tíquetes."
                return cell
            }
            
            // if there is some, just make sure index is in bounds
            if indexPath.row < ticketsStrings.count {
                let ticketString = ticketsStrings[indexPath.row]
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! DemoPopup2Cell
                
                cell.configure(nro: ticketString, total: "", restam: "")
                
                return cell
            } else {
                return UITableViewCell()
            }
        }
            
        // if fetch was not done successfully and no old info was found
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "noTicketCell") as! NoTicketCell
            cell.configure()
            cell.label.text = "Não foi possível obter os tíquetes."
            return cell
        }
        
    }

}

// MARK: - Table View Cell

class DemoPopup2Cell: UITableViewCell {
    
    @IBOutlet weak var tiqueteImage: UIImageView!
    @IBOutlet weak var nroLabel: UILabel!
    @IBOutlet weak var totLabel: UILabel!
    @IBOutlet weak var dispoLabel: UILabel!
    
    func configure(nro: String, total: String, restam: String) {
        
        var adLabel = " adquiridos"
        var dispLabel = " disponíveis"
        
        if total == "1" {
            adLabel = " adquirido"
        }
        
        if restam == "1" {
            dispLabel = " disponível"
        }
        
        if total == "" {
            adLabel = ""
        }
        
        if restam == "" {
            dispLabel = ""
        }
        
        nroLabel.text = nro
        totLabel.text = total + adLabel.uppercased()
        dispoLabel.text = restam + dispLabel.uppercased()
        tiqueteImage.image = #imageLiteral(resourceName: "tiquetes")
    }
}

class NoTicketCell: UITableViewCell {
    
    let warning = "Nenhum tíquete disponível"
    @IBOutlet weak var label: UILabel!
    
    func configure() {
        self.label.text = self.warning
        self.separatorInset = UIEdgeInsetsMake(0.0, self.bounds.size.width, 0.0, 0.0);
    }
    
    func getHeight() -> CGFloat {
        return 122.0
    }
}
