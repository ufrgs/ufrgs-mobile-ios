//
//  RenovarAgora.swift
//  ufrgsmobile
//
//  Created by Lucas Flores on 02/05/17.
//  Copyright © 2017 CPD UFRGS. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class RenovarAgora: NSObject {
    
    let apiURL = INFOURL
    var result = ""
    
    
    func renovar(completionHandler: @escaping (String?, Error?) -> ()) {
        makeCall("orders", completionHandler: completionHandler)
    }
    
    func makeCall(_ section: String, completionHandler: @escaping (String, Error?) -> ()) {
        
        completionHandler(self.result, nil)
    }
}
