//
//  GetBooks.swift
//  ufrgsmobile
//
//  Created by Lucas Flores on 18/01/17.
//  Copyright © 2017 CPD UFRGS. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class GetBooks: NSObject {
    
    let apiURL = INFOURL
    var userInfo = User()
    
    
    func getEmprestimos(completionHandler: @escaping (User?, Error?) -> ()) {
        makeCall("orders", completionHandler: completionHandler)
    }
    
    func makeCall(_ section: String, completionHandler: @escaping (User, Error?) -> ()) {
        completionHandler(self.userInfo, nil)
    }
}



