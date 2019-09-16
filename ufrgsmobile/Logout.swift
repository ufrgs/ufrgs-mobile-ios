//
//  Logout.swift
//  ufrgsmobile
//
//  Created by Lucas Flores on 02/05/17.
//  Copyright © 2017 CPD UFRGS. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import UIKit

class Logout: NSObject {
    
    let apiURL = INFOURL
    var result = false
    
    func logout(completionHandler: @escaping (Bool?, Error?) -> ()) {}
    
}

