//
//  ProfileActivePlansTVC.swift
//  MrPlanner
//
//  Created by Mohammad Gharari on 3/31/19.
//  Copyright © 2019 Mohammad Gharari. All rights reserved.
//

import UIKit

class ProfileActivePlansTVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
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
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: reuseIdentifier,
            for: indexPath)
        
        
        cell.textLabel?.text = "My Literature Books!"
        cell.layer.cornerRadius = 10 //set corner radius here
        cell.layer.borderColor = cell.backgroundColor?.cgColor  // set cell border color here
        //cell.layer.borderWidth = 2 // set border width here
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

}
