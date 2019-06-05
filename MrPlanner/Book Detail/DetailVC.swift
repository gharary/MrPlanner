//
//  DetailVC.swift
//  MrPlanner
//
//  Created by Mohammad Gharari on 3/20/19.
//  Copyright © 2019 Mohammad Gharari. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class DetailVC: UIViewController {

    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var ISBNTitle: UILabel!
    @IBOutlet weak var publisherLbl: UILabel!
    @IBOutlet weak var PublishDateLbl: UILabel!
    @IBOutlet weak var langLbl: UILabel!
    
    var book = Books()
    
    var bookID: String = ""
    var baseURL = URL(string: "https://www.googleapis.com/books/v1/volumes/")

    override func viewDidAppear(_ animated: Bool) {
        SVProgressHUD.showProgress(0.1)
        guard book != nil else { return }
        
        updateView(book)
        
        //getDataFromGoogle()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
    }
    
    private func updateView(_ book:Books) {
        //print(baseURL!)
        //print(book)
        SVProgressHUD.showProgress(1)
        publisherLbl.text = "Publisher: \(book.publisher ?? "")"
        titleLbl.text = "Original Title: \(book.title ?? "")"
        ISBNTitle.text = "ISBN: \(book.ISBN13 ?? "")"
        PublishDateLbl.text = "PublishedDate: \(book.publishDate ?? "")"
        
        
        //descTV.text = book.desc
        //mainCategory.text = "Category: \(book.categories?[0] ?? "")"
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
