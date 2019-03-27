//
//  SearchTVC.swift
//  MrPlanner
//
//  Created by Mohammad Gharari on 2/17/19.
//  Copyright © 2019 Mohammad Gharari. All rights reserved.
//

import UIKit
import Alamofire
import SWXMLHash
import Kingfisher

class SearchTVC: UITableViewController , XMLParserDelegate {

    let searchController = UISearchController(searchResultsController: nil)
    let baseUrl = URL(string: "https://www.goodreads.com/search/index.xml")

    var scopeString: String = ""
    var currentParsingElement:String = ""
    var searchTerm: String = ""
    var xml :XMLIndexer!
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
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func setupSearchController() {
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Books"
        searchController.searchBar.scopeButtonTitles = ["title", "author", "all"]
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
    
    @IBAction func returnBack(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
        //performSegueToReturnBack()
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
    
        scopeString = searchBar.scopeButtonTitles?[searchBar.selectedScopeButtonIndex] ?? "all"
        let searchText = searchBar.text ?? ""
        searchData = []
        
        reqSearchServer(term: searchText, scopeString)
        self.tableView.reloadData()
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
        //return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookCell", for: indexPath) as! BookTVCell

        var dictionary: [Books] = searchData
        // Configure the cell...
        cell.bookAuthor.text = dictionary[indexPath.row].authors?[0]
        cell.bookTitle.text = dictionary[indexPath.row].title
        if dictionary[indexPath.row].image != nil {
            let url:URL! = URL(string: dictionary[indexPath.row].image!)
            cell.bookImg.kf.indicatorType = .activity
            cell.bookImg.kf.setImage(with: url, options: [.transition(.fade(0.4))])
        }
        
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showDetail" {
            //let vc = segue.destination as! BookDetail
            //let indexPath = tableView.indexPathForSelectedRow
            //vc.title = searchData?[indexPath?.row]
        }
    }
    

}
extension SearchTVC: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        // TODO
        if let searchText = searchController.searchBar.text {
            reqSearchServer(term: searchText, scopeString)
        } else {
            tableView.reloadData()
        }
    }

    func reqSearchServer(term: String, _ searchScope: String) {
        
        let parameters: Parameters = ["q":term,"page":"","key":"FQ0SFjCwuDb7SRo6bOkPQ","search":searchScope]
        
        Alamofire.request(baseUrl!, method: .get, parameters: parameters)
            .responseString { response in
                
                var statusCode = response.response?.statusCode
                
                switch response.result {
                case .success:
                    //print("First Response : \(String(describing: response.result.value))")
                    //self.xml = SWXMLHash.parse(response.result.value!)
                    self.xml = SWXMLHash.lazy(response.result.value!)
                    
                    self.searchData = []
                    for elem in self.xml["GoodreadsResponse"]["search"]["results"]["work"].all {
                        
                        var book: Books = Books()
                        
                        //book.authors = elem["best_book"]["author"]["name"].element?.text
                        book.title = elem["best_book"]["title"].element?.text
                        book.image = elem["best_book"]["small_image_url"].element?.text
                        book.id = elem["id"].element?.text
                        self.searchData.append(book)
                        
                    }
                    self.tableView.reloadData()
                    
                case .failure(let error):
                    statusCode = error._code // statusCode private
                    print("status code is: \(String(describing: statusCode))")
                    print(error)
                }
        }

    }
    
}
extension UIViewController {
    func performSegueToReturnBack()  {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
