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
    
    let url = "https://www1.ufrgs.br/ws/siteufrgs/getnotificacoes/v"
    
    func getOrders(completionHandler: @escaping ([NotificItem]?, Error?) -> ()) {}
    
}

