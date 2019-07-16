//
//  fillProfileVC.swift
//  MrPlanner
//
//  Created by Mohammad Gharari on 6/1/19.
//  Copyright © 2019 Mohammad Gharari. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON



class fillProfileVC: UIViewController {

    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    
    var email:String = ""
    var UserID:Int = 0
    var firstLogin:Bool = false
    
    override func viewDidAppear(_ animated: Bool) {
        submitBtn.loadingIndicator(false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        submitBtn.layer.cornerRadius = 25
        usernameTF.becomeFirstResponder()
        
        // Do any additional setup after loading the view.
    }
    
    
    

    @IBAction func submitBtnTapped(_ sender: UIButton) {
        
        
        
        
        
        //Check Textfields
        if usernameTF.text!.isEmpty {
            // Alert
            alertUser("Please Fill all Fields")
        } else {
            submitBtn.loadingIndicator(true)
            submitToServer()
        }
    }
    
    
    
    @IBAction func returnBackBtn(_ sender: UIButton) {
        performSegueToReturnBack()
    }
    private func submitToServer() {
        
        let defaults = UserDefaults.standard
        
        let user = defaults.string(forKey: "username") ?? ""
        let password = defaults.string(forKey: "password") ?? ""
        
        let credentialData = "\(user):\(password)".data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
        
        let base64Credential = credentialData.base64EncodedString()
        let url = URL(string: "http://mrplanner.org/api/user/\(UserID)/update")
        
        let header: HTTPHeaders = ["X-API-TOKEN" : Bundle.main.localizedString(forKey: "X-API-TOKEN", value: nil, table: "Secrets"),
                                   "Content-Type" : "application/json",
                                   "Authorization":"Basic \(base64Credential)"]
        
        let parameters: Parameters = ["user_name": usernameTF.text ?? ""]
        
        Alamofire.request(url!, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: header).validate()
            .responseJSON { response in
                
                let statusCode = response.response?.statusCode
                print(statusCode!)
                
                    switch response.result {
                    case .success(let value):
                        let result = JSON(value)
                        if let error = result["message"].string {
                            self.alertUser(error)
                            
                        } else {
                            defaults.set(self.usernameTF.text, forKey: "user_name")
                            if self.firstLogin {
                                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                let vc = storyBoard.instantiateViewController(withIdentifier: "Tabbar")
                                self.present(vc, animated: true, completion: nil)
                                
                            } else { self.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil) }
                        }
                        break
                        
                    case .failure(let error):
                        self.alertUser("Username Already Exist! Try Another One")
                        print(error.localizedDescription)
                        break
                    }
                
        }
        
        submitBtn.loadingIndicator(false)
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
