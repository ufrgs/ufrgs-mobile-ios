//
//  GetStatus.swift
//  ufrgsmobile
//
//  Created by Lucas Flores on 12/06/17.
//  Copyright © 2017 CPD UFRGS. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class GetStatus: NSObject {
    
    let apiURL = INFOURL
    var result = false
    
    
    func getSt(completionHandler: @escaping (Bool?, Error?) -> ()) {
        makeCall("orders", completionHandler: completionHandler )
    }
    
    func makeCall(_ section: String, completionHandler: @escaping (Bool, Error?) -> ()) {
        self.result = false
        completionHandler(self.result, nil)
    }
}




