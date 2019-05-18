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
    
    var email: String = ""
    
    //Mark: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        submitButton.isEnabled = false
        verificationCode.delegate = self
        verificationCode.clear()
        submitButton.layer.cornerRadius = 25
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        if verificationCode.hasValidCode() {
            
            verifyCode(verificationCode.getVerificationCode())
            
            let alert = UIAlertController(title: "Success", message: "Code is \(verificationCode.getVerificationCode())", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default) { (_) in
                self.performSegue(withIdentifier: "ShowMain", sender: nil)
            }
            alert.addAction(okAction)
            //present(alert, animated: true, completion: nil)
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
                        
                        print(result["password"].string?.isEmpty as Any)
                        if !result["password"].string!.isEmpty {
                            defaults.set(result["user_name"].string, forKey: "username")
                            defaults.set(result["password"].string, forKey: "password")
                        } else {
                            defaults.set(result["remember_token"].string, forKey: "token")
                        }
                        
                        
                        
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let initialViewController = storyboard.instantiateViewController(withIdentifier: "Tabbar")
                        self.removeFromParent()
                        self.present(initialViewController, animated: true, completion: nil)
                        
                    case .failure(let error):
                        print(error)
                        
                    }
                } else {
                    print(response)
                }
                
                
        }
        
    }


}

extension EmailVerifyVC: KWVerificationCodeViewDelegate {
    
    func didChangeVerificationCode() {
        submitButton.isEnabled = verificationCode.hasValidCode()
    }
}
