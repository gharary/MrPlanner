//
//  RegisterVC.swift
//  MrPlanner
//
//  Created by Mohammad Gharari on 5/9/19.
//  Copyright © 2019 Mohammad Gharari. All rights reserved.
//

import UIKit
import SwiftValidator
import Validator


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
    
    
    
    let validator = Validator()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailTF.delegate = self
        passTF.delegate = self
        emailFieldValidator()
        initBorder()
        passTF.isHidden = true
        self.view.bringSubviewToFront(loginBtn)
        // Do any additional setup after loading the view.
    }
    

    func emailFieldValidator() {
        
        var rules = ValidationRuleSet<String>()
        let emailPattern = EmailValidationPattern.simple
        let emailRule = ValidationRulePattern(pattern: emailPattern, error: ValidationError(message: ":("))
        rules.add(rule: emailRule)
        emailTF.validationRules = rules
        emailTF.validationHandler = { result in
            switch result {
            case .valid:
                self.emailTF.layer.borderColor = UIColor.clear.cgColor
                self.signupBtn.isEnabled = true
                //print("Valid!")
            case .invalid(let failureErrors):
                self.emailTF.layer.borderColor = UIColor.red.cgColor
                self.emailTF.layer.borderWidth = 1.0
                self.signupBtn.isEnabled = false
                //print("Invalid!", failureErrors)
            
            }
        }
        emailTF.validateOnInputChange(enabled: true)
            
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
            
           
            emailTF.validateOnInputChange(enabled: false)
            emailTF.layer.borderColor = UIColor.clear.cgColor
        } else {
            login = false
            loginBtn.setTitle("Log In", for: .normal)
            self.view.layoutIfNeeded()
            self.passTF.isHidden = true
            emailTF.validateOnInputChange(enabled: true)
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
    
    @IBAction func singupBtnTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "Error", message: "Fill All Fields!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        switch passTF.isHidden {
        case false:
            if !emailTF.text!.isEmpty  && !passTF.text!.isEmpty {
                performSegue(withIdentifier: "showVerifyVC", sender: self)
            } else {
                present(alert, animated: true, completion: nil)
            }
        case true:
            if !emailTF.text!.isEmpty {
                performSegue(withIdentifier: "showVerifyVC", sender: self)
            } else {
                present(alert, animated: true, completion: nil)

            }
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

