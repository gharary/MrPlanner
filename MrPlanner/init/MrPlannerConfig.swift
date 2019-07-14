//
//  MrPlannerConfig.swift
//  MrPlanner
//
//  Created by Mohammad Gharari on 6/1/19.
//  Copyright © 2019 Mohammad Gharari. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import SwiftyXMLParser
import SVProgressHUD
import RealmSwift

class MrPlannerService {
    
    static var sharedInstance = MrPlannerService()
    var isLoggedIn = LoginState.LoggedOut {
        didSet {
            NotificationCenter.default.post(name: .loginStateChanged, object: nil)
            
        }
    }
    
    
    let defaults = UserDefaults.standard
    let realm = try! Realm()
    let shelve = Shelve()
    
    var email: String?
    var password: String?
    let url = URL(string: "http://mrplanner.org/api/addBook/9")
    var userID: String?
    
    
    func loginToMrPlannerAccount(sender: UIViewController, completion: (() -> ())?) {
        
        
        if !defaults.bool(forKey: "Login") {
            
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "RegisterVC")
            sender.present(initialViewController, animated: true, completion: nil)
            
        } else {
            MrPlannerService.sharedInstance.isLoggedIn = .LoggedIn
            
            completion?()
            
        }
        
    }
    func addShelfBookToDB(sender: UIViewController, book: Books,title: String, cat: String, pageNr: RealmOptional<Int>, completion: @escaping (Bool, Int) -> ()) {
        
   
        guard isLoggedIn == .LoggedIn else {
            loginToMrPlannerAccount(sender: sender, completion: nil)
            return
        }
        let user = defaults.string(forKey: "username") ?? ""
        let password = defaults.string(forKey: "password") ?? ""
        
        let userID = defaults.string(forKey: "UserID") ?? ""
        let url = URL(string: "http://mrplanner.org/api/addBook/\(userID)")
        
        let credentialData = "\(user):\(password)".data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
        let base64Credential = credentialData.base64EncodedString()
        
        let header: HTTPHeaders = ["X-API-TOKEN" : Bundle.main.localizedString(forKey: "X-API-TOKEN", value: nil, table: "Secrets"),
                                   "Accept" : "application/json",
                                   "Authorization":"Basic \(base64Credential)"]
        
        
        let param: Parameters = ["name":title,
                                 "major":cat,
                                 "number_pages":pageNr.value!,
                                 "hard_grade":1]
        
        
        Alamofire.request(url!, method: .post, parameters: param, headers: header)
            .responseString { response in
                
                switch response.result {
                case .success:
                    let statusCode = response.response?.statusCode
                    if statusCode! >= 200 && statusCode! <= 300 {
                        let json = JSON(response.data!)
                        /*
                        DispatchQueue.global(qos: .background).async {
                            let realm = try! Realm()
                            let shelve = Shelve()
                            shelve.Book = book
                            shelve.GoogleID = book.id
                            shelve.InternalID = "\(json["id"].int ?? 0)"
                            
                            try! realm.write {
                                realm.add(shelve)
                            }
                        }
                        */
                        SVProgressHUD.showSuccess(withStatus: "Done!")
                        completion(true,json["id"].int ?? 0)
                    } else {
                        print(response.result.debugDescription)
                    }
                    
                case .failure(let error):
                    SVProgressHUD.showError(withStatus: error.localizedDescription)
                    print(error.localizedDescription)
                }
        }
    }
}

extension UIViewController {
    
    open func alertUser(sender: UIViewController,_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
        
    }
}
