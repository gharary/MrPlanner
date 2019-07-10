//
//  Chapter.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on July 7, 2019

import Foundation

struct Chapter : Codable {
    
    let pages : String?
    
    enum CodingKeys: String, CodingKey {
        case pages = "pages"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        pages = try values.decodeIfPresent(String.self, forKey: .pages)
    }
    
}
