//
//  GoodreadsVC.swift
//  MrPlanner
//
//  Created by Mohammad Gharari on 5/13/19.
//  Copyright © 2019 Mohammad Gharari. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class GoodreadsVC: UIViewController {

    
    var currentBook:Book?
    var openModal: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        GoodreadsService.sharedInstance.isLoggedIn = AuthStorageService.readAuthToken().isEmpty ? .LoggedOut : .LoggedIn
        
        if GoodreadsService.sharedInstance.isLoggedIn == .LoggedOut {
            GoodreadsService.sharedInstance.loginToGoodreadsAccount(sender: self) {
                
            }
            return
        }
        
    }
    
    
    func addBookToShelf() {
        
        
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
