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


class AceitaTermo: NSObject {
    
    let apiURL = INFOURL
    var result = ""
    
    func aceitaTerm(completionHandler: @escaping (String?, Error?) -> ()) {}
    
}
