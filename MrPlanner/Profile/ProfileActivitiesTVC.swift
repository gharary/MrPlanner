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
    
    var events = [DefaultEvent]()

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    
    override func viewDidAppear(_ animated: Bool) {
        generateRandomData()
    }
    private func generateRandomData() {
        
        events = CalendarViewVC.sharedInstance.genEvents()
        tableView.reloadData()
    }
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return events.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }

    /*
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let rowAction = UITableViewRowAction(style: .normal, title: "TestRowAction")
        return rowAction
    }
    */
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .insert:
            print("Complete")
            break
        case .delete:
            print("Deleted")
            break
        case .none:
            print("None")
        @unknown default:
            print("Default")
        }
        
    }
    func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivitiesCell", for: indexPath) as! ProfileActivitiesCell
        
        
        // Configure the cell...
        
        let i = Bool.random()
        if i {
            cell.accessoryType = .checkmark
            cell.backgroundColor = UIColor(hexString: "66B311")
        } else {
            cell.backgroundColor = UIColor(hexString: "FF6B6B")
            cell.accessoryType = .none
            
        }
        
        cell.clockImg.image = UIImage(named: "time")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        cell.timeLbl.text = dateFormatter.string(from: events[indexPath.row].startDate) + "-" +  dateFormatter.string(from: events[indexPath.row].endDate)
        
        cell.bookNameLbl.text = events[indexPath.row].title
        
        return cell
    }
    
}
extension UIColor {
    convenience init?(hexString: String) {
        var chars = Array(hexString.hasPrefix("#") ? hexString.dropFirst() : hexString[...])
        let red, green, blue, alpha: CGFloat
        switch chars.count {
        case 3:
            chars = chars.flatMap { [$0, $0] }
            fallthrough
        case 6:
            chars = ["F","F"] + chars
            fallthrough
        case 8:
            alpha = CGFloat(strtoul(String(chars[0...1]), nil, 16)) / 255
            red   = CGFloat(strtoul(String(chars[2...3]), nil, 16)) / 255
            green = CGFloat(strtoul(String(chars[4...5]), nil, 16)) / 255
            blue  = CGFloat(strtoul(String(chars[6...7]), nil, 16)) / 255
        default:
            return nil
        }
        self.init(red: red, green: green, blue:  blue, alpha: alpha)
    }
}
