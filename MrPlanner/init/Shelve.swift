//
//  Shelve.swift
//  MrPlanner
//
//  Created by Mohammad Gharari on 5/19/19.
//  Copyright © 2019 Mohammad Gharari. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers class Shelve:Object {
    
    dynamic var Book: Books?
    dynamic var InternalID: String?
    dynamic var GoogleID:String?
    dynamic var GoodreadsID: String?
    
    
    convenience init(Book:Books, InternalID:String, GoogleID:String, GoodreadsID:String) {
        self.init()
        
        self.Book = Book
        self.InternalID = InternalID
        self.GoogleID = GoogleID
        self.GoodreadsID = GoodreadsID
        
    }
    
    
}
