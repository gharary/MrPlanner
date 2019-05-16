//
//  Shelf.swift
//  MrPlanner
//
//  Created by Mohammad Gharari on 5/13/19.
//  Copyright © 2019 Mohammad Gharari. All rights reserved.
//

import Foundation

struct Shelf {
    var id: String
    var name: String
    var book_count: Int
    
    init(id:String?, name:String?, book_count:Int?) {
        self.id = id ?? ""
        self.name = name ?? ""
        self.book_count = book_count ?? 0
        
    }
}
