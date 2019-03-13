//
//  TabBar.swift
//  MrPlanner
//
//  Created by Mohammad Gharari on 3/2/19.
//  Copyright © 2019 Mohammad Gharari. All rights reserved.
//

import Foundation

import UIKit

class CustomTabBar : UITabBar {
    @IBInspectable var height: CGFloat = 0.0
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        if height > 0.0 {
            sizeThatFits.height = height
        }
        return sizeThatFits
    }
}
