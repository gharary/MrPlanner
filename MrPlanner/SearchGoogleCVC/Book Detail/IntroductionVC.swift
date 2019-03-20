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


class IntroductionVC: UIViewController {
    
    @IBOutlet weak var publisherLbl:UILabel!
    @IBOutlet weak var mainCategory:UILabel!
    @IBOutlet weak var descTV:UITextView!
    
    
    
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
        
        guard bookID != "" else { return }
        
            getDataFromGoogle()
    }
    

    private func updateView(_ book:Books) {
        //print(baseURL!)
        print(book)
        
        publisherLbl.text = "Publisher: \(book.publisher ?? "")"
        descTV.text = book.desc
        mainCategory.text = "Category: \(book.categories?[0] ?? "")"
    }
    
    private func getDataFromGoogle() {
        baseURL = URL(string: "https://www.googleapis.com/books/v1/volumes/\(bookID)")
        //let parameters: Parameters = ["\(bookID)"]//,"key":"AIzaSyCIXIPXJQwCYE9hHdTghuH-jNRIm2tvx8Y"]
        
        Alamofire.request(baseURL!, method: .get)
            .responseJSON { response in
                var statusCode = response.response?.statusCode
                
                switch response.result {
                case .success:
                    
                    //print("Success!")
                    if response.data != nil  && statusCode == 200 {
                        
                        let json = try! JSON(data: response.data!)
                        var book:Books = Books()
                        book.author = json["volumeInfo"]["authors"][0].string
                        book.publisher = json["volumeInfo"]["publisher"].string
                        book.desc = json["volumeInfo"]["description"].string
                        book.image = json["volumeInfo"]["imageLinks"]["thumbnail"].string
                        book.title = json["volumeInfo"]["title"].string
                        book.pageCount = json["volumeInfo"]["pageCount"].string
                        book.categories = json["volumeInfo"]["categories"].arrayObject as? [String]
                        book.id = json["id"].string

                        self.updateView(book)
                        
                    }
                case .failure(let error):
                    statusCode = error._code // statusCode private
                    print("status code is: \(String(describing: statusCode))")
                    print(error)
                }
        }
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
