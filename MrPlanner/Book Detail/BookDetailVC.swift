//
//  BookDetailVC.swift
//  MrPlanner
//
//  Created by Mohammad Gharari on 3/17/19.
//  Copyright © 2019 Mohammad Gharari. All rights reserved.
//

import UIKit
import Cosmos
import Kingfisher
import BetterSegmentedControl
import FontAwesome_swift
import SVProgressHUD
import RealmSwift

class BookDetailVC: UIViewController {

    @IBOutlet weak var bookTitleLbl: UILabel!
    @IBOutlet weak var bookAuthorLbl: UILabel!
    @IBOutlet weak var categoriesView: UIView!
    @IBOutlet weak var bookImg: UIImageView!
    @IBOutlet weak var addedToShelfTimeLbl: UILabel!
    @IBOutlet weak var starsCosmos: CosmosView!
    @IBOutlet weak var addToShelfBtn: UIButton!
    @IBOutlet weak var segmentControl: BetterSegmentedControl!
    @IBOutlet weak var containerView: UIView!
    
    
    var book: Books!
    var goodreadBook: Book!
    
    var booktitle: String = ""
    var bookAuthor: String = ""
    var bookDesc : String = ""
    var bookImage: String = ""
    var bookID:String = ""
    var averageRating:Double = 0
    var defaults = UserDefaults.standard
    
    var segueString:String = ""
    
    lazy var IntroductionVC: IntroductionVC = {
        
        
        let storyboard = UIStoryboard(name: "GoogleSearchCollectionResult", bundle: Bundle.main)
        
        var viewController = storyboard.instantiateViewController(withIdentifier: "IntroductionVC") as! IntroductionVC
        viewController.book = self.book
        
        //viewController.bookID = self.book.id ?? ""
        self.addViewControllerAsChildViewController(childViewController: viewController)
        
        return viewController
    }()
    
    lazy var DetailVC: DetailVC = {
        let storyboard = UIStoryboard(name: "GoogleSearchCollectionResult", bundle: Bundle.main)
        
        var viewController = storyboard.instantiateViewController(withIdentifier: "DetailVC") as! DetailVC
        viewController.book = self.book
        
        
        //viewController.bookID = self.bookID
        
        
        self.addViewControllerAsChildViewController(childViewController: viewController)
        //viewController.bookID = self.bookID
        return viewController
    }()
    
    lazy var ReviewVC: ReviewTVC = {
        let storyboard = UIStoryboard(name: "GoogleSearchCollectionResult", bundle: Bundle.main)
        
        var viewController = storyboard.instantiateViewController(withIdentifier: "ReviewVC") as! ReviewTVC
        self.addViewControllerAsChildViewController(childViewController: viewController)
        
        return viewController
    }()
    
    
    
    private func addViewControllerAsChildViewController(childViewController: UIViewController) {
        addChild(childViewController)
        //view.addSubview(childViewController.view)
        containerView.addSubview(childViewController.view)
        childViewController.view.frame = containerView.bounds
        childViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        childViewController.didMove(toParent: self)
        
    }
    
