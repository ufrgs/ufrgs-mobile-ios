//
//  GetRU.swift
//  ufrgsmobile
//
//  Created by Lucas Flores on 09/01/17.
//  Copyright © 2017 CPD UFRGS. All rights reserved.

import Foundation
import Alamofire
import SwiftyJSON

class GetRU: NSObject {
    
    func getOrders(completionHandler: @escaping ([RUModel]?, Error?) -> ()) {
        makeCall("orders", completionHandler: completionHandler)
    }
    
    func makeCall(_ section: String, completionHandler: @escaping ([RUModel]?, Error?) -> ()) {
        
        var RUs = [RUModel]()
        let ruNames = ["Centro", "Saúde", "Vale", "Agronomia", "Esef", "Bloco 4"]
            
        completionHandler(RUs, nil)
    }
}
