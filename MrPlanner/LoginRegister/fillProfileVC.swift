//
//  fillProfileVC.swift
//  MrPlanner
//
//  Created by Mohammad Gharari on 6/1/19.
//  Copyright © 2019 Mohammad Gharari. All rights reserved.
//

import UIKit
import Alamofire


class fillProfileVC: UIViewController {

    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var mobileTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var confirmPassTF: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    

    @IBAction func submitBtnTapped(_ sender: UIButton) {
        
        //Check Textfields
        if nameTF.text!.isEmpty || mobileTF.text!.isEmpty || passwordTF.text!.isEmpty {
            // Alert
            alertUser("Please Fill all Fields")
        } else if passwordTF.text != confirmPassTF.text {
            //Alert
            alertUser("Passwords doesn't match.")
        } else {
            
            submitToServer()
        }
    }
    
    
    private func submitToServer() {
        
        
    }
    
    // MARK: - Navigation
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    

    private func alertUser(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
