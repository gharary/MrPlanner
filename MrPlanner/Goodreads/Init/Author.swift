//
//  Author.swift
//  MrPlanner
//
//  Created by Mohammad Gharari on 5/13/19.
//  Copyright © 2019 Mohammad Gharari. All rights reserved.
//

import Foundation
import SwiftyXMLParser

struct Author {
    
    var id: String
    var name: String
    
    init(xml: XML.Accessor) {
        id = xml["id"].text ?? ""
        name = xml["name"].text ?? "" 
    }
}