    private func removeViewControllerAsChildViewController(childViewController: UIViewController) {
        childViewController.willMove(toParent: nil)
        childViewController.view.removeFromSuperview()
        childViewController.removeFromParent()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Book Details"
        checkLoadingSource()
        checkSegue()
        initStart()
        updateViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkLoadingSource()
        DispatchQueue.main.async {
            self.checkBookInShelve()
        }
    }
    var itemIsGoodread: Bool = false
    
    
    private func checkLoadingSource() {
        let backBarButtonItem = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(returnBack(_:)))
        self.navigationItem.leftBarButtonItem  = backBarButtonItem
        if !itemIsGoodread {
            loadData()
            
        } else {
            loadGoodreadsData()
        }
    }
    private func loadGoodreadsData() {
        
        let bookTemp = Books()
        
        bookTemp.id = goodreadBook.id
        bookTemp.title = goodreadBook.title
        bookTemp.authors.append((goodreadBook?.author)!)
        bookTemp.image = goodreadBook.imageUrl
        bookTemp.desc = goodreadBook.desc
        bookTemp.publisher = goodreadBook.publisher
        bookTemp.publishDate = goodreadBook.PublishDate
        bookTemp.ISBN13 = goodreadBook.ISBN13
        bookTemp.ISBN10 = goodreadBook.ISBN10
        bookTemp.pageCount.value = Int(goodreadBook.numPages)
        bookTemp.categories.append("Goodreads")
        bookTemp.avgRating = RealmOptional<Double>(Double(goodreadBook.avgRating))
        bookTemp.ratingCount = RealmOptional<Int>(Int(goodreadBook.numPages))
        
        
        booktitle = bookTemp.title ?? ""
        bookAuthor = bookTemp.authors.first ?? ""
        bookDesc = bookTemp.desc ?? ""
        bookImage = bookTemp.image ?? ""
        bookID = bookTemp.id ?? ""
        averageRating = bookTemp.avgRating.value ?? 0
        self.book = bookTemp
        
        loadData()
        
    }
    
    private func checkBookInShelve() {
        let realm = try! Realm()
        let item = realm.objects(Shelve.self).filter(itemIsGoodread ? "GoodreadsID = %@" : "GoogleID = %@", book.id!)
        if !item.isEmpty {
            addToShelfBtn.isEnabled = false
            addToShelfBtn.setTitle("In Shelf", for: .normal)
            return
        }
        
        addToShelfBtn.setTitle("Add to Shelf", for: .normal)
        addToShelfBtn.isEnabled = true

    }
    
    
    @IBAction func addShelfBtn(_ sender: UIButton) {
        checkLoggin(sender: self) { }
    
    }
    
    @objc func returnBack(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    private func checkLoggin(sender: UIViewController, completion: @escaping () -> () ) {
        
        
        guard MrPlannerService.sharedInstance.isLoggedIn == .LoggedIn else {
            MrPlannerService.sharedInstance.loginToMrPlannerAccount(sender: sender) {
                self.checkLoggin(sender: sender, completion: completion)
            }
            return
        }
        MrPlannerService.sharedInstance.addShelfBookToDB(sender: self, book:book ,title: book.title!, cat: (book.categories.first!) , pageNr: book!.pageCount, completion: { result, id in
            
            if result {
                let realm = try! Realm()
                let shelve = Shelve()
                shelve.Book = self.book
                if self.itemIsGoodread { shelve.GoodreadsID = self.book.id } else { shelve.GoogleID = self.book.id }
                shelve.InternalID = "\(id)"
                
                try! realm.write {
                    realm.add(shelve)
                }
                
                SVProgressHUD.showSuccess(withStatus: "Done!")
                self.addToShelfBtn.isEnabled = false
                self.addToShelfBtn.setTitle("In Shelf", for: .normal)
            } else {
                SVProgressHUD.showError(withStatus: "Error, Try Again Later")
                
            }
        })
        
        
    }
    private func checkSegue() {
        switch segueString {
        case "BookDetailVC":
             navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backTapped))
             
        case "bookDetail":
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backTapped))
            
        default:
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backTapped))
        }
    }
    
    @objc func backTapped(){
        performSegueToReturnBack()
        //self.dismiss(animated: true, completion: nil)
    }
    
    
    func loadData() {
        
        //Load TitlesR
        bookTitleLbl.text = booktitle
        bookAuthorLbl.text = bookAuthor
        
        //Load Image
        let url:URL
        
        if !itemIsGoodread {
            let replace = bookImage.replacingOccurrences(of: "http", with: "https")
            url = URL(string: replace)!
            
        } else {
            url = URL(string: bookImage)!
        }
        bookImg.layer.cornerRadius = 15
        bookImg.clipsToBounds = true
        bookImg.kf.indicatorType = .activity
        bookImg.kf.setImage(with: url, options: [.transition(.fade(0.2))])
        
        
        //Load Categories
        categoriesView.layer.cornerRadius = 5
        guard !book.categories.isEmpty else { return }
        
        guard let width = book.categories.first?.stringWidth else { return  }
            let label = UILabel(frame: CGRect(x: 6, y: 2, width: width, height: 25))
            label.backgroundColor = UIColor(hexString: "D8DCE2")
            label.layer.cornerRadius = 5
            label.clipsToBounds = true
            let font = UIFont(name: "SFProText-Regular", size: 10)
            let attributes: [NSAttributedString.Key: Any] = [
                .font: font!,
                .foregroundColor: UIColor.white,
                
            ]
            
        let attributedText = NSMutableAttributedString(string: (book.categories.first)!, attributes: attributes)
            
            label.attributedText = attributedText
            label.textAlignment = .center

            self.categoriesView.addSubview(label)
        
    }

    func initStart() {
        starsCosmos.settings.filledImage = UIImage(named: "star-solid")
        starsCosmos.settings.emptyImage = UIImage(named: "star-regular")
        starsCosmos.settings.fillMode = .precise
        starsCosmos.settings.updateOnTouch = false
        starsCosmos.rating = Double(averageRating) 
        
        //button init
        addToShelfBtn.clipsToBounds = true
       
        let shadow0 = UIView(frame: CGRect(x: 0, y: 0, width: 130, height: 40))
        shadow0.clipsToBounds = false
        shadow0.layer.shadowColor = UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 0.10).cgColor
        shadow0.layer.shadowOpacity = 0.1
        shadow0.layer.shadowOffset = CGSize(width: 0, height: 0)
        //addToShelfBtn.addSubview(shadow0)
        addToShelfBtn.layer.cornerRadius = 15
        addToShelfBtn.backgroundColor = UIColor(red: 0.11, green: 0.82, blue: 0.63, alpha: 1)
        //view.bringSubviewToFront(addToShelfBtn)
        addToShelfBtn.alpha = 1
        
        
        //label init
        
        addedToShelfTimeLbl.clipsToBounds = true
        addedToShelfTimeLbl.layer.cornerRadius = 15
        addedToShelfTimeLbl.backgroundColor = UIColor(red: 0.63, green: 0.75, blue: 0.77, alpha: 1)
        addedToShelfTimeLbl.alpha = 1
        
        addedToShelfTimeLbl.text = "1.6k times"
        
        let title = "\u{f02d}"
        
        let title2 = "\u{f13a}"
        
        let title3 = "\u{f086}" //String.fontAwesomeIcon(name: .commentDots) //or \u{f086}
        
        
        //Segment Control init
        segmentControl.segments = LabelSegment.segments(withTitles: [title,title2, title3],
                                                        normalFont: UIFont.fontAwesome(ofSize: 25, style: .solid),
                                                        normalTextColor: .lightGray,
                                                        selectedFont: UIFont.fontAwesome(ofSize: 25, style: .solid),
                                                        selectedTextColor: .white)
        
        segmentControl.options = [.backgroundColor(.darkGray),
                                  .indicatorViewBorderColor(.clear),
                                  //.indicatorCornerRadius(5.0),
                                  .cornerRadius(5.0),
                                  .bouncesOnChange(true)]
        
        
        
        //segmentControl.normalFont = UIFont(name: "SF-Compact-Rounded-Regular", size: 14.0)!
        segmentControl.addTarget(self, action: #selector(controlValueChanged), for: .valueChanged)
        
        //ContainerView init
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 5
        
        
        
    }
    
    var index:Int = 0
    
    @objc func controlValueChanged(_ sender: BetterSegmentedControl) {
        //print(sender.index)
        switch sender.index {
        case 0:
            //print("Introduction")
            index = 0
            
        case 1:
            //print("Details")
            index = 1
            
        case 2:
            //print("Review")
            index = 2
            
        default:
            index = 0
            //print("Introduction")
        }
        updateViews()
        
    }
    
    private func updateViews(){
        switch index {
        case 0:
            IntroductionVC.view.isHidden = false
            IntroductionVC.bookID = bookID
            DetailVC.view.isHidden = true
            ReviewVC.view.isHidden = true
        case 1:
            IntroductionVC.view.isHidden = true
            DetailVC.view.isHidden = false
            ReviewVC.view.isHidden = true
        case 2:
            IntroductionVC.view.isHidden = true
            DetailVC.view.isHidden = true
            ReviewVC.view.isHidden = false
        default:
            IntroductionVC.view.isHidden = false
            DetailVC.view.isHidden = true
            ReviewVC.view.isHidden = true
        }
        
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

extension String {
    var stringWidth: CGFloat {
        let constraintRect = CGSize(width: UIScreen.main.bounds.width, height: .greatestFiniteMagnitude)
        let boundingBox = self.trimmingCharacters(in: .whitespacesAndNewlines).boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)], context: nil)
        return boundingBox.width
    }
    
    var stringHeight: CGFloat {
        let constraintRect = CGSize(width: UIScreen.main.bounds.width, height: .greatestFiniteMagnitude)
        let boundingBox = self.trimmingCharacters(in: .whitespacesAndNewlines).boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)], context: nil)
        return boundingBox.height
    }
}
