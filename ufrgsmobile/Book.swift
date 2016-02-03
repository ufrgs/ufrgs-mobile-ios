//
//  Book.swift
//  SabiRenovator
//
//  Created by Theodoro L. Mota on 06/05/15.
//  Copyright (c) 2015 Theodoro L. Mota. All rights reserved.
//


class Book: NSObject {
    
    var id : Int = 0
    var autor : String = "null"
    var titulo : String = "null"
    var dataEntrega : NSDate = NSDate(timeIntervalSinceReferenceDate: NSDate.timeIntervalSinceReferenceDate())
    var biblioteca : String = "null"

}
