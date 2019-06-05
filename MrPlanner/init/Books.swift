//
//  GoodReadsJSON.swift
//  MrPlanner
//
//  Created by Mohammad Gharari on 2/17/19.
//  Copyright © 2019 Mohammad Gharari. All rights reserved.
//

import Foundation
import RealmSwift



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
    dynamic var pageCount: Int?
    dynamic var categories = List<String>()
    dynamic var avgRating: Double?
    dynamic var ratingCount: Int?
    
    
    
}

