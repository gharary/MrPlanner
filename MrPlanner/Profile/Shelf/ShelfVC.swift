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
        
        
        //tableView.delegate = self
        //tableView.dataSource = self
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.layer.cornerRadius = 5
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if GoodreadsService.sharedInstance.isLoggedIn == .LoggedIn {
            importBtn.title = "Log Out"
        } else {
            importBtn.title = "Import Goodreads"
        }
        shelfToken?.invalidate()
    }
    
    
    @IBAction func importGoodreads(_ sender: UIBarButtonItem!) {
        
        switch sender.title {
        case "Import Goodreads":
            GoodreadsService.sharedInstance.loadBooks(sender: self, completion: { (book) in
                
                self.goodreadsBook = book
                
                self.collectionView.reloadData()
            })
            
            sender.title = "LogOut"
            break
        case "LogOut":
            GoodreadsService.sharedInstance.logoutOfGoodreadsAccount()
            sender.title = "Import Goodreads"
            break
        default:
            break
        }
        
        
    }
    

    @IBAction func backBtnTapped(_ sender:UIButton!) {
        
        self.dismiss(animated: true
            , completion:   nil)
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

extension ShelfVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            return shelf?.count ?? 0
            
        case 1:
            return goodreadsBook.count
            
            
        default:
            return 0
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SearchResultCell
        
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
        
        
        
        return cell
        
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
