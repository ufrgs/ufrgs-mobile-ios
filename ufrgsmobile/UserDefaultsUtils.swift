//
//  SystemUtils.swift
//  ufrgsmobile
//
//  Created by Lucas Flores on 27/01/17.
//  Copyright © 2017 CPD UFRGS. All rights reserved.
//

import Foundation

let INFOURL = ""

class UserDefUtils: NSObject {
    
    static func tokenIsValid() -> Bool {
        
        // se possui token
        if UserDefUtils.getToken() != "nil" {
            
            // se possui data e ela não passou ainda
            if let date = UserDefUtils.getTokenExpiration() {
                if !DateHelper.dateHasPassed(date) {
                    return true
                }
            }
        }
        
        return false
        
    }
    
    // MARK: - Token
    
    static func saveToken(_ token: String){
        let saveTk = UserDefaults.standard
        saveTk.set(token, forKey: "token")
        saveTk.synchronize()
    }
    
    static func getToken() -> String{
        let getTk = UserDefaults.standard.object(forKey: "token")
        if getTk != nil {
            return getTk as! String
        }
        else {
            return "nil"
        }
    }
    
    static func deleteToken(){
        let deleteTk = UserDefaults.standard
        deleteTk.removeObject(forKey: "token")
        deleteTk.synchronize()
    }
    
    // MARK: - Token Expiration Date
    
    static func saveTokenExpiration(_ date: String) {
        let saveTk = UserDefaults.standard
        saveTk.set(date, forKey: "tokenExpiration")
        saveTk.synchronize()
    }
    
    static func getTokenExpiration() -> Date? {
        
        let dateAsString = UserDefaults.standard.object(forKey: "tokenExpiration")
        
        if dateAsString != nil {
            return DateHelper.dateFromString(dateAsString as! String)
        } else {
            return nil
        }
    }
    
    static func deleteTokenExpiration() {
        let deleteTk = UserDefaults.standard
        deleteTk.removeObject(forKey: "tokenExpiration")
        deleteTk.synchronize()
    }
    
    // MARK: - Auto renovação
    
    static func saveAuto(_ auto: String){
        let saveAr = UserDefaults.standard
        saveAr.set(auto, forKey: "autorrenovacao")
        saveAr.synchronize()
    }
    
    static func getAuto() -> String{
        let getAr = UserDefaults.standard.object(forKey: "autorrenovacao")
        if getAr != nil {
            return getAr as! String
        }
        else {
            return "nil"
        }
    }
    
    static func deleteAuto(){
        let deleteAr = UserDefaults.standard
        deleteAr.removeObject(forKey: "autorrenovacao")
        deleteAr.synchronize()
    }

    // MARK: - ID
    
    static func deleteID(){
        let deleteAr = UserDefaults.standard
        deleteAr.removeObject(forKey: "deviceID")
        deleteAr.synchronize()
    }
    
    static func saveID(_ id: String){
        let saveAr = UserDefaults.standard
        saveAr.set(id, forKey: "deviceID")
        saveAr.synchronize()
    }
    
    static func getID() -> String{
        let getAr = UserDefaults.standard.object(forKey: "deviceID")
        if getAr != nil {
            return getAr as! String
        }
        else {
            return "nil"
        }
    }
    
    
    // MARK: - FBID
    
    static func deleteFBID(){
        let deleteAr = UserDefaults.standard
        deleteAr.removeObject(forKey: "FBID")
        deleteAr.synchronize()
    }
    
    static func saveFBID(_ id: String){
        let saveAr = UserDefaults.standard
        saveAr.set(id, forKey: "FBID")
        saveAr.synchronize()
    }
    
    static func getFBID() -> String{
        let getAr = UserDefaults.standard.object(forKey: "FBID")
        if getAr != nil {
            return getAr as! String
        }
        else {
            return "nil"
        }
    }
    
    // MARK: - Tics
    
    static func saveTics(_ tic: [String]){
        let saveTk = UserDefaults.standard
        saveTk.set(tic, forKey: "tics")
        saveTk.synchronize()
    }

    static func getTics() -> [String]? {
        let getTk = UserDefaults.standard.object(forKey: "tics")
        if getTk != nil {
            return getTk as! [String]
        }
        else {
            return nil
        }
    }    
    static func deleteTics() {
        let deleteTk = UserDefaults.standard
        deleteTk.removeObject(forKey: "tics")
        deleteTk.synchronize()
    }
    
    // MARK: - Data
    
    static func deleteData() {
        let deleteAr = UserDefaults.standard
        deleteAr.removeObject(forKey: "ticData")
        deleteAr.synchronize()
    }
    
    static func saveData(_ id: String){
        let saveAr = UserDefaults.standard
        saveAr.set(id, forKey: "ticData")
        saveAr.synchronize()
    }
    
    static func getData() -> String? {
        let getAr = UserDefaults.standard.object(forKey: "ticData")
        if getAr != nil {
            return getAr as! String
        }
        else {
            return nil
        }
    }
    
    // MARK: - Delete All
    
    static func deleteAll() {
        
        let userDef = UserDefaults.standard
        let keys = ["token", "tokenExpiration", "autorrenovacao", "deviceID", "FBID", "tics", "ticData"]
        
        for key in keys {
            userDef.removeObject(forKey: key)
        }
        
    }
    
}
