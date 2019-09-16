//
//  RuMenuViewController.swift
//  ufrgsmobile
//
//  Created by Augusto on 28/01/2019.
//  Copyright © 2019 CPD UFRGS. All rights reserved.
//

import UIKit

class RuMenuViewController: UIViewController, PopupContentViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var ruNameLabel: UILabel!
    
    @IBOutlet weak var closeButton: UIButton!
    
    var button = UIButton(frame: .zero)
    
    var menu: String = ""
    var name: String = ""
    var superviewFrame: CGRect?
    var bgColor: UIColor = .gray
    
    let popupWidth: CGFloat = 300.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureButton()
        
        tableView.tableFooterView = UIView()
        topBarView.backgroundColor = bgColor
        ruNameLabel.text = name
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.layer.cornerRadius = 4
    }
    
    func configureButton() {
        let frame = CGRect(origin: CGPoint(x: 0, y: 5), size: CGSize(width: 44.0, height: 44.0))
        
        button.frame = frame
        button.setImage(UIImage(named: "closeIcon"), for: .normal)
        
        topBarView.addSubview(button)
    }
    
    func sizeForPopup(_ popupController: PopupController, size: CGSize, showingKeyboard: Bool) -> CGSize {
        return CGSize(width: popupWidth, height: calculateHeight())
    }
    
    private func calculateHeight() -> CGFloat {
        
        let verticalConstraints: CGFloat = 40.0
        let horizontalConstraints: CGFloat = verticalConstraints
        let headerHeight: CGFloat = 55.0
        
        let minSize: CGFloat = headerHeight + 68.0
        var maxSize: CGFloat = 380.0
        
        if let frame = superviewFrame {
            maxSize = frame.size.height - 120.0
        }
        
        // create fake cell to calculate label size
        let cell = tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as! RuMenuCell
        cell.menuLabel.text = menu
        let neededSize = cell.menuLabel.sizeThatFits(CGSize(width: popupWidth - horizontalConstraints, height: .greatestFiniteMagnitude))

        // actual height is the label height + constraints top & bottom + popup header
        let height: CGFloat = neededSize.height + verticalConstraints + headerHeight
        
        return max(minSize, min(height, maxSize))
        
    }
    
    private func getNumberOfLines(text: String) -> Int {
        return text.components(separatedBy: "\n").count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ruMenuCell") as! RuMenuCell
        
        cell.menuLabel.text = menu
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
}

class RuMenuCell: UITableViewCell {
    
    @IBOutlet weak var menuLabel: UILabel!
    
}
