//
//  LaunchController.swift
//  MrPlanner
//
//  Created by Mohammad Gharari on 5/6/19.
//  Copyright © 2019 Mohammad Gharari. All rights reserved.
//


//https://medium.freecodecamp.org/how-to-handle-internet-connection-reachability-in-swift-34482301ea57

import UIKit

class LaunchViewController: UIViewController {
    let network: NetworkManager = NetworkManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkManager.isUnreachable { _ in
            self.showOfflinePage()
        }
    }
    
    private func showOfflinePage() -> Void {
        DispatchQueue.main.async {
            self.performSegue(
                withIdentifier: "NetworkUnavailable",
                sender: self
            )
        }
    }
}
