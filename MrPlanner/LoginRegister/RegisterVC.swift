//
//  RegisterVC.swift
//  MrPlanner
//
//  Created by Mohammad Gharari on 5/9/19.
//  Copyright © 2019 Mohammad Gharari. All rights reserved.
//

import UIKit
import Validator
import Alamofire


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
    
    
    
    var firstLogin:Bool = false
    
    override func viewDidAppear(_ animated: Bool) {
        signupBtn.loadingIndicator(false)
        //goodreadsLoginBtn.loadingIndicator(false)
        
    }
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
        
        let emailRule = ValidationRulePattern(pattern: EmailValidationPattern.standard, error: EmailValidationError(""))
        
        
        
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
                print("Invalid!", failureErrors)
            
            }
        }
        emailTF.validateOnInputChange(enabled: true)
            
    }
    func initBorder() {
        
        //googleLoginBtn.layer.cornerRadius = 20
        //goodreadsLoginBtn.layer.cornerRadius = 20
        signupBtn.layer.cornerRadius = 20
        loginBtn.layer.cornerRadius = 5
        signupBtn.topAnchor.constraint(equalTo: emailTF.bottomAnchor, constant: 16).isActive = true
        
    }
    
    var login:Bool = false
    
    
    @IBAction func loginClicked(_ sender: UIButton) {
        
        
        
        if !login {
            login = true
            
            loginBtn.setTitle("Sign Up", for: .normal)
            signupBtn.setTitle("Login", for: .normal)
            self.view.layoutIfNeeded()
            self.passTF.isHidden = false
            UIView.animate(withDuration: 0.35, animations: {
                self.stackView.layoutIfNeeded()
            })
            
            UIView.animate(withDuration: 1.0, animations: {
                self.leadersTitle.text = "Welcome Back!"
                self.descriptionTitle.isHidden = true
                self.GoogleBtnTopAnchor.constant -= self.descriptionTitle.frame.height
                self.stackViewHeight.constant += 53
                self.stackView.layoutIfNeeded()
                self.view.layoutIfNeeded()
                
            })
            
           
            emailTF.validateOnInputChange(enabled: false)
            emailTF.layer.borderColor = UIColor.clear.cgColor
        } else {
            login = false
            loginBtn.setTitle("Log In", for: .normal)
            signupBtn.setTitle("Sign Up", for: .normal)
            
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
                self.stackViewHeight.constant -= 53
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
                signupBtn.loadingIndicator(true)
                registerEmailServer(emailTF.text!)
                //performSegue(withIdentifier: "showVerifyVC", sender: self)
            } else {
                present(alert, animated: true, completion: nil)
            }
        case true:
            if !emailTF.text!.isEmpty {
                signupBtn.loadingIndicator(true)
                registerEmailServer(emailTF.text!)
                //performSegue(withIdentifier: "showVerifyVC", sender: self)
            } else {
                present(alert, animated: true, completion: nil)

            }
        }
        
    }
    
    @IBAction func goodreadsBtnTapped(_ sender: UIButton) {
        goodreadsLoginBtn.loadingIndicator(true)
        GoodreadsService.sharedInstance.isLoggedIn = AuthStorageService.readAuthToken().isEmpty ? .LoggedOut : .LoggedIn
        if GoodreadsService.sharedInstance.isLoggedIn == .LoggedOut {
            GoodreadsService.sharedInstance.loginToGoodreadsAccount(sender: self) {
                
            }
            //goodreadsLoginBtn.loadingIndicator(false)
            return
        } else {
            let alert = UIAlertController(title: "Loggin", message: "You've already logged In", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            goodreadsLoginBtn.loadingIndicator(false)
        }
    }
    
    private func loginToServer() {
        
        
        let url = URL(string: "")
        
        let parameters: Parameters = [:]
        
        let headers: HTTPHeaders = [
            "X-API-TOKEN" : Bundle.main.localizedString(forKey: "X-API-TOKEN", value: nil, table: "Secrets"),
            "Accept" : "application/json"
        ]
        
        Alamofire.request(url!, method: .post, parameters: parameters, headers: headers)
            .responseString { response in
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    
                } else {
                    print(response)
                }
                
                
        }
        
            .responseJSON { response in
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    
                }else {
                    print(response)
                }
        }
        
        
        
    }
    private func registerEmailServer(_ email:String) {
        let url = URL(string: "http://www.mrplanner.org/api/sendCode")
        
        let parameters: Parameters = ["email":email]
        let headers: HTTPHeaders = [
            "X-API-TOKEN" : Bundle.main.localizedString(forKey: "X-API-TOKEN", value: nil, table: "Secrets"),
            "Accept" : "application/json"
        ]
        
        Alamofire.request(url!, method: .post, parameters: parameters, headers: headers)
            .responseString  { response in
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    switch response.result {
                    case .success:
                        
                        self.performSegue(withIdentifier: "showVerifyVC", sender: self)
                        
                    case .failure(let error):
                        
                        self.signupBtn.loadingIndicator(false)
                        self.alertUser(sender: self, error.localizedDescription)
                        
                        
                    }
                } else {
                    self.signupBtn.loadingIndicator(false)
                    self.alertUser(sender: self, "Error in Connecting To Server!")
                    
                }
                
        
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showVerifyVC" {
            let vc = segue.destination as! EmailVerifyVC
            vc.email = emailTF.text!
            vc.firstLogin = firstLogin
            
            
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

extension UIButton {
    func loadingIndicator(_ show: Bool) {
        let tag = 808404
        if show {
            self.isEnabled = false
            self.alpha = 0.5
            let indicator = UIActivityIndicatorView()
            let buttonHeight = self.bounds.size.height
            let buttonWidth = self.bounds.size.width
            indicator.center = CGPoint(x: buttonWidth/2, y: buttonHeight/2)
            indicator.tag = tag
            self.addSubview(indicator)
            indicator.startAnimating()
        } else {
            self.isEnabled = true
            self.alpha = 1.0
            if let indicator = self.viewWithTag(tag) as? UIActivityIndicatorView {
                indicator.stopAnimating()
                indicator.removeFromSuperview()
            }
        }
    }
}


