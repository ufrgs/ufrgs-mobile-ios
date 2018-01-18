//
//  GetTiquetes.swift
//  ufrgsmobile
//
//  Created by Lucas Flores on 05/09/17.
//  Copyright © 2017 CPD UFRGS. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

var resultTiquetes = [Tiquete]()

class GetTiquetes: NSObject {
    
    let apiURL = INFOURL
    var result = false
    var savedTics = [String]()
    
    
    func getTic(completionHandler: @escaping (Bool?, Error?) -> ()) {
        makeCall("orders", completionHandler: completionHandler)
    }
    
    func makeCall(_ section: String, completionHandler: @escaping (Bool, Error?) -> ()) {
            completionHandler(self.result, nil)
    }
}

