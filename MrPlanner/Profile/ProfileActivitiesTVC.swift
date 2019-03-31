//
//  ProfileActivitiesTVC.swift
//  MrPlanner
//
//  Created by Mohammad Gharari on 3/31/19.
//  Copyright © 2019 Mohammad Gharari. All rights reserved.
//

import UIKit

class ProfileActivitiesTVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 36
    }
    
    var test: String = "test"

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivitiesCell", for: indexPath) as! ProfileActivitiesCell
        
        
        // Configure the cell...
        
        let i = Bool.random()
        if i {cell.accessoryType = .checkmark } else { cell.accessoryType = .none}
        cell.clockImg.image = UIImage(named: "time")
        cell.timeLbl.text = "14:00 - 15:00"
        cell.bookNameLbl.text = "Traction"
        return cell
    }
    
}
