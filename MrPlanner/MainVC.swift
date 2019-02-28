//
//  MainVC.swift
//  MrPlanner
//
//  Created by Mohammad Gharari on 2/26/19.
//  Copyright © 2019 Mohammad Gharari. All rights reserved.
//

import UIKit

class MainVC: UIViewController {

    
    @IBOutlet weak var googleBTN: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        googleBTN.layer.cornerRadius = 15
        googleBTN.layer.borderWidth = 2.5
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
