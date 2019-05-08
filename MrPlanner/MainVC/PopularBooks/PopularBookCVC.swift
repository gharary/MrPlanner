//
//  PopularBookCVC.swift
//  MrPlanner
//
//  Created by Mohammad Gharari on 3/2/19.
//  Copyright © 2019 Mohammad Gharari. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher
import JonContextMenu
import SVProgressHUD


private let reuseIdentifier = "bookCell"

class PopularBookCVC: UICollectionViewController, JonContextMenuDelegate {
    func menuOpened() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    func menuClosed() {
        
    }
    
    func menuItemWasSelected(item: JonItem) {
        print("Selected Item is \(String(describing: item.id))")
    }
    
    func menuItemWasActivated(item: JonItem) {
        
    }
    
    func menuItemWasDeactivated(item: JonItem) {
        
    }
    

    let columns: CGFloat = 3.5
    let inset: CGFloat = 8.0
    let spacing: CGFloat = 8.0
    let lineSpacing:CGFloat = 8.0
    
    
    let BookCategories: [String] = ["Education","Fiction","Business","Design", "Growth", "Drama", "History", "Horror", "Art", "NonFiction", "Biography"]
    let baseURL = URL(string: "https://www.googleapis.com/books/v1/volumes")

    
    var searchData: [Books]!
    {
        didSet{
            self.collectionView.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //SVProgressHUD.setContainerView(MainVC)
        //SVProgressHUD.showProgress(0.1)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        randomCatBook()
        
    }

    private func randomCatBook() {
        self.searchData = []
        let i = Int.random(in: 0 ..< BookCategories.count)
        //SVProgressHUD.showProgress(0.2)
        reqSearchServer(term: "subject=\(BookCategories[i])")
    }
    
 
 
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        if searchData.count == 0 {
            return 0
        } else {
            return searchData.count
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PopularBookCell
    
        // Configure the cell
        /*
        cell.bookImage.image = UIImage(named: "Traction")
        cell.titleLbl.text = "Traction"
        cell.authorLbl.text = "Gabriel Weinberg"
        cell.titleLbl.textColor = UIColor(red: 0.33, green: 0.39, blue: 0.47, alpha: 1)
        cell.authorLbl.textColor = UIColor(red: 0.85, green: 0.86, blue: 0.89, alpha: 1)
        */
        
        SVProgressHUD.showProgress(1)
        
        cell.titleLbl.text = searchData[indexPath.row].title
        cell.authorLbl.text = searchData[indexPath.row].authors?[0]
        if searchData[indexPath.row].image != nil {
            let replace = searchData[indexPath.row].image?.replacingOccurrences(of: "http", with: "https")
            let url:URL! = URL(string: replace!)
            //searchData[indexPath.row].image = replace
            cell.bookImage.kf.indicatorType = .activity
            cell.bookImage.kf.setImage(with: url!)
            
            
        }
        
        
        //init JonContextMenu
        
        let items = [JonItem(id: 1, title: "Google"   , icon: UIImage(named:"google")),
                     JonItem(id: 2, title: "Twitter"  , icon: UIImage(named:"twitter")),
                     JonItem(id: 3, title: "Facebook" , icon: UIImage(named:"facebook")),
                     JonItem(id: 4, title: "Instagram", icon: UIImage(named:"instagram"))]
        let contextMenu = JonContextMenu().setItems(items)
            
            .setBackgroundColorTo(.orange)
            .setItemsDefaultColorTo(.black)
            .setItemsActiveColorTo(.blue)
            .setIconsDefaultColorTo(.white)
            .setItemsActiveColorTo(.white)
            .setItemsTitleColorTo(.black)
            .setDelegate(self)
            .build()
        
        self.view.addGestureRecognizer(contextMenu)
        SVProgressHUD.dismiss(withDelay: 0.5)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //performSegue(withIdentifier: "BookDetailVC", sender: nil)
        
    }
    
    func reqSearchServer(term: String) {
        
        let parameters: Parameters = ["q":term,"key":"AIzaSyCIXIPXJQwCYE9hHdTghuH-jNRIm2tvx8Y","maxResults":"40"]
        SVProgressHUD.showProgress(0.3)
        Alamofire.request(baseURL!, method: .get, parameters: parameters)
            .responseJSON { response in
                var statusCode = response.response?.statusCode
                
                switch response.result {
                case .success:
                    
                    //print("Success!")
                    if response.data != nil {
                        SVProgressHUD.showProgress(0.6)
                        let json = try! JSON(data: response.data!)
                        //print(json)
                        self.searchData = []
                        for (_,subJson):(String, JSON) in json["items"] {
                            
                            //print("This is subJson: \(String(describing: subJson["volumeInfo"]["title"].string))")
                            
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
                        
                        SVProgressHUD.showProgress(0.8)
                        self.collectionView.reloadData()
                        
                    }
                case .failure(let error):
                    statusCode = error._code // statusCode private
                    
                    SVProgressHUD.showError(withStatus: "Error")
                    SVProgressHUD.dismiss(withDelay: 0.5)
                    print("status code is: \(String(describing: statusCode))")
                    print(error)
                }
        }
    }
    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "BookDetailVC" {
            if let nav = segue.destination as? UINavigationController, let vc = nav.topViewController as? BookDetailVC {
            //let vc = segue.destination as! BookDetailVC
            let cell = sender as! UICollectionViewCell
            if let indexPath = self.collectionView.indexPath(for: cell) {
                
                vc.book = searchData?[indexPath.row]
                vc.bookImage = searchData?[indexPath.row].image ?? ""
                vc.booktitle = searchData?[indexPath.row].title ?? "No title"
                vc.bookAuthor = searchData?[indexPath.row].authors?[0] ?? "No Author"
                vc.bookID = searchData[indexPath.row].id ?? ""
                vc.averageRating = searchData[indexPath.row].avgRating ?? 0
                vc.segueString = "BookDetailVC"
                }
            }
 
        }
    }
    

}
extension PopularBookCVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = Int((collectionView.frame.width / columns) - (inset + spacing))
        
        
        return CGSize(width: width, height: width * 2)
        
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
