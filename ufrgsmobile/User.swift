//
//  User.swift
//  ufrgsmobile
//
//  Created by Lucas Flores on 14/02/17.
//  Copyright © 2017 CPD UFRGS. All rights reserved.
//

import Foundation

class User: NSObject{
    
    var name: String = ""
    var qtdEmpr: String = ""
    var qtdResv: String = ""
    var debt: String = ""
    var emprs = [Book]()
    
}
