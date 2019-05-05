//
//  BookSelectionVC.swift
//  MrPlanner
//
//  Created by Mohammad Gharari on 5/2/19.
//  Copyright © 2019 Mohammad Gharari. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher
import SVProgressHUD
import SwiftyJSON
private let reuseIdentifier = "BookCell"

class BookSelectionVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let columns: CGFloat = 3
    let inset: CGFloat = 8.0
    let spacing: CGFloat = 8.0
    let lineSpacing: CGFloat = 8.0
    
    let searchController = UISearchController(searchResultsController: nil)
    
    let BookCategories: [String] = ["Education","Fiction","Business","Design", "Growth", "Drama", "History", "Horror", "Art", "NonFiction", "Biography"]
    let baseURL = URL(string: "https://www.googleapis.com/books/v1/volumes")

    var searchData: [Books]!
    {
        didSet{
            self.collectionView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = "Book Selection!"
        randomCatBook()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        collectionView.delegate = self
        collectionView.dataSource = self

        collectionView.layer.cornerRadius = 5
    }
    @IBAction func returnBack(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true
            , completion: nil)
    }
    
    
}

extension BookSelectionVC: UICollectionViewDataSource, UICollectionViewDelegate {

    // MARK: UICollectionViewDataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        guard searchData != nil && searchData.count != nil else { return 0 }
        return searchData.count
        
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SearchResultCell
    
        // Configure the cell
        var dictionary: [Books] = searchData
        
        cell.titleLbl.text = dictionary[indexPath.row].title
        cell.authorLbl.text = dictionary[indexPath.row].authors?[0]
        
        cell.checkMarkView.style = .grayedOut
        cell.checkMarkView.setNeedsDisplay()
        
        if dictionary[indexPath.row].image != nil {
            let str = dictionary[indexPath.row].image
            let replace = str?.replacingOccurrences(of: "http", with: "https")
            let url:URL! = URL(string: replace!)
            cell.bookImage.kf.indicatorType = .activity
            cell.bookImage.kf.setImage(with: url!)
            
        }
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! SearchResultCell
   
        cell.checkMarkView.checked = !cell.checkMarkView.checked
        
    }



}

extension BookSelectionVC: UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = Int((collectionView.frame.width / columns) - (inset + spacing))
        //let height = Int(collectionView.frame.height / columns)
        
        //let height = 138 - width + (inset + spacing))
        return CGSize(width: width, height: width * 2)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return lineSpacing
    }
}
extension BookSelectionVC: UISearchResultsUpdating {
    
    
    func searchBarIsEmpty() -> Bool {
        return (searchController.searchBar.text?.isEmpty)!
    }
    
    private func randomCatBook() {
        
        
        
            let i = Int.random(in: 0 ..< BookCategories.count)
            //SVProgressHUD.showProgress(0.2)
            reqSearchServer(term: "subject=\(BookCategories[i])")
        
        
    }
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            reqSearchServer(term: searchText)
        } else {
            
        }
    }
    
    func reqSearchServer(term: String) {
        
        let parameters: Parameters = ["q":term,"key":"AIzaSyCIXIPXJQwCYE9hHdTghuH-jNRIm2tvx8Y","maxResults":"40"]
        //SVProgressHUD.showProgress(0.3)
        Alamofire.request(baseURL!, method: .get, parameters: parameters)
            .responseJSON { response in
                var statusCode = response.response?.statusCode
                
                switch response.result {
                case .success:
                    
                    //print("Success!")
                    if response.data != nil {
                        
                        let json = try! JSON(data: response.data!)
                        //print(json)
                        self.searchData = []
                        for (_,subJson):(String, JSON) in json["items"] {
                            
                            
                            var book:Books = Books()
                            
                            //Author
                            book.authors = subJson["volumeInfo"]["authors"].arrayObject as? [String]
                            
                            //Description
                            if let desc = subJson["volumeInfo"]["description"].string {
                                let replace = desc.replacingOccurrences(of: "<p>|</p>|<br>|</br>|<i>|</i>|<b>|</b>", with: "", options: .regularExpression)
                                
                                book.desc = replace
                            }
                            
                            //Image
                            book.image = subJson["volumeInfo"]["imageLinks"]["thumbnail"].string
                            
                            //Title
                            book.title = subJson["volumeInfo"]["title"].string
                            
                            //ID
                            book.id = subJson["id"].string
                            
                            //Average Rating
                            if let avg = subJson["volumeInfo"]["averageRating"].int { book.avgRating = Double(avg) }
                            
                            //Categories
                            if subJson["volumeInfo"]["categories"].count == 1 {
                                /*
                                 let item:String = subJson["volumeInfo"]["categories"][0].string!
                                 book.categories?.append(item)
                                 */
                                
                                book.mainCategory = subJson["volumeInfo"]["categories"][0].string!
                                //print(subJson["volumeInfo"]["categories"][0].string!)
                            } else {
                                book.categories = subJson["volumeInfo"]["categories"].arrayObject as? [String]
                            }
                            
                            //Publisher
                            book.publisher = subJson["volumeInfo"]["publisher"].string
                            
                            //Publish Date
                            book.publishDate = subJson["volumeInfo"]["publishedDate"].string
                            
                            
                            //ISBN
                            if subJson["volumeInfo"]["industryIdentifiers"][0]["type"] == "ISBN_10" {
                                book.ISBN_10 = subJson["volumeInfo"]["industryIdentifiers"][0]["identifier"].string
                                book.ISBN_13 = subJson["volumeInfo"]["industryIdentifiers"][1]["identifier"].string
                            } else if subJson["volumeInfo"]["industryIdentifiers"][0]["type"] == "ISBN_13" {
                                book.ISBN_10 = subJson["volumeInfo"]["industryIdentifiers"][1]["identifier"].string
                                book.ISBN_13 = subJson["volumeInfo"]["industryIdentifiers"][0]["identifier"].string
                                
                            }
                            
                            //Page Count
                            book.pageCount = subJson["volumeInfo"]["pageCount"].string
                            
                            
                            
                            self.searchData.append(book)
                            
                        }
                        
                        
                        self.collectionView.reloadData()
                        
                    }
                case .failure(let error):
                    statusCode = error._code // statusCode private
                    SVProgressHUD.showError(withStatus: "Error")
                    SVProgressHUD.dismiss()
                    print("status code is: \(String(describing: statusCode))")
                    print(error)
                }
        }
    }
    
    
}
