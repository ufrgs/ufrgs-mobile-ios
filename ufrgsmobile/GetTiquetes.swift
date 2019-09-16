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

class GetTiquetes: NSObject {
    
    let apiURL = INFOURL
    
    func getTickets(completionHandler: @escaping ([Tiquete]?, Error?) -> ()) {}

}

