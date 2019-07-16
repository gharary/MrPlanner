//
//  ProfileActivePlansTVC.swift
//  MrPlanner
//
//  Created by Mohammad Gharari on 3/31/19.
//  Copyright © 2019 Mohammad Gharari. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class ProfileActivePlansTVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var programTitles:[String] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getProgramList()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        
        tableView.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }
    
    @objc func tapped() {
        
    }
    
    
    
    
    let reuseIdentifier = "ActivePlansCell"
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if programTitles.count == 0 {
            tableView.setEmptyMessage("No Plan!")
            return 0
        } else {
            tableView.restore()
            return programTitles.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: reuseIdentifier,
            for: indexPath)
        
        
        cell.textLabel?.text = programTitles[indexPath.row]
        cell.layer.cornerRadius = 10 //set corner radius here
        cell.layer.borderColor = cell.backgroundColor?.cgColor  // set cell border color here
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell:UITableViewCell = tableView.cellForRow(at: indexPath)!
        selectedCell.contentView.backgroundColor = .white
        
        UIView.animate(withDuration: 5) {
            
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
    }
    
    let cellColor: UIColor = UIColor(red: 84.0 / 255.0, green: 99.0 / 255.0, blue: 100.0/255.0, alpha: 1.0)
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cellToDeselect: UITableViewCell = tableView.cellForRow(at: indexPath)!
        cellToDeselect.contentView.backgroundColor = cellColor
    }

    
    func getProgramList() {
        let auth = ProgramService.sharedInstance.getAuthentication()
        
            let url = URL(string: "http://mrplanner.org/api/user/\(auth.userID)/programs")
            Alamofire.request(url!, method: .get, headers: auth.header).validate()
                .responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        let sCode = response.response!.statusCode
                        if sCode >= 200 && sCode <= 300 {
                            let json = JSON(value)

                            self.proceedData(json: json["data"])
                        } else {
                            print(response.error?.localizedDescription as Any)
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                        
                        
                    }
                    
        }
        
    }
    
    func proceedData(json:JSON) {
        let jsonArr = json.array!
        
        
        for item in jsonArr {
            print(item["title"].stringValue)
            programTitles.append(item["title"].stringValue)
        }
    }
}
