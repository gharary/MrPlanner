//
//  Lesson.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on July 7, 2019

import Foundation

struct Lesson : Codable {
    
    let id : String?
    let chapters : [Chapter]?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case chapters = "chapters"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        chapters = try values.decodeIfPresent([Chapter].self, forKey: .chapters)
    }
    
}
