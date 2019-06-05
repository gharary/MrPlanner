//
//  IntroductionVC.swift
//  MrPlanner
//
//  Created by Mohammad Gharari on 3/20/19.
//  Copyright © 2019 Mohammad Gharari. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD
import PKHUD

class IntroductionVC: UIViewController {
    
    @IBOutlet weak var publisherLbl:UILabel!
    @IBOutlet weak var mainCategory:UILabel!
    @IBOutlet weak var descTV:UITextView!
    
    
    var book = Books()
    
    
    var baseURL = URL(string: "https://www.googleapis.com/books/v1/volumes/")
    var bookID:String = ""
    //var book:Books? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //print("Introduction View Loaded Nicely!")
        //print(bookID)
        SVProgressHUD.showProgress(0.1)
        guard book != nil else { return }
        
            //getDataFromGoogle()
        
        updateView(book)
        
    }
    

    private func updateView(_ book:Books) {
        //print(baseURL!)
        //print(book)
        SVProgressHUD.showProgress(1)
        
        let replace = book.desc?.replacingOccurrences(of: "<p>|</p>|<br>|</br>|<i>|</i>|<b>|</b>", with: "", options: .regularExpression)
        
        descTV.text = replace
        
        publisherLbl.isHidden = true
        mainCategory.isHidden = true
        
        let topAnchor = descTV.topAnchor.constraint(equalTo: view.topAnchor, constant: 20)
        
        view.addConstraint(topAnchor)
        SVProgressHUD.dismiss(withDelay: 0.5)
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
