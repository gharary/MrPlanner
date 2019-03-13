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
    @IBOutlet weak var subview: UIView!
    @IBOutlet weak var testButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        googleBTN.layer.cornerRadius = 15
        googleBTN.layer.borderWidth = 2.5
        avoCodeTest()
        testCode()
    }
    

    func testCode(){
        
        testButton.clipsToBounds = true
        testButton.setTitle("Click Me Test!", for: .normal)
        
        let shadow0 = UIView(frame: CGRect(x: 0, y: 0, width: 205, height: 60))
        shadow0.clipsToBounds = false
        shadow0.layer.shadowColor = UIColor(red: 0.00, green: 0.74, blue: 0.53, alpha: 0.20).cgColor
        shadow0.layer.shadowOpacity = 0.2
        shadow0.layer.shadowOffset = CGSize(width: 0, height: 15)
        testButton?.addSubview(shadow0)
        testButton?.layer.cornerRadius = 30
        let gradientLayer0 = CAGradientLayer()
        gradientLayer0.frame = (testButton?.bounds)!
        gradientLayer0.colors = [UIColor(red: 0.00, green: 0.66, blue: 0.51, alpha: 1).cgColor, UIColor(red: 0.00, green: 0.74, blue: 0.53, alpha: 1).cgColor]
        gradientLayer0.locations = [1, 0]
        testButton?.layer.addSublayer(gradientLayer0)
        testButton?.alpha = 1
        
    }
    func avoCodeTest() {
        
        let style = UIButton(frame: CGRect(x: 0, y: 0, width: 205, height: 60))
        style.clipsToBounds = true
        style.setTitle("Click Me!", for: .normal)
        //style.addTarget(<#T##target: Any?##Any?#>, action: <#T##Selector#>, for: <#T##UIControl.Event#>)
        let shadow0 = UIView(frame: CGRect(x: 0, y: 0, width: 205, height: 60))
        shadow0.clipsToBounds = false
        shadow0.layer.shadowColor = UIColor(red: 0.00, green: 0.74, blue: 0.53, alpha: 0.20).cgColor
        shadow0.layer.shadowOpacity = 0.2
        shadow0.layer.shadowOffset = CGSize(width: 0, height: 15)
        style.addSubview(shadow0)
        style.layer.cornerRadius = 30
        let gradientLayer0 = CAGradientLayer()
        gradientLayer0.frame = style.bounds
        gradientLayer0.colors = [UIColor(red: 0.00, green: 0.66, blue: 0.51, alpha: 1).cgColor, UIColor(red: 0.00, green: 0.74, blue: 0.53, alpha: 1).cgColor]
        gradientLayer0.locations = [1, 0]
        style.layer.addSublayer(gradientLayer0)
        style.alpha = 1
        
        self.subview.addSubview(style)
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
