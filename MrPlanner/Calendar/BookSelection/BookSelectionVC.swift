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
import RealmSwift
import JZCalendarWeekView
import Foundation

private let reuseIdentifier = "BookCell"

class BookSelectionVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let columns: CGFloat = 3
    let inset: CGFloat = 8.0
    let spacing: CGFloat = 8.0
    let lineSpacing: CGFloat = 8.0

    var sameWeek:Bool = false
    var weekDuration:Int = 0
    var startDate: Date = Date()
    var endDate = Date()
    
    static var sharedInstance = BookSelectionVC()
    
    static var selectedData = [UserTimeTable]()
    
    
    let searchController = UISearchController(searchResultsController: nil)
    
    let baseURL = URL(string: "https://www.googleapis.com/books/v1/volumes")
    let defaults = UserDefaults.standard
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = "Book Selection!"
        loadShelfBooks()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        SVProgressHUD.dismiss()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        collectionView.delegate = self
        collectionView.dataSource = self

        collectionView.layer.cornerRadius = 5
    }
    
    @IBAction func NextBtnTapped(_ sender: UIBarButtonItem) {
        
        //Call ProgramService
       
        if !selectedBooks.isEmpty {
            
            ProgramService.sharedInstance.sendDataToServer(selectedBooks: selectedBooks,startDate: startDate,endDate: endDate,weekDuration: weekDuration,sameWeek: sameWeek) {
                
                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyBoard.instantiateViewController(withIdentifier: "Tabbar")
                    self.present(vc, animated: true, completion: {
                        SVProgressHUD.showSuccess(withStatus: "Congratulation!")

                    })
                    
            }
        }
            
        
    }

    func dismissViewControllers() {
        
        guard let vc = self.presentingViewController else { return }
        
        while (vc.presentingViewController != nil) {
            vc.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func returnBack(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true
            , completion: nil)
    }
    
    
    var books: Results<Books>?
    var selectedBooks = [String]()
    
    func loadShelfBooks() {
        
        let realm = try! Realm()
        books = realm.objects(Books.self)
        
        
        //SVProgressHUD.showProgress(0.3)
        GoodreadsService.sharedInstance.loadBooks(sender: self) {
            (books)  in
            //self.books = books
            SVProgressHUD.showProgress(0.6)
            self.collectionView.reloadData()
            SVProgressHUD.showProgress(1)
            SVProgressHUD.dismiss()
            //print(books)
        }
        SVProgressHUD.dismiss(withDelay: 0.3)
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
        
        return books?.count ?? 0
        
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SearchResultCell

        if let book = books?[indexPath.row] {
            cell.titleLbl.text = book.title
            cell.authorLbl.text = book.authors.first
            cell.checkMarkView.style = .grayedOut
            cell.checkMarkView.setNeedsDisplay()
            if !book.image!.isEmpty {
            
                let url:URL! = URL(string: book.image!)
                cell.bookImage.kf.indicatorType = .activity
                cell.bookImage.kf.setImage(with: url)
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! SearchResultCell
   
        let bookID = books?[indexPath.row].id
        
        if !cell.checkMarkView.checked {
            selectedBooks.append(bookID ?? "")
            cell.checkMarkView.checked = !cell.checkMarkView.checked
        } else {
            selectedBooks.removeAll(where: {$0 == bookID })
            
            cell.checkMarkView.checked = !cell.checkMarkView.checked
        }
        
        
        
        
        
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
    
    
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.text != nil {
            //reqSearchServer(term: searchText)
        } else {
            
        }
    }
    
}

extension Dictionary {
    mutating func update(other:Dictionary) {
        for (key,value) in other {
            self.updateValue(value, forKey: key)
        }
    }
}

