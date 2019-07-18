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
    
    var events = [DefaultEvent]() {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    
    override func viewDidAppear(_ animated: Bool) {
       let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        ProgramService.sharedInstance.geteventsData(completion: { (eventList) in
            self.events = eventList.filter {
                let dateItem =  formatter.string(from: $0.startDate)
                let date = formatter.string(from: Date())
                
                
                return dateItem == date
            }
            
            self.tableView.reloadData()
        })
        if events.count == 0 {
            //generateRandomData()
        }
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
        //return events.count
        if events.count == 0 {
            tableView.setEmptyMessage("No Reading Time Today. Have Fun :)")
            return 0
        } else {
            tableView.restore()
            return events.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    /*
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let rowAction = UITableViewRowAction(style: .normal, title: "TestRowAction")
        return rowAction
    }
    */
    /*
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
 
    */
    
    
    func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivitiesCell", for: indexPath) as! ProfileActivitiesCell
        
        
        // Configure the cell...
        cell.layer.cornerRadius = 10
        cell.layer.borderColor = UIColor.white.cgColor
        cell.layer.borderWidth = 2
        
        cell.clockImg.image = UIImage(named: "time")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        let hour = dateFormatter.string(from: Date())
        let hourDate = dateFormatter.date(from: hour) ?? Date()
        
        let cellHr = dateFormatter.string(from: events[indexPath.row].startDate)
        let cellHour = dateFormatter.date(from: cellHr)!
        
        if hourDate > cellHour {
            cell.backgroundColor = UIColor(hexString: "FF6B6B")
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
            cell.backgroundColor = UIColor(hexString: "66B311")
        }
        cell.timeLbl.text = dateFormatter.string(from: events[indexPath.row].startDate) + "-" +  dateFormatter.string(from: events[indexPath.row].endDate)
        
        cell.bookNameLbl.text = events[indexPath.row].title.trunc(length: 25)
        
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
extension String {
    /*
     Truncates the string to the specified length number of characters and appends an optional trailing string if longer.
     - Parameter length: Desired maximum lengths of a string
     - Parameter trailing: A 'String' that will be appended after the truncation.
     
     - Returns: 'String' object.
     */
    func trunc(length: Int, trailing: String = "…") -> String {
        return (self.count > length) ? self.prefix(length) + trailing : self
    }
}
