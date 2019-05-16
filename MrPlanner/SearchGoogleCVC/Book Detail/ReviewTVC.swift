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
        
        readBookReview()
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

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 25
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)

        // Configure the cell...

        cell.textLabel?.text = "Good!"
        cell.detailTextLabel?.text = "This app is Perfect!"
        
        
        return cell
    }
    

    var oauthswift: OAuthSwift?
    var currentBook:Book?
    
    func readBookReview() {
    
        GoodreadsService.sharedInstance.loadBooks(sender: self) {
            (books)  in
            //self.currentBook = book
            print(books)
        }
 
    }
}
