//
//  HtmlUtils.swift
//  ufrgsmobile
//
//  Created by Augusto on 26/06/2019.
//  Copyright © 2019 CPD UFRGS. All rights reserved.
//

import Foundation
import SwiftSoup

class HtmlUtils {
    
    static func completeRelativeLinks(htmlStr: String) -> String {
        
        let className = "internal-link"
        let urlPrefix = "https://ufrgs.br/ufrgs/noticias/"

        do {
            let document: Document = try SwiftSoup.parse(htmlStr)
            let links = try document.getElementsByClass(className)

            for l in links {
                let fullUrl = try (urlPrefix + l.attr("href"))
                try l.attr("href", fullUrl)
            }

            return try document.html()

        } catch {
            return htmlStr
        }
        
    }
    
}
