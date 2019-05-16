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
    @IBOutlet weak var leadersTitle: UILabel!
    @IBOutlet weak var descriptionTitle: UILabel!
    @IBOutlet weak var passTF:UITextField!
    @IBOutlet weak var stackView: UIStackView!
    
    
    @IBOutlet var GoogleBtnTopAnchor: NSLayoutConstraint!
    @IBOutlet var stackViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailTF.delegate = self
        passTF.delegate = self
        
        initBorder()
        passTF.isHidden = true
        self.view.bringSubviewToFront(loginBtn)
        // Do any additional setup after loading the view.
    }
    

    func initBorder() {
        
        googleLoginBtn.layer.cornerRadius = 20
        goodreadsLoginBtn.layer.cornerRadius = 20
        signupBtn.layer.cornerRadius = 20
        loginBtn.layer.cornerRadius = 5
        signupBtn.topAnchor.constraint(equalTo: emailTF.bottomAnchor, constant: 16).isActive = true
    }
    
    var login:Bool = false
    @IBAction func loginClicked(_ sender: UIButton) {
        
        
        
        if !login {
            login = true
            
            loginBtn.setTitle("Sign Up", for: .normal)
            self.view.layoutIfNeeded()
            self.passTF.isHidden = false
            UIView.animate(withDuration: 0.35, animations: {
                self.stackView.layoutIfNeeded()
            })
            
            UIView.animate(withDuration: 1.0, animations: {
                self.leadersTitle.text = "Welcome Back!"
                self.descriptionTitle.isHidden = true
                self.GoogleBtnTopAnchor.constant -= self.descriptionTitle.frame.height
                self.stackViewHeight.constant += 48
                self.stackView.layoutIfNeeded()
                self.view.layoutIfNeeded()
                
            })
            
            
            
        } else {
            login = false
            loginBtn.setTitle("Log In", for: .normal)
            self.view.layoutIfNeeded()
            self.passTF.isHidden = true
            
            
            UIView.animate(withDuration: 0.35, animations: {
                self.stackView.layoutIfNeeded()
            })
            
            UIView.animate(withDuration: 1.0, animations: {
                
            
                self.leadersTitle.text = "Leaders are Readers!"
                self.GoogleBtnTopAnchor.constant += self.descriptionTitle.frame.height
                self.descriptionTitle.isHidden = false
                self.stackViewHeight.constant -= 48
                self.view.layoutIfNeeded()
            })
            
        }
    }
    

}
extension RegisterVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == emailTF && passTF.isHidden == false
        {
            passTF.becomeFirstResponder()
            
        }
        return true
    }
}
