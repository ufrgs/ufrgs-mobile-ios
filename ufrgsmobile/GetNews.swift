//
//  GetNoticias.swift
//  ufrgsmobile
//
//  Created by Lucas Flores on 02/01/17.
//  Copyright © 2017 CPD UFRGS. All rights reserved.
//

import Alamofire
import SwiftyJSON
import Kingfisher
import UIKit

extension String {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: Data(utf8),
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            print("error: ", error)
            return nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}

class GetNews: NSObject {
    
    func getOrders(completionHandler: @escaping ([NewsItem]?, Error?) -> ()) {
        makeCall("orders", completionHandler: completionHandler)
    }
    
    func makeCall(_ section: String, completionHandler: @escaping ([NewsItem]?, Error?) -> ()) {
        
        var news = [NewsItem]()
        
        Alamofire.request("https://www1.ufrgs.br/WS/siteUFRGS/getNoticias/?v=1").responseJSON { response in
            
            print(response)
            
            if let status = response.response?.statusCode {
                switch(status){
                    
                case 200:
                    print("example success")
                    break
                default:
                    completionHandler(nil, "fail" as? Error)
                    print("error with response status: \(status)")
                    break
                }
            }
            
            if response.result.value != nil {
                
                let json = JSON(response.result.value as Any)
                
                for (index, _) in json{
                    
                    
                    let myString = String(describing: json[Int(index)!]["texto"])
                    
                    let regex = try! NSRegularExpression(pattern: "[\\?]",
                                                         options: NSRegularExpression.Options.caseInsensitive)
                    
                    let range = NSMakeRange(0, (myString.characters.count))
                    
                    let modString = regex.stringByReplacingMatches(in: myString,
                                                                   options: [],
                                                                   range: range,
                                                                   withTemplate: "")
                    
                    let item = NewsItem(
                        title: String(describing: json[Int(index)!]["titulo"]),
                        newsDescription: modString/*.html2String*/,
                        imgThumb: String(describing: json[Int(index)!]["image_thumb"]),
                        imgLarge: String(describing: json[Int(index)!]["image_large"]),
                        autor: "",
                        data: String(describing: json[Int(index)!]["data"]),
                        subPhoto: String(describing: json[Int(index)!]["imagem"]["legenda"]),
                        chamada: String(describing: json[Int(index)!]["chamada"]))
                    
                    
                    // check if imagem is a list
                    if let array = json[Int(index)!]["imagem"].array {
                        if array.isEmpty {
                            item.hasImage = false
                        }
                    }
                    
                    if String(describing: json[Int(index)!]["imagem"]) != "" && json[Int(index)!]["imagem"] != JSON.null {
                        let pw = String(describing: json[Int(index)!]["imagem"]["width"]) as NSString
                        let ph = String(describing: json[Int(index)!]["imagem"]["height"]) as NSString
                    
                        item.photoH = Int(ph.intValue)
                        item.photoW = Int(pw.intValue)
                        
//                        if let url = URL(string: String(describing: json[Int(index)!]["imagem"]["url"])) {
//                            do {
//                                try item.thumb = UIImage(data: Data(contentsOf: url))
//                            }
//                            catch {
//                                print(error)
//                            }
//                        }
                        
                    } else {
                        item.hasImage = false
                    }
                    
                    news.append(item)
                }
                
                completionHandler(news, nil)
                return
            }
            
            completionHandler(nil, nil)
        }
        
    }
    
}
