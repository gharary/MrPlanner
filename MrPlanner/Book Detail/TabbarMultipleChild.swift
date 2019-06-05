//
//  TabbarMultipleChild.swift
//  MrPlanner
//
//  Created by Mohammad Gharari on 3/20/19.
//  Copyright © 2019 Mohammad Gharari. All rights reserved.
//

import UIKit

class TabbarMultipleChild: UITabBarController {
    
    var indexPath: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.selectedIndex = indexPath
        
        self.tabBarController?.tabBar.isHidden = true
        
    }
}
