//
//  GetRU.swift
//  ufrgsmobile
//
//  Created by Lucas Flores on 09/01/17.
//  Copyright © 2017 CPD UFRGS. All rights reserved.

import Foundation
import Alamofire
import SwiftyJSON

class GetRU: NSObject {
    
    let unavailableMenu = "Cardápio não disponível"
    
    func getOrders(completionHandler: @escaping ([RUModel]?, Error?) -> ()) {
        makeCall("orders", completionHandler: completionHandler)
    }
    
    func makeCall(_ section: String, completionHandler: @escaping ([RUModel]?, Error?) -> ()) {
        
        var RUs = [RUModel]()
        let ruNames = ["Centro", "Saúde", "Vale", "Agronomia", "Esefid", "Bloco 4", "Litoral"]
        let shortRuNames = ["Centro", "Saúde", "Vale", "Agro", "Esefid", "Bloco 4", "Litoral"]
        
        Alamofire.request("https://www1.ufrgs.br/WS/siteUFRGS/getCardapioRU/?v=1").responseJSON { response in
            
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
            
            if let value = response.result.value {
                let json = JSON(value as Any)
                
                if json != [] && json != JSON.null {
                    
                    print("JSON ", json)
                    
                    for (index, _) in json {
                        
                        let ru = RUModel()
                        var menu = String(describing: json[index]["cardapio"]).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                        
                        print(menu)
                        
                        if menu == "" {
                            menu = self.unavailableMenu
                        }
                        
                        ru.menu = self.capitalizeSentences(text: menu)
                        
                        let indexParts = index.split(separator: "u").map(String.init)
                        
                        if let i = Int(indexParts[1]) {
                            ru.shortName = shortRuNames[i - 1]
                            ru.name = ruNames[i - 1]
                            ru.number = i
                        }
                        
                        RUs.append(ru)
                    }
                    
                    let sortedRUs: [RUModel] = RUs.sorted(by: { $0.number < $1.number })
                    completionHandler(sortedRUs, nil)
                }
                    
                else {
                    completionHandler(nil, nil)
                    //                for i in 0..<ruNames.count {
                    //                    let ru = RUModel()
                    //
                    //                    ru.number = i + 1
                    //                    ru.shortName = shortRuNames[i]
                    //                    ru.name = ruNames[i]
                    //                    ru.menu = self.unavailableMenu
                    //
                    //                    RUs.append(ru)
                }
            } else {
                completionHandler(nil, nil)
            }
        }
    }
    
    private func capitalizeSentences(text: String)-> String {
        var lines = text.components(separatedBy: "\n")
        
        for i in 0..<lines.count {
            lines[i] = lines[i].prefix(1).uppercased() + lines[i].lowercased().dropFirst()
        }
        
        return lines.joined(separator: "\n")
    }
    
}
