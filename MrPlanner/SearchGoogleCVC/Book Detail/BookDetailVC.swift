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



class BookDetailVC: UIViewController {

    @IBOutlet weak var bookTitleLbl: UILabel!
    @IBOutlet weak var bookAuthorLbl: UILabel!
    @IBOutlet weak var bookDescLbl: UILabel!
    @IBOutlet weak var bookImg: UIImageView!
    @IBOutlet weak var addedToShelfTimeLbl: UILabel!
    @IBOutlet weak var starsCosmos: CosmosView!
    @IBOutlet weak var addToShelfBtn: UIButton!
    @IBOutlet weak var segmentControl: BetterSegmentedControl!
    @IBOutlet weak var containerView: UIView!
    
    var booktitle: String = ""
    var bookAuthor: String = ""
    var bookDesc : String = ""
    var bookImage: String = ""
    var bookID:String = ""
    var averageRating:String = ""
    
    var segueString:String = ""
    
    lazy var IntroductionVC: IntroductionVC = {
        
        
        let storyboard = UIStoryboard(name: "GoogleSearchCollectionResult", bundle: Bundle.main)
        
        var viewController = storyboard.instantiateViewController(withIdentifier: "IntroductionVC") as! IntroductionVC
        viewController.bookID = self.bookID
        self.addViewControllerAsChildViewController(childViewController: viewController)
        
        return viewController
    }()
    
    lazy var DetailVC: DetailVC = {
        let storyboard = UIStoryboard(name: "GoogleSearchCollectionResult", bundle: Bundle.main)
        
        var viewController = storyboard.instantiateViewController(withIdentifier: "DetailVC") as! DetailVC
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
    //@IBOutlet weak var cate
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkSegue()
        initStart()
        // Do any additional setup after loading the view.
        loadData()
        updateViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //print(bookID)
    }
    
    private func checkSegue() {
        switch segueString {
        case "BookDetailVC":
             navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(addTapped))
             
        case "bookDetail":
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(addTapped))
            
        default:
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(addTapped))
        }
    }
    
    @objc func addTapped(){
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func loadData() {
        bookTitleLbl.text = booktitle
        bookAuthorLbl.text = bookAuthor
        //bookDescLbl.text = bookDesc
        
        let replace = bookImage.replacingOccurrences(of: "http", with: "https")
        let url:URL!  = URL(string: replace)
        bookImg.kf.indicatorType = .activity
        
        bookImg.kf.setImage(with: url, options: [.transition(.fade(0.2))])
        
    }

    func initStart() {
        starsCosmos.settings.filledImage = UIImage(named: "star-solid")
        starsCosmos.settings.emptyImage = UIImage(named: "star-regular")
        starsCosmos.settings.fillMode = .precise
        starsCosmos.settings.updateOnTouch = false
        starsCosmos.rating = Double(averageRating) ?? 0
        
        //button init
        addToShelfBtn.clipsToBounds = true
       
        let shadow0 = UIView(frame: CGRect(x: 0, y: 0, width: 130, height: 40))
        shadow0.clipsToBounds = false
        shadow0.layer.shadowColor = UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 0.10).cgColor
        shadow0.layer.shadowOpacity = 0.1
        shadow0.layer.shadowOffset = CGSize(width: 0, height: 0)
        addToShelfBtn.addSubview(shadow0)
        addToShelfBtn.layer.cornerRadius = 15
        addToShelfBtn.backgroundColor = UIColor(red: 0.11, green: 0.82, blue: 0.63, alpha: 1)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
