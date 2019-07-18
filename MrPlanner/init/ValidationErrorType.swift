//
//  ValidationErrorType.swift
//  MrPlanner
//
//  Created by Mohammad Gharari on 5/18/19.
//  Copyright © 2019 Mohammad Gharari. All rights reserved.
//

import Foundation
import Validator

struct EmailValidationError: ValidationError {
    
    public let message: String
    
    public init(_ message: String) {
        self.message = message
    }
}

