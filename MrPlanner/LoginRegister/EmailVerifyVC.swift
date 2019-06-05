//
//  EmailVerifyVC.swift
//  MrPlanner
//
//  Created by Mohammad Gharari on 5/17/19.
//  Copyright © 2019 Mohammad Gharari. All rights reserved.
//

import UIKit
import KWVerificationCodeView
import Alamofire
import SwiftyJSON


class EmailVerifyVC: UIViewController {

    
    //Mark: - IBOutlets
    @IBOutlet var verificationCode: KWVerificationCodeView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var verificationLbl: UILabel!
    
    var label: String = "Check Your Email for a Verification Code"
    var email: String = ""
    
    //Mark: - Lifecycle
    override func viewDidAppear(_ animated: Bool) {
        submitButton.loadingIndicator(false)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        verificationLbl.text = "Check Your Email '\(email)' or Spam for a Verification Code"
        
        submitButton.isEnabled = false
        verificationCode.delegate = self
        verificationCode.clear()
        submitButton.layer.cornerRadius = 25
        
        // Do any additional setup after loading the view.
    }
    @IBAction func returnBtnTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        if verificationCode.hasValidCode() {
            submitButton.loadingIndicator(true)
            verifyCode(verificationCode.getVerificationCode())
            
            let alert = UIAlertController(title: "Success", message: "Code is \(verificationCode.getVerificationCode())", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default) { (_) in
                self.performSegue(withIdentifier: "ShowMain", sender: nil)
            }
            alert.addAction(okAction)
        }
    }
    
    private func verifyCode(_ code:String) {
        let defaults = UserDefaults.standard
        
        let url = URL(string: "http://www.mrplanner.org/api/logIn")
        let parameters: Parameters = [
            "email": email,
            "code": code
        ]
        let headers: HTTPHeaders = [
            "X-API-TOKEN" : Bundle.main.localizedString(forKey: "X-API-TOKEN", value: nil, table: "Secrets"),
            "Accept" : "application/json"
        ]
        
        Alamofire.request(url!, method: .post, parameters: parameters, headers: headers)
            .responseJSON  { response in
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    switch response.result {
                    case .success:
                        
                        let result = JSON(response.result.value!)
                    
                        defaults.set(self.email, forKey: "username")
                        defaults.set(result["remember_token"].string, forKey: "password")
                        defaults.set(result["id"].int, forKey: "UserID")
                        defaults.set(true, forKey: "Login")
                        
                        //MrPlannerAuthStorageService.saveAuthToken(self.email)
                    //MrPlannerAuthStorageService.saveTokenSecret(result["remember_token"].string!)
                        
                        MrPlannerService.sharedInstance.isLoggedIn = .LoggedIn
                    self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
                        
                        
                    case .failure(let error):
                        print(error.localizedDescription)
                        
                    }
                } else {
                    
                    let alert = UIAlertController(title: "Error", message: "Wrong Code! Try Again", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: { (_) in
                        self.verificationCode.clear()
                        self.submitButton.loadingIndicator(false)
                    }))
                    
                    self.present(alert, animated: true, completion: nil)
                    print(response.error!.localizedDescription)
                }
                
                
        }
        
    }


}

extension EmailVerifyVC: KWVerificationCodeViewDelegate {
    
    func didChangeVerificationCode() {
        submitButton.isEnabled = verificationCode.hasValidCode()
    }
}
