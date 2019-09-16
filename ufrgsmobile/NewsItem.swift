//
//  NewsItem.swift
//  ufrgsmobile
//
//  Created by Lucas Flores on 02/01/17.
//  Copyright © 2017 CPD UFRGS. All rights reserved.
//

import UIKit

class NewsItem: NSObject {
    
    var title : String = ""
    var chamada : String = ""
    var newsDescription : String = ""
    var imgThumb : String = ""
    var imgLarge : String = ""
    var autor : String = ""
    var data : String = ""
    var subPhoto : String = ""
    var photoW : Int = 0
    var photoH : Int = 0
    var hasImage = true
    var thumb: UIImage?
    
    init(title: String, newsDescription: String, imgThumb: String, imgLarge: String, autor: String, data: String, subPhoto: String, chamada: String) {
        self.autor = autor
        self.data = data
        self.imgThumb = imgThumb
        self.imgLarge = imgLarge
        self.newsDescription = newsDescription
        self.title = title
        self.subPhoto = subPhoto
        self.chamada = chamada
    }
    
}
