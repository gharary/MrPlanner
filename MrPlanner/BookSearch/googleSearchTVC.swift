//
//  googleSearchTVC.swift
//  MrPlanner
//
//  Created by Mohammad Gharari on 2/19/19.
//  Copyright © 2019 Mohammad Gharari. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher
import SwiftyJSON

class googleSearchTVC: UITableViewController {

    let searchController = UISearchController(searchResultsController: nil)
    let baseUrl = URL(string: "https://www.googleapis.com/books/v1/volumes")
    
    var scopeString: String = ""
    var currentParsingElement:String = ""
    var searchTerm: String = ""
    var searchData:[Books]!
    {
        didSet{
            self.tableView.reloadData()
        }
    }
    
    var receivedData = Data()
    var VM_Overlay: UIView = UIView()
    var activityIndc: UIActivityIndicatorView = UIActivityIndicatorView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupSearchController()
        self.searchData = []
        receivedData = Data()
        
    }
    
    @IBAction func returnBack(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
        //performSegueToReturnBack()
    }
    
    func setupSearchController() {
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Books"
        //searchController.searchBar.scopeButtonTitles = ["title", "author", "all"]
        navigationItem.searchController = searchController
        definesPresentationContext = true
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = false
        }
    }
    deinit {
        self.searchController.view.removeFromSuperview()
    }
    

    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if searchData.count == 0 {
            //self.tableView.setEmptyMessage("")
            return 0
        } else {
            return searchData.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookCell", for: indexPath) as! BookTVCell
        
        var dictionary: [Books] = searchData
        // Configure the cell...
        cell.bookAuthor.text = dictionary[indexPath.row].author
        cell.bookTitle.text = dictionary[indexPath.row].title
        if dictionary[indexPath.row].image != nil {
            let str = dictionary[indexPath.row].image
            let replace = str?.replacingOccurrences(of: "http", with: "https")
            let url:URL! = URL(string: replace!)
            
            //print(url!)
            cell.bookImg.kf.indicatorType = .activity
            cell.bookImg.kf.setImage(with: url!)
            //cell.bookImg.sd_setImage(with: url)
            //cell.bookImg.kf.setImage(with: url!, options: [.transition(.fade(0.4))])
        }
        
        
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
extension googleSearchTVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        // TODO
        if let searchText = searchController.searchBar.text {
            reqSearchServer(term: searchText)
        } else {
            tableView.reloadData()
        }
    }
    func reqSearchServer(term: String) {
        
        let parameters: Parameters = ["q":term,"key":"AIzaSyCIXIPXJQwCYE9hHdTghuH-jNRIm2tvx8Y"]
        
        Alamofire.request(baseUrl!, method: .get, parameters: parameters)
            .responseJSON { response in
                var statusCode = response.response?.statusCode
                
                switch response.result {
                case .success:
                    
                    print("Success!")
                    if response.data != nil {
                        
                        let json = try! JSON(data: response.data!)
                        //print(json)
                        self.searchData = []
                        for (_,subJson):(String, JSON) in json["items"] {
                            
                            //print("This is subJson: \(String(describing: subJson["volumeInfo"]["title"].string))")
                        
                            var book:Books = Books()
                            book.author = subJson["volumeInfo"]["authors"][0].string
                            book.desc = subJson["volumeInfo"]["description"].string
                            book.image = subJson["volumeInfo"]["imageLinks"]["thumbnail"].string
                            book.title = subJson["volumeInfo"]["title"].string
                            
                            self.searchData.append(book)
                            
                        }
                            
                        
                        self.tableView.reloadData()
                        
                    }
                case .failure(let error):
                    statusCode = error._code // statusCode private
                    print("status code is: \(String(describing: statusCode))")
                    print(error)
                }
            }
    }
    
    
}
