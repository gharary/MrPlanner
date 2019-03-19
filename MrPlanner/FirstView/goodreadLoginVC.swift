//
//  goodreadLoginVC.swift
//  MrPlanner
//
//  Created by Mohammad Gharari on 3/16/19.
//  Copyright © 2019 Mohammad Gharari. All rights reserved.
//

import UIKit
import Alamofire
import SWXMLHash

class goodreadLoginVC: UIViewController {

    /*
    var popupViewController: SBCardPopupViewController?
    
    var allowsTapToDismissPopupCard: Bool = true
    
    var allowsSwipeToDismissPopupCard: Bool = true
    */
    //let create initiate for popup
    static func create() -> UIViewController {
        /*
        let storyBoard = UIStoryboard.init(name: "FirstView", bundle: nil).instantiateViewController(withIdentifier: "goodreadLoginVC") as! goodreadLoginVC
        */
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "FirstView", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "goodreadLoginVC")
        return vc
        
    }
    
    
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var firstNameLbl: UILabel!
    @IBOutlet weak var lastNameLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var notFoundLbl: UILabel!
    
    
     let baseUrl = URL(string: "https://www.goodreads.com/user/show.xml")
    
    
    override func viewDidAppear(_ animated: Bool) {
        notFoundLbl.alpha = 0
        initBorders()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        initBorders()
        // Do any additional setup after loading the view.
    }
    
    func initBorders() {
        
        loginButton.layer.cornerRadius = 5
        loginButton.layer.borderColor = loginButton.backgroundColor?.cgColor
        loginButton.layer.borderWidth = 1
        
        firstNameLbl.layer.cornerRadius = 5
        firstNameLbl.layer.borderColor = firstNameLbl.backgroundColor?.cgColor
        firstNameLbl.layer.borderWidth = 1
        
        lastNameLbl.layer.cornerRadius = 5
        lastNameLbl.layer.borderColor = lastNameLbl.backgroundColor?.cgColor
        lastNameLbl.layer.borderWidth = 1
        
        locationLbl.layer.cornerRadius = 5
        locationLbl.layer.borderColor = locationLbl.backgroundColor?.cgColor
        locationLbl.layer.borderWidth = 1
        
    }
    
    
    
    @IBAction func loginBtn(_ sender: UIButton) {
        notFoundLbl.alpha = 0
        getDataGoodreads()
        
    }

    /*
    @IBAction func saveBtnTapped(_ sender: UIButton) {
        self.popupViewController?.close()
    }
    */
    
    @IBAction func usernameTFEdit(_ sender: UITextField) {
        notFoundLbl.alpha = 0
    }
    
    
    
    
    func getDataGoodreads(){
        let parameters: Parameters = ["key":"FQ0SFjCwuDb7SRo6bOkPQ","username":usernameTF.text!]
        
        Alamofire.request(baseUrl!, method: .get, parameters: parameters)
            .responseString { response in
                var statusCode = response.response?.statusCode
                if statusCode == 200 {
                switch response.result {
                case .success:
                    let xml = SWXMLHash.lazy(response.result.value!)
                    
                    
                    
                    self.firstNameLbl.text = xml["GoodreadsResponse"]["user"]["name"].element?.text
                    self.locationLbl.text = xml["GoodreadsResponse"]["user"]["location"].element?.text
                //print(xml["GoodreadsResponse"]["user"]["location"].element?.text as Any)
                case .failure(let error):
                    statusCode = error._code // statusCode private
                    print("status code is: \(String(describing: statusCode))")
                    print(error)
                    self.notFoundLbl.alpha = 1.0
                }
                
        } else if statusCode == 404 {
            self.notFoundLbl.alpha = 1.0
                }
        }
    }

    

}
