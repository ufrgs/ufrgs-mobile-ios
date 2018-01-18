//
//  Autorrenovacao.swift
//  ufrgsmobile
//
//  Created by Lucas Flores on 02/05/17.
//  Copyright © 2017 CPD UFRGS. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class autorrenovacaoCall: NSObject {
    
    let apiURL = INFOURL
    var result = false
    
    
    func autorrenova(completionHandler: @escaping (Bool?, Error?) -> ()) {
        makeCall("orders", completionHandler: completionHandler)
    }
    
    func makeCall(_ section: String, completionHandler: @escaping (Bool, Error?) -> ()) {
                
        self.result = false
        completionHandler(self.result, nil)
                
    }
}
