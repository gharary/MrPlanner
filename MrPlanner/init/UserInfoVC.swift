//
//  UserInfoVC.swift
//  MrPlanner
//
//  Created by Mohammad Gharari on 2/18/19.
//  Copyright © 2019 Mohammad Gharari. All rights reserved.
//

import Alamofire
import UIKit
import SWXMLHash

class UserInfoVC: UIViewController {

    let baseUrl = URL(string: "https://www.goodreads.com/user/show.xml")

    
    @IBOutlet weak var useridTF: UITextField!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func useridTextField(_ sender: UITextField) {
        
    }
    @IBAction func getData(_ sender: UIButton) {
        let parameters: Parameters = ["key":"FQ0SFjCwuDb7SRo6bOkPQ","username":useridTF.text!]
        
        Alamofire.request(baseUrl!, method: .get, parameters: parameters)
            .responseString { response in
                var statusCode = response.response?.statusCode
                
                switch response.result {
                case .success:
                    let xml = SWXMLHash.lazy(response.result.value!)
                    
                 
                    
                    self.nameLabel.text = xml["GoodreadsResponse"]["user"]["name"].element?.text
                    self.locationLabel.text = xml["GoodreadsResponse"]["user"]["location"].element?.text
                    //print(xml["GoodreadsResponse"]["user"]["location"].element?.text as Any)
                case .failure(let error):
                    statusCode = error._code // statusCode private
                    print("status code is: \(String(describing: statusCode))")
                    print(error)
                }
        }
                
    }
        
}



