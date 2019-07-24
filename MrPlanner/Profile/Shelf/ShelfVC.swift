//
//  ShelfVC.swift
//  MrPlanner
//
//  Created by Mohammad Gharari on 6/4/19.
//  Copyright © 2019 Mohammad Gharari. All rights reserved.
//

import UIKit
import RealmSwift
import Kingfisher
import SwiftyJSON
import Foundation
import JonContextMenu
import Crashlytics


class ShelfVC: UIViewController {

    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var importBtn: UIBarButtonItem!
    
    let columns: CGFloat = 3
    let inset: CGFloat = 8.0
    let spacing: CGFloat = 8.0
    let lineSpacing: CGFloat = 8.0
    
    let baseURL = URL(string: "https://www.googleapis.com/books/v1/volumes")
    let defaults = UserDefaults.standard
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var segmentControl: UISegmentedControl!
    
    
    let reuseIdentifier = "BookCell"
    private var shelf: Results<Shelve>?
    private var shelfToken: NotificationToken?
    private var goodreadsBook: [Book] = []
    
    let jonItems = [
    JonItem(id: 2, title: "AddToShelve", icon: UIImage(named: "Shelf"), data: CGPoint())]
    
    
    override func viewWillAppear(_ animated: Bool) {
        let realm = try! Realm()
        shelf = realm.objects(Shelve.self)
        shelfToken = shelf!.observe { [weak self] _ in
            //self?.tableView.reloadData()
            self?.collectionView.reloadData()
        }
        
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        
        switch segmentControl.selectedSegmentIndex {
        case 0:
            //self.tableView.reloadData()
            self.collectionView.reloadData()
            break
        case 1:
            //self.tableView.reloadData()
            self.collectionView.reloadData()

            break
            
        default:
            //self.tableView.reloadData()
            self.collectionView.reloadData()

            break
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        collectionView.registerCell(SearchResultCell.self)
        
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.layer.cornerRadius = 5
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let barItem = UIBarButtonItem(title: "LogOut", style: .done, target: self, action: #selector(importGoodreads(_:)))
        
        if GoodreadsService.sharedInstance.isLoggedIn == .LoggedIn {
            self.navigationItem.rightBarButtonItem = barItem
        } else {
            barItem.title = "Import Goodreads"
            self.navigationItem.rightBarButtonItem = barItem
            
        }
        shelfToken?.invalidate()
    }
    
    
    @IBAction func importGoodreads(_ sender: UIBarButtonItem!) {
        //Crashlytics.sharedInstance().crash()
        
        let uiBusy = UIActivityIndicatorView(style: .gray)
        uiBusy.hidesWhenStopped = true
        
        let barItem = UIBarButtonItem(title: "LogOut", style: .done, target: self, action: #selector(importGoodreads(_:)))
        switch sender.title {
        case "Import Goodreads":
            uiBusy.startAnimating()
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: uiBusy)
            GoodreadsService.sharedInstance.loadBooks(sender: self, completion: { (book) in
                
                self.goodreadsBook = book
                
                self.collectionView.reloadData()
                uiBusy.stopAnimating()
                self.navigationItem.rightBarButtonItem = barItem
            })
            
            
            break
        case "LogOut":
            GoodreadsService.sharedInstance.logoutOfGoodreadsAccount()
            goodreadsBook = []
            self.collectionView.reloadData()
            sender.title = "Import Goodreads"
            break
        default:
            break
        }
        
        
    }
  
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            switch segmentControl.selectedSegmentIndex {
            case 1:
            
            if segue.identifier == "showBookDetail"{
                let vc = segue.destination as! BookDetailVC
                let indexPath = collectionView.indexPathsForSelectedItems?.first
            
                
                vc.goodreadBook = goodreadsBook[(indexPath?.row)!]
                vc.itemIsGoodread = true
                
                
                
            }
            break
            default:
                break
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
extension ShelfVC: JonContextMenuDelegate {
    func menuOpened() {
        
    }
    
    func menuClosed() {
        
    }
    
    func menuItemWasSelected(item: JonItem) {
       
        
    }
    
    func menuItemWasActivated(item: JonItem) {
        
    }
    
    func menuItemWasDeactivated(item: JonItem) {
        
    }
    
    
}
extension ShelfVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            if shelf?.count == 0 {
                collectionView.setEmptyMessage("No Books In Shelf!")
                return 0
            } else {
                collectionView.restore()
                return shelf!.count
            }
            
        case 1:
            if goodreadsBook.count == 0 {
                collectionView.setEmptyMessage("No Books Loaded! Click 'Import' To Import From Your Goodreads")
                return 0
            } else {
                collectionView.restore()
                return goodreadsBook.count
            }
            
        default:
            return 0
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SearchResultCell
        
        
        _ = JonContextMenu().setItems(jonItems).setDelegate(self)
            .setBackgroundColorTo(.orange)
            .setItemsDefaultColorTo(.black)
            .setItemsActiveColorTo(.white)
            .setItemsTitleColorTo(.black)
            
            .build()
        
        
        switch segmentControl.selectedSegmentIndex {
        case 0:
            let book = shelf![indexPath.row]
            
            cell.titleLbl.text = book.Book?.title
            cell.authorLbl.text = book.Book?.authors.first
            if !(book.Book?.image!.isEmpty)! {
                let url:URL! = URL(string: book.Book!.image!)
                cell.bookImage.kf.indicatorType = .activity
                cell.bookImage.kf.setImage(with: url)
            }
            
 
        case 1:
            
            let item = goodreadsBook[indexPath.row]
            cell.titleLbl.text = item.title
            cell.authorLbl.text = item.author//.name
            if !item.imageUrl.isEmpty {
                let url:URL! = URL(string: item.imageUrl)
                cell.bookImage.kf.indicatorType = .activity
                cell.bookImage.kf.setImage(with: url)
            }
        default:
            break
        }
        
        //cell.addGestureRecognizer(contextMenu)
        
        
        return cell
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            break
            
        case 1:
            performSegue(withIdentifier: "showBookDetail", sender: self)
            
            
        default:
            break
            
        }
        
    }
    
    
}

extension ShelfVC: UICollectionViewDelegateFlowLayout {
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

extension UICollectionView {
    
    /// Register a cell in the CollectionView given an UICollectionViewCell Type
    func registerCell<T:UICollectionViewCell>(_ cell:T.Type){
        self.register(T.self, forCellWithReuseIdentifier: String(describing: T.self))
        
    }
    // Returns a UICollectionViewCell for a given Class Type
    func getCell<T:UICollectionViewCell>(_ indexPath: IndexPath, _ type:T.Type) -> T?{
        return self.dequeueReusableCell(withReuseIdentifier: String(describing: T.self), for: indexPath) as? T
    }
}

extension ShelfVC: UITableViewDelegate {
    
    
}

extension ShelfVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            return shelf?.count ?? 0
            
        case 1:
            return goodreadsBook.count
            
            
        default:
            return 0
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) ?? UITableViewCell(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        
        switch segmentControl.selectedSegmentIndex {
        case 0:
            let item = shelf![indexPath.row]
            cell.textLabel?.text = item.Book?.title
            cell.detailTextLabel?.text = item.Book?.authors.first
            
        case 1:
            
            let item = goodreadsBook[indexPath.row]
            cell.textLabel?.text = item.title
            cell.detailTextLabel?.text = item.author//.name
        default:
            break
        }
       
        
        
        return cell
    }
    
    
    
}
