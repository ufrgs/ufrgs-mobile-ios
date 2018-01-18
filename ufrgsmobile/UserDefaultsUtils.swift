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
    
    static func saveTics(_ tic: [String]){
        let saveTk = UserDefaults.standard
        saveTk.set(tic, forKey: "tics")
        saveTk.synchronize()
    }

    static func getTics() -> [String]{
        let getTk = UserDefaults.standard.object(forKey: "tics")
        if getTk != nil {
            return getTk as! [String]
        }
        else {
            return ["nil"]
        }
    }    
    static func deleteTics(){
        let deleteTk = UserDefaults.standard
        deleteTk.removeObject(forKey: "tics")
        deleteTk.synchronize()
    }
    
    
    static func deleteData(){
        let deleteAr = UserDefaults.standard
        deleteAr.removeObject(forKey: "ticData")
        deleteAr.synchronize()
    }
    
    static func saveData(_ id: String){
        let saveAr = UserDefaults.standard
        saveAr.set(id, forKey: "ticData")
        saveAr.synchronize()
    }
    
    static func getData() -> String{
        let getAr = UserDefaults.standard.object(forKey: "ticData")
        if getAr != nil {
            return getAr as! String
        }
        else {
            return "nil"
        }
    }
    

    
}
