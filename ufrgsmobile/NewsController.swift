//
//  NewsController.swift
//  ufrgsmobile
//
//  Created by Lucas Flores on 02/01/17.
//  Copyright © 2017 CPD UFRGS. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftOverlays
import Hero

class NewsController: UIViewController {
    
    // MARK: - Properties
    
    let news = GetNews()
    let check = InternetCheck()
    
    var items = [NewsItem]()
    var selectedIndex = 0
    
    let notificationsAPI = GetNotificacoes()
    var notifications = [NotificItem]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var notificationBarItem: UIBarButtonItem!
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.showWaitOverlay()
        
        self.hero.isEnabled = true
        self.navigationController?.hero.isEnabled = true

        self.title = "Notícias"
        self.navigationItem.title = "UFRGS Mobile"
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(NewsController.handleRefresh(refreshControl:)), for: UIControlEvents.valueChanged)
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 126.0
        self.tableView.hero.modifiers = [.cascade]
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()

        handleRefresh(refreshControl: refreshControl)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "UFRGS Mobile"
        
        // vê se tem notificações
        self.fetchNotifications()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showPrivacyPolicyIfNeeded()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openNews" {
            let controller = segue.destination as! OpenNewsController
            controller.news = items[selectedIndex]
            self.hero.modalAnimationType = .push(direction: .right)
        }
            
        else {
            if segue.identifier == "notific" {
                let controller = segue.destination as! NotificViewController
                controller.notfic = notifications
            }
        }
    }

    @objc func handleRefresh(refreshControl: UIRefreshControl) {
        // vê se tem notificações
        self.fetchNotifications()
        
        news.getOrders { (responseObject, error) in
            
            refreshControl.endRefreshing()
            self.removeAllOverlays()
            
            // remove the owl subview in tableview
            for view in self.tableView.subviews {
                if view is SadOwlView {
                    view.removeFromSuperview()
                }
            }
            
            if let news = responseObject {
                self.items.removeAll()
                self.items = news
                self.tableView.reloadData()
            } else {
                if !InternetCheck().isInternetAvailable() {
                    let sadOwl = SadOwlView(frame: self.tableView.frame, text: "Parece que você está sem conexão com a internet.")
                    self.items.removeAll()
                    self.tableView.reloadData()
                    self.tableView.addSubview(sadOwl)
                    return
                }
                
                let sadOwl = SadOwlView(frame: self.tableView.bounds, text: "As notícias estão indisponíveis no momento.")
                self.tableView.addSubview(sadOwl)
            }
        }
    }
    
    // MARK: - Handle notifications
    
    @objc func fetchNotifications() {
        print("> fetching notifications")
        
        self.notifications = []
        
        DispatchQueue.global(qos: .background).async {

            self.notificationsAPI.getOrders { (notifications, error) in
                
                if notifications != nil {
                    print("Há \(notifications!.count) notificacoes")
                    
                    self.notifications = notifications!
                    
                    DispatchQueue.main.async {
                        self.updateNotificationsUI()
                    }
                }
            }
        }

    }
    
    func updateNotificationsUI() {
        
        if notifications.count > 0 {
            self.notificationBarItem.isEnabled = true
            self.notificationBarItem.image = UIImage(named: "sino")
        }
        
        else {
            self.notificationBarItem.isEnabled = false
            self.notificationBarItem.image = nil
        }
        
    }
    
}

// MARK: - Table View Delegate

extension NewsController: UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        selectedIndex = indexPath.row
        self.performSegue(withIdentifier: "openNews", sender: self)
    }
    
}

// MARK: - Table View Data Source

extension NewsController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = items[indexPath.row]
        
        // primeiro item possui destaque
        if indexPath.row == 0 {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "newsHighlightCell") as! NewsItemHighlightCell
            
            let url = URL(string: item.imgLarge)
            
            cell.hero.modifiers = [.fade, .scale(0.9)]
            cell.titleLabel.hero.id = HeroId.newsTitle
            cell.imgView.hero.id = HeroId.newsImage
            cell.cardView.hero.id = HeroId.newsImage
            cell.configure(
                title: item.title,
                subtitle: item.chamada,
                url: url) { (img) in
                    self.items[indexPath.row].thumb = img
            }
            
            return cell
        }
        
        if item.hasImage {
            let cell: NewsItemCell = self.tableView.dequeueReusableCell(withIdentifier: "newsCell") as! NewsItemCell
            
            cell.hero.modifiers = [.fade, .scale(0.9)]
            cell.lblNewsText.hero.id = HeroId.newsTitle
            cell.setTitle(item.title)
            if let url = URL(string: item.imgThumb) {
                cell.loadImage(url: url, completion: { (img) in
                    cell.imgNews.hero.id = HeroId.newsImage
                    self.items[indexPath.row].thumb = img
                }) {
                    self.items[indexPath.row].hasImage = false
                }
            }
            return cell
        }
            
        else {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "newsItemNoImage") as! NewsItemNoImageCell
            cell.hero.modifiers = [.fade, .scale(0.9)]
            cell.titleLabel.hero.id = HeroId.newsTitle
            cell.titleLabel.text = item.title
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if items[indexPath.row].hasImage && indexPath.row != 0 {
            return 105
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
}

extension NewsController {
    
    func showPrivacyPolicyIfNeeded() {
        // show onboarding if app is being opened for the first time
        
        if UserDefaults.standard.object(forKey: "isFirstTime") == nil {
            
            let vc = PrivacyPolicyView()
            
            PopupController
                .create(self)
                .customize(
                    [
                        .animation(.fadeIn),
                        .scrollable(false),
                        .backgroundStyle(.blackFilter(alpha: 0.5)),
                    ]
                )
                .didShowHandler { popup in
                    print("showed popup!")
                    self.tableView.isScrollEnabled = false
                }
                .didCloseHandler { _ in
                    print("closed popup!")
                    self.tableView.isScrollEnabled = true
                }
                .show(vc)
            
            UserDefaults.standard.set(true, forKey: "isFirstTime")
        }

    }
    
}
