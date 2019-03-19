//
//  TabBar.swift
//  MrPlanner
//
//  Created by Mohammad Gharari on 3/2/19.
//  Copyright © 2019 Mohammad Gharari. All rights reserved.
//

import Foundation

import UIKit


class CustomTabbarController: UITabBarController {
    var indexPath: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectedIndex = indexPath
        
        //Shadow for tab bar 1
        
        self.tabBar.layer.shadowColor = UIColor.black.cgColor
        self.tabBar.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.tabBar.layer.shadowRadius = 5
        self.tabBar.layer.shadowOpacity = 12
        self.tabBar.layer.masksToBounds = false
        
        
        //Shadow for tab bar 2
        /*
        self.tabBar.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.tabBar.layer.shadowRadius = 2
        self.tabBar.layer.shadowColor = UIColor.black.cgColor
        self.tabBar.layer.shadowOpacity = 0.3
        */
        //self.tabBar.isTranslucent = false
        
        //self.tabBar.backgroundColor = UIColor.white
        //self.tabBar.shadowImage = UIColor.gray
        //self.tabBar.backgroundColor = UIColor(hexString: "D8DCE2")
    }
}
