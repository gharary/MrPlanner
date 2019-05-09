//
//  RegisterVC.swift
//  MrPlanner
//
//  Created by Mohammad Gharari on 5/9/19.
//  Copyright © 2019 Mohammad Gharari. All rights reserved.
//

import UIKit

class RegisterVC: UIViewController {

    @IBOutlet weak var googleLoginBtn:UIButton!
    @IBOutlet weak var goodreadsLoginBtn: UIButton!
    @IBOutlet weak var loginBtn:UIButton!
    @IBOutlet weak var signupBtn:UIButton!
    @IBOutlet weak var emailTF:UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initBorder()
        // Do any additional setup after loading the view.
    }
    

    func initBorder() {
        
        googleLoginBtn.layer.cornerRadius = 20
        goodreadsLoginBtn.layer.cornerRadius = 20
        signupBtn.layer.cornerRadius = 20
        
        
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
