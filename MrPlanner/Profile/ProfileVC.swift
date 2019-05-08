//
//  ProfileVC.swift
//  MrPlanner
//
//  Created by Mohammad Gharari on 3/30/19.
//  Copyright © 2019 Mohammad Gharari. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {

    
    @IBOutlet weak var upperCV: UIView!
    @IBOutlet weak var middleCV: UIView!
    @IBOutlet weak var lowerCV: UIView!
    @IBOutlet weak var shapeStackView: UIStackView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Profile"
        //setupUpper()
        // Do any additional setup after loading the view.
    }
    

    private func setupUpper() {
        
        shapeStackView.clipsToBounds = true
        shapeStackView.layer.cornerRadius = 10
        shapeStackView.backgroundColor = UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 0.50)
        shapeStackView.alpha = 1
        self.view.layoutIfNeeded()
        
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
