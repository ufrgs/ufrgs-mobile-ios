//
//  DateHelper.swift
//  ufrgsmobile
//
//  Created by Augusto on 20/02/2019.
//  Copyright © 2019 CPD UFRGS. All rights reserved.
//

import Foundation

class DateHelper {
    
    // MARK: - Static public methods
    
    static public func dateFromString(_ string: String) -> Date? {
    
        let format = "yyyy-MM-dd hh:mm:ss"
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = format
        dateFormatter.isLenient = true
        
        return dateFormatter.date(from: string)
        
    }
    
    static public func dateHasPassed(_ date: Date) -> Bool {
        
        let now = Date()

        if date > now {
            return false
        }
        
        return true
        
    }
    
    static func todayIsWeekend() -> Bool {
        let now = Date()
        
        return Calendar.current.isDateInWeekend(now)
    }
    
    static func getStringFormatted(_ format: String) -> String {
        let date = Date()
        let formatter = DateFormatter()
        
        formatter.dateFormat = format
        
        return formatter.string(from: date)
    }
    
}
