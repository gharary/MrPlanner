//
//  SearchResultCVC.swift
//  MrPlanner
//
//  Created by Mohammad Gharari on 3/10/19.
//  Copyright © 2019 Mohammad Gharari. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher
import SwiftyJSON
import JonContextMenu
import SVProgressHUD

private let reuseIdentifier = "bookCell"

class SearchResultCVC: UICollectionViewController, UIGestureRecognizerDelegate,JonContextMenuDelegate {
    func menuOpened() {
        //UIDevice.vibrate()
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
    
    
    private var options:[JonItem] = []
    let items: [(icon: String, color: UIColor)] = [
        ("icon_home", UIColor(red: 0.19, green: 0.57, blue: 1, alpha: 1)),
        ("icon_search", UIColor(red: 0.22, green: 0.74, blue: 0, alpha: 1)),
        ("notifications-btn", UIColor(red: 0.96, green: 0.23, blue: 0.21, alpha: 1)),
        ("settings-btn", UIColor(red: 0.51, green: 0.15, blue: 1, alpha: 1)),
        ("nearby-btn", UIColor(red: 1, green: 0.39, blue: 0, alpha: 1))
    ]
    
    
    let BookCategories: [String] = ["Education","Fiction","Business","Design", "Growth", "Drama", "History", "Horror", "Art", "NonFiction", "Biography"]
    
    let columns: CGFloat = 3
    let inset: CGFloat = 8.0
    let spacing: CGFloat = 8.0
    let lineSpacing: CGFloat = 8.0
    
    
    let searchController = UISearchController(searchResultsController: nil)
    let baseURL = URL(string: "https://www.googleapis.com/books/v1/volumes")
    
    
    var scopeString: String = ""
    var currentParsingElement: String = ""
    var searchTerm: String = ""
    var searchData: [Books]!
    {
        didSet{
            self.collectionView.reloadData()
        }
    }
    var receivedData = Data()
    var VM_Overlay: UIView = UIView()
    var activityInd: UIActivityIndicatorView = UIActivityIndicatorView()
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = "Discover"
        SVProgressHUD.dismiss()
        randomCatBook()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        SVProgressHUD.dismiss()
    }
    
    
    private func randomCatBook() {
        if searchBarIsEmpty() {
            let i = Int.random(in: 0 ..< BookCategories.count)
            SVProgressHUD.showProgress(0.2)
            reqSearchServer(term: "subject=\(BookCategories[i])")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.searchData = []
        receivedData = Data()
        setupSearchController()
    }

    func setupSearchController() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Books"
        
        
        navigationItem.searchController = searchController
        navigationItem.searchController?.searchBar.delegate = self
        definesPresentationContext = true
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = false
            
        }
    }
    deinit {
        self.searchController.view.removeFromSuperview()
    }
    @IBAction func returnBack(_ sender: UIBarButtonItem) {
        //performSegueToReturnBack()
        self.dismiss(animated: true, completion: nil)
    }
    @objc func handleTap(sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "bookDetail", sender: self)
    }
    
    func searchBarIsEmpty() -> Bool {
        return (searchController.searchBar.text?.isEmpty)! //?? true
    }
    


    func removeBlur() {
        for subview in view.subviews {
            if subview is UIVisualEffectView {
                subview.removeFromSuperview()
            }
        }
    }
    

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        if searchData.count == 0 {
            return 0
        } else {
            return searchData.count
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        SVProgressHUD.showProgress(1)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SearchResultCell
    
        // Configure the cell
    
        var dictionary: [Books] = searchData
        
        cell.titleLbl.text = dictionary[indexPath.row].title
        cell.authorLbl.text = dictionary[indexPath.row].authors?[0]
        
        if dictionary[indexPath.row].image != nil {
            let str = dictionary[indexPath.row].image
            let replace = str?.replacingOccurrences(of: "http", with: "https")
            let url:URL! = URL(string: replace!)
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
        cell.titleLbl.textColor = UIColor(red: 0.33, green: 0.39, blue: 0.47, alpha: 1)
        //cell.authorLbl.textColor = UIColor(red: 0.85, green: 0.86, blue: 0.89, alpha: 1)
        SVProgressHUD.dismiss(withDelay: 0.5)
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "bookDetail" {
            if let nav = segue.destination as? UINavigationController, let vc = nav.topViewController as? BookDetailVC {
            let cell = sender as! UICollectionViewCell
            
            if let indexPath = self.collectionView.indexPath(for: cell) {
            
            
                vc.book = searchData?[indexPath.row]
                vc.bookImage = searchData?[indexPath.row].image ?? ""
                vc.booktitle = searchData?[indexPath.row].title ?? "No title"
                vc.bookAuthor = searchData?[indexPath.row].authors?[0] ?? "No Author"
                vc.bookID = searchData[indexPath.row].id ?? ""
                //print(searchData[indexPath.row].avgRating!)
                vc.averageRating = searchData[indexPath.row].avgRating ?? 0
                }
            }
            
        }
    }
}

extension SearchResultCVC : UICollectionViewDelegateFlowLayout {
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



extension SearchResultCVC: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        randomCatBook()
    }
}
extension SearchResultCVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            reqSearchServer(term: searchText)
        } else {
            randomCatBook()
            //collectionView.reloadData()
        }
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
                    SVProgressHUD.dismiss()
                    print("status code is: \(String(describing: statusCode))")
                    print(error)
                }
        }
    }
}
