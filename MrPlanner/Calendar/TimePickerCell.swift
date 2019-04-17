//
//  TimePickerCell.swift
//  MrPlanner
//
//  Created by Mohammad Gharari on 4/17/19.
//  Copyright © 2019 Mohammad Gharari. All rights reserved.
//

import UIKit

class TimePickerCell: UICollectionViewCell {
    
    @IBOutlet weak var time:UILabel!
    
    func toggleSelected() {
        if (isSelected) {
            backgroundColor = .green
        } else {
            backgroundColor = .gray
        }
    }
    
    
    
}
