//
//  Book.swift
//  MrPlanner
//
//  Created by Mohammad Gharari on 5/13/19.
//  Copyright © 2019 Mohammad Gharari. All rights reserved.
//

import Foundation
import SwiftyXMLParser

/*
 
 @objcMembers class Books:Object {
 dynamic var id:String? // either Google ID or GoodreadsID
 dynamic var title:String?
 dynamic var authors = List<String>() //[Authors]? //Google Authors
 dynamic var image: String?
 dynamic var desc: String?
 dynamic var publisher: String?
 dynamic var publishDate: String?
 dynamic var ISBN13: String?
 dynamic var ISBN10: String?
 dynamic var pageCount = RealmOptional<Int>()
 dynamic var categories = List<String>()
 dynamic var avgRating = RealmOptional<Double>()
 dynamic var ratingCount = RealmOptional<Int>()
 
 
 
 }
 */

struct Book {
    var id: String
    var title:String
    var author: String
    var imageUrl: String
    var desc: String
    var numPages: String
    var publisher:String
    var PublishDate:String
    var avgRating:Double
    var ratingCount:Int
    var ISBN13: String?
    var ISBN10: String?
    
    
    init(xml: XML.Accessor) {
        id = xml["id"].text ?? ""
        title = xml["title"].text ?? ""
        //author = Author(xml: xml["author"])
        author = xml["authors","author", "name"].text ?? ""
        imageUrl = xml["image_url"].text ?? ""
        desc = xml["description"].text ?? ""
        numPages = xml["num_pages"].text ?? ""
        publisher = xml["publisher"].text ?? ""
        PublishDate = xml["publication_year"].text ?? ""
        avgRating = xml["average_rating"].double ?? 0
        ratingCount = xml["ratings_count"].int ?? 0
        ISBN10 = xml["isbn"].text ?? ""
        ISBN13 = xml["isbn13"].text ?? ""
        
    }
}


