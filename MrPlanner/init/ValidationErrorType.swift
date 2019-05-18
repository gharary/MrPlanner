//
//  ValidationErrorType.swift
//  MrPlanner
//
//  Created by Mohammad Gharari on 5/18/19.
//  Copyright © 2019 Mohammad Gharari. All rights reserved.
//

import Foundation

struct ValidationError: Error {
    
    public let message: String
    
    public init(message m: String) {
        message = m
    }
}
