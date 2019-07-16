//
//  ReviewTVC.swift
//  MrPlanner
//
//  Created by Mohammad Gharari on 3/26/19.
//  Copyright © 2019 Mohammad Gharari. All rights reserved.
//

import UIKit
import Floaty
import Alamofire
import AlamofireImage
import OAuthSwift


class ReviewTVC: UITableViewController, FloatyDelegate {

    
    let reuseIdentifier = "ReviewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewDidAppear(_ animated: Bool) {
        floatingButton()
        self.view.layer.cornerRadius = 5
        GoodreadsService.sharedInstance.isLoggedIn =  AuthStorageService.readAuthToken().isEmpty ? .LoggedOut : .LoggedIn
        
    }
    
    private func floatingButton() {
        let floaty = Floaty()
        
        floaty.fabDelegate = self
        floaty.sticky = true
        self.tableView.addSubview(floaty)
    }
    
    func emptyFloatySelected(_ floaty: Floaty) {
        performSegue(withIdentifier: "addReview", sender: self)
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    let noData: Bool = true
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if noData {
            self.tableView.setEmptyMessage("No Data!")
            return 0
        } else {
            self.tableView.restore()
        }
        
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)

        // Configure the cell...

        cell.textLabel?.text = "Good!"
        cell.detailTextLabel?.text = "This app is Perfect!"
        
        
        return cell
    }
    
    
}
extension UITableView {
    
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel;
        self.separatorStyle = .none;
    }
    
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}
extension UICollectionView {
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel;
        //self.separatorStyle = .none;
    }
    
    func restore() {
        self.backgroundView = nil
        //self.separatorStyle = .singleLine
    }
}
