//
//  UpperVC.swift
//  MrPlanner
//
//  Created by Mohammad Gharari on 3/30/19.
//  Copyright © 2019 Mohammad Gharari. All rights reserved.
//

import UIKit
import SVProgressHUD
import RealmSwift

class UpperVC: UIViewController {

    
    @IBOutlet weak var shapeStackView: UIStackView!
    @IBOutlet weak var profileImg:UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var idLbl: UILabel!
    @IBOutlet weak var bookBtn: UIButton!
    @IBOutlet weak var nameNidStack: UIStackView!
    @IBOutlet weak var bookCount: UILabel!
    
    let defaults = UserDefaults.standard
    private var bookToken: NotificationToken?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let realm = try! Realm()
        let books = realm.objects(Shelve.self)
        bookToken = books.observe { [weak self] _ in
            guard let this = self else { return }
            
            UIView.transition(with: this.bookCount,
                              duration: 0.33,
                              options: [.transitionFlipFromTop],
                              animations: {
                                this.bookCount.text = "\(books.count)"
            }, completion: nil)
            
        }
        setupUpper()
        cornerRadius()
        // Do any additional setup after loading the view.
    }
    @IBAction func logoutBtnTapped(_ sender: UIButton) {
        
        MrPlannerService.sharedInstance.isLoggedIn = .LoggedOut
        defaults.removeObject(forKey: "username")
        defaults.removeObject(forKey: "password")
        defaults.removeObject(forKey: "UserID")
        defaults.set(false, forKey: "Login")
        SVProgressHUD.showInfo(withStatus: "You have logged Out!")
    }
    
    
    
    private func setupUpper() {
        
        nameLbl.text = defaults.object(forKey: "username") as? String ?? defaults.object(forKey: "email") as? String
        idLbl.text = defaults.object(forKey: "UserID") as? String
        
        
        
        //init StackView
        let color = UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 0.50)
        shapeStackView.addBackground(color: color)
        
        
        //init profile image
        
        profileImg.clipsToBounds = true
        let shadow0 = UIView(frame: CGRect(x: 0, y: 0, width: 123, height: 123))
        shadow0.clipsToBounds = false
        shadow0.layer.shadowColor = UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 0.50).cgColor
        shadow0.layer.shadowOpacity = 0.5
        shadow0.layer.shadowOffset = CGSize(width: 0, height: 0)
        profileImg.addSubview(shadow0)
        profileImg.alpha = 1
        
    }

    
    
    private func cornerRadius() {
        profileImg.layer.cornerRadius = profileImg.frame.height / 2
        
            
    }
    
    
    
    private func setupLayout() {
        let width = self.view.frame.width * UIScreen.main.scale
        switch width {
        case 750:
            print("iPhone 8")
            profileImg.translatesAutoresizingMaskIntoConstraints = false
            profileImg.frame = CGRect(x: 0, y: 0, width: 123, height: 123)
            profileImg.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16).isActive = true
            profileImg.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 16).isActive = true
           profileImg.layer.cornerRadius = profileImg.frame.height / 2
        
            self.view.layoutIfNeeded()
            
            
        case 828:
            print("iPhone XR")
            profileImg.removeConstraints(profileImg.constraints)
            profileImg.translatesAutoresizingMaskIntoConstraints = false
            
            profileImg.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
            profileImg.layer.cornerRadius = profileImg.frame.height / 2
            profileImg.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            profileImg.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
            
            self.view.layoutIfNeeded()
            
            nameNidStack.removeConstraints(nameNidStack!.constraints)
            nameNidStack.translatesAutoresizingMaskIntoConstraints = false
            //nameNidStack.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            
            //nameNidStack.bottomAnchor.constraint(equalTo: shapeStackView.topAnchor, constant: 16).isActive = true
            
            
            
        case 1125:
            print("iPhone X, XS")
        case 1242:
            print("iPhone Plus")
        default:
            print("Width")
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
extension UIStackView {
    
    func addBackground(color: UIColor) {
        let bound = CGRect(x: 0, y: 0, width: bounds.width , height: bounds.height * 1.3)
        let subview = UIView(frame: bound)
        subview.backgroundColor = color
        subview.clipsToBounds = true
        subview.layer.cornerRadius = 10
        subview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subview, at: 0)
    }
    
}
