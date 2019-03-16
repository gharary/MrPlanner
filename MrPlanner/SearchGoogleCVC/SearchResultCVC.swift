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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchData = []
        receivedData = Data()
        setupSearchController()
    }

    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Books"
        
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
        //performSegueToReturnBack()
        self.dismiss(animated: true, completion: nil)
    }
    @objc func handleTap(sender: UITapGestureRecognizer) {
        //CircleMenu.hideButtons(CircleMenu.self)
    }
    /*
    @objc func handleLongPress(sender: UILongPressGestureRecognizer) {
        
        switch sender.state {
        case .began:
           
            button?.removeFromSuperview()
            let touchPoint = sender.location(in: self.collectionView)
            if let indexPath = self.collectionView.indexPathForItem(at: touchPoint) {
                let cell = self.collectionView.cellForItem(at: indexPath)
                print(indexPath)
                
                
                // init Button
                /*
                button = CircleMenu(frame: CGRect(x: ((cell?.center.x)!) , y: (cell?.center.y)!, width: 50, height: 50), normalIcon: "icon_menu", selectedIcon: "icon_close", buttonsCount: 4, duration: 1, distance: 100)
                button?.delegate = self
               
                button?.layer.cornerRadius = (button?.frame.size.width)! / 2.0
                */
                
                //init blur view
                /*
                let blurEffect = UIBlurEffect(style: .light)
                let blurEffectView = UIVisualEffectView(effect: blurEffect)
                blurEffectView.frame = self.view.bounds
                blurEffectView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
                
                let view = UIView(frame: (cell?.frame)!)
                view.addSubview(cell!)
                
                self.view.addSubview(view)
                self.view.addSubview(blurEffectView)
                
                
                button?.removeFromSuperview()
                self.view.addSubview(button!)
                button?.sendActions(for: .touchUpInside)
                //cell?.addSubview(button)
                */
                
            }
        case .changed:
            let point = sender.location(in: self.view)
            
        case .ended, .cancelled, .failed, .possible:
            let point = sender.location(in: self.view)
            
        }
    }
    */
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
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
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SearchResultCell
    
        // Configure the cell
    
        var dictionary: [Books] = searchData
        
        cell.titleLbl.text = dictionary[indexPath.row].title
        cell.authorLbl.text = dictionary[indexPath.row].author
        
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
        return cell
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

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

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
extension SearchResultCVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            reqSearchServer(term: searchText)
        } else {
            collectionView.reloadData()
        }
    }
    
    func reqSearchServer(term: String) {
        
        let parameters: Parameters = ["q":term,"key":"AIzaSyCIXIPXJQwCYE9hHdTghuH-jNRIm2tvx8Y","maxResults":"40"]
        
        Alamofire.request(baseURL!, method: .get, parameters: parameters)
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
                        
                        
                        self.collectionView.reloadData()
                        
                    }
                case .failure(let error):
                    statusCode = error._code // statusCode private
                    print("status code is: \(String(describing: statusCode))")
                    print(error)
                }
        }
    }
}
