//
//  Book.swift
//  MrPlanner
//
//  Created by Mohammad Gharari on 5/13/19.
//  Copyright © 2019 Mohammad Gharari. All rights reserved.
//

import Foundation
import SwiftyXMLParser

struct Book {
    var id: String
    var title:String
    var author: Author
    var imageUrl: String
    
    init(xml: XML.Accessor) {
        id = xml["id"].text ?? ""
        title = xml["title"].text ?? ""
        author = Author(xml: xml["author"])
        imageUrl = xml["image_url"].text ?? ""
    }
}


