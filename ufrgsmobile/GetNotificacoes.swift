//
//  GetNotificacoes.swift
//  ufrgsmobile
//
//  Created by Lucas Flores on 18/08/17.
//  Copyright © 2017 CPD UFRGS. All rights reserved.
//

import Alamofire
import SwiftyJSON
import Kingfisher

class GetNotificacoes: NSObject {
    
    func getOrders(completionHandler: @escaping ([NotificItem]?, Error?) -> ()) {
        makeCall("orders", completionHandler: completionHandler)
    }
    
    func makeCall(_ section: String, completionHandler: @escaping ([NotificItem]?, Error?) -> ()) {
        var notfic = [NotificItem]()
        completionHandler(notfic, nil)
    }
    
}

