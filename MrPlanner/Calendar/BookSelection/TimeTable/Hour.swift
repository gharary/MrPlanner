//
//  Hour.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on July 7, 2019

import Foundation 

//MARK: - Hour

struct Hour : Codable {
    
    let hour : String?
    
    enum CodingKeys: String, CodingKey {
        case hour = "hour"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        hour = try values.decodeIfPresent(String.self, forKey: .hour)
    }
    
}
