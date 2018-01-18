//
//  Login.swift
//  ufrgsmobile
//
//  Created by Lucas Flores on 18/01/17.
//  Copyright © 2017 CPD UFRGS. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class Login: NSObject {
    
    func getOrders(completionHandler: @escaping (Bool?, Error?) -> (), id: String, pass: String) {
        makeCall("orders", completionHandler: completionHandler, id: id, pass: pass)
    }
    
    func makeCall(_ section: String, completionHandler: @escaping (Bool, Error?) -> (), id: String, pass: String) {
        
        var result: Bool = false
        completionHandler(result, nil)
    }
}
