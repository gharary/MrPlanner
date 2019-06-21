//
//  LeadersBooksVC.swift
//  MrPlanner
//
//  Created by Mohammad Gharari on 6/18/19.
//  Copyright © 2019 Mohammad Gharari. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import SwiftyXMLParser
import JonContextMenu
import RealmSwift
private let reuseIdentifier = "BookCell"

class LeadersBooksVC: UICollectionViewController {

    var leaderID:String = ""
    private var goodReadsBook : [Book] = []

    override func viewDidAppear(_ animated: Bool) {
        SVProgressHUD.show(withStatus: "Loading...")
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "What Leaders Reading"
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        loadBooks(sender: self, completion: { (book) in
            
            self.goodReadsBook = book
            self.collectionView.reloadData()
            SVProgressHUD.showSuccess(withStatus: "Finished!")
        })
        
        SVProgressHUD.dismiss()

        // Do any additional setup after loading the view.
    }
    
    

    @IBAction func returnBackBtn(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func loadBooks(sender: UIViewController, completion: @escaping ([Book]) -> ()) {
        var returnResult = [Book]()
        
        guard !leaderID.isEmpty else {
            alertUser(sender: self, "Error, LeaderID is empty")
            dismissView()
            
            return
        }
        var components = URLComponents(string: "https://www.goodreads.com/review/list")
        components?.queryItems = [
            URLQueryItem(name: "key", value: "\(Bundle.main.localizedString(forKey: "goodreads_key", value: nil, table: "Secrets"))"),
            URLQueryItem(name: "id", value: "\(leaderID)"),
            URLQueryItem(name: "v", value: "2"), URLQueryItem(name: "per_page", value: "200")]
        
        if let url = components?.url
        {
            Alamofire.request(url).response { response in
                let xml = XML.parse(response.data!)
                //let count = xml["GoodreadsResponse", "reviews",0,"review"].all?.count
                for item in xml["GoodreadsResponse", "reviews",0,"review"] {
                    
                    //let book = Book(xml: books[0, "review",i,"book"])
                    let book = Book(xml: item["book"])
                    returnResult.append(book)
                }
                
                completion(returnResult)
                
            }
        }
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return goodReadsBook.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SearchResultCell
    
        
        //init ContextMenu
        let items = [JonItem(id: 1, title: "Add to Shelve", icon: UIImage(named: "Shelf"), data: indexPath.row)]
        
        
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
        
        
        // Configure the cell
        
        let item = goodReadsBook[indexPath.row]
        cell.titleLbl.text = item.title
        cell.authorLbl.text = item.author//.name
        if !item.imageUrl.isEmpty {
            let url:URL! = URL(string: item.imageUrl)
            cell.bookImage.kf.indicatorType = .activity
            cell.bookImage.kf.setImage(with: url)
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "bookDetail" {
            
            if let vc = segue.destination as? BookDetailVC {
                
                let cell = sender as! UICollectionViewCell
                
                if let indexPath = self.collectionView.indexPath(for: cell) {
                    
                    vc.goodreadBook = goodReadsBook[indexPath.row]
                    vc.itemIsGoodread = true
                    
                    
                }
                
            }
          
        }
    }

    
    
    let columns: CGFloat = 3
    let inset: CGFloat = 8.0
    let spacing: CGFloat = 8.0
    let lineSpacing: CGFloat = 8.0
    
    

}

extension LeadersBooksVC: JonContextMenuDelegate {
    
    func menuOpened() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
    }
    
    func menuClosed() {
        
    }
    
    func menuItemWasSelected(item: JonItem) {
        switch item.id {
        case 1:
            
            
            
            break
        default:
            break
        }
    }
    
    func menuItemWasActivated(item: JonItem) {
        
    }
    
    func menuItemWasDeactivated(item: JonItem) {
        
    }
    
    
    private func checkUserLogin(sender: UIViewController, completion: @escaping () -> ()) {
        let realm = try! Realm()
        
        guard MrPlannerService.sharedInstance.isLoggedIn == .LoggedIn else {
            MrPlannerService.sharedInstance.loginToMrPlannerAccount(sender: self) {
                self.checkUserLogin(sender: sender, completion: completion)
            }
            return
        }
        
        //let item = realm.objects(Shelve.self).filter("GoodreadsID =  %@", )
        
    }
    
    
}
extension LeadersBooksVC: UICollectionViewDelegateFlowLayout {
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
