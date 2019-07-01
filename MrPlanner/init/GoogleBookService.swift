//
//  GoogleBookService.swift
//  MrPlanner
//
//  Created by Mohammad Gharari on 6/2/19.
//  Copyright © 2019 Mohammad Gharari. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift

class GoogleBookService {
    static var sharedInstance = GoogleBookService()
    
    
    func searchGoogle(sender: UIViewController, _ term: String, completion: @escaping ([Books]) -> ()) {
        
        var books = [Books]()
        let url = URL(string: "https://www.googleapis.com/books/v1/volumes")
        let param: Parameters = ["q":term,
                                 "key": Bundle.main.localizedString(forKey: "googleAPI", value: nil, table: "Secrets"),
                                 "maxResults":"40"]
        
        Alamofire.request(url!, method: .get, parameters: param)
            .responseJSON { response in
                
                let statusCode = response.response?.statusCode
                if statusCode != 200 {
                    //alert
                    return
                }
                switch response.result {
                case .success:
                    
                    if response.data != nil {
                        let json = try! JSON(data: response.data!)
                        
                        
                        for (_,subJSON):(String, JSON) in json["items"] {
                            
                            //let realm = try! Realm()
                            let book = Books()
                            
                            //Author
                            let authors = subJSON["volumeInfo", "authors"].arrayObject as? [String] ?? ["No Author"]
                            
                            book.authors.append(objectsIn: authors)
                            
                            if let desc = subJSON["volumeInfo", "description"].string {
                                let replace = desc.replacingOccurrences(of: "<p>|</p>|<br>|</br>|<i>|</i>|<b>|</b>", with: "", options: .regularExpression)
                                
                                book.desc = replace
                            }
                            //Image
                            book.image = subJSON["volumeInfo","imageLinks","thumbnail" ].string
                            
                            //Title
                            book.title = subJSON["volumeInfo", "title"].string
                            
                            //ID
                            book.id = subJSON["id"].string
                            
                            //Average Rating
                            if let avg = subJSON["volumeInfo", "averageRating"].int {
                                book.avgRating = RealmOptional<Double>(Double(avg))
                            }
                            
                            //Category
                            let categories = subJSON["volumeInfo", "categories"].arrayObject as? [String] ?? ["No Category"]
                            book.categories.append(objectsIn: categories)
                            
                            /*
                            if subJSON["volumeInfo", "categories"].count == 1 {
                                book.mainCategory = subJSON["volumeInfo", "categories"][0].string
                            } else {
                                book.categories = subJSON["volumeInfo", "categories"].arrayObject as? [String]
                            }
                            */
                            //Publisher Date
                            book.publishDate = subJSON["volumeInfo", "publishedDate"].string
                            
                            //ISBN
                            if subJSON["volumeInfo", "industryIdentifiers",0,"type"] == "ISBN_10" {
                                book.ISBN10 = subJSON["volumeInfo", "industryIdentifiers"][0]["identifier"].string
                                book.ISBN13 = subJSON["volumeInfo", "industryIdentifiers"][1]["identifier"].string
                            } else if subJSON["volumeInfo", "industryIdentifiers"][0]["type"] == "ISBN_13" {
                                book.ISBN10 = subJSON["volumeInfo", "industryIdentifiers"][1]["identifier"].string
                                book.ISBN13 = subJSON["volumeInfo", "industryIdentifiers"][0]["identifier"].string
                                
                            }
                            
                            
                            //Page Count
                            book.pageCount = RealmOptional<Int>(subJSON["volumeInfo", "pageCount"].int)
                            
                            
                            
                            books.append(book)
                            
                        } //End for loop
                        
                        completion(books)
                        
                    }// End if responseData
                    
                    break
                case .failure(let error):
                    
                    print(error.localizedDescription)
                    break
                }
        }
        
        
    }
}
