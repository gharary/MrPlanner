//
//  ShelfVC.swift
//  MrPlanner
//
//  Created by Mohammad Gharari on 6/4/19.
//  Copyright © 2019 Mohammad Gharari. All rights reserved.
//

import UIKit
import RealmSwift

class ShelfVC: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    
    
    let reuseIdentifier = "BookCell"
    private var shelf: Results<Shelve>?
    private var shelfToken: NotificationToken?
    
    override func viewWillAppear(_ animated: Bool) {
        let realm = try! Realm()
        shelf = realm.objects(Shelve.self)
        shelfToken = shelf!.observe { [weak self] _ in
            self?.tableView.reloadData()
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        shelfToken?.invalidate()
    }
    
    
    @IBAction func importGoodreads(_ sender: UIButton!) {
        
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

extension ShelfVC: UITableViewDelegate {
    
    
}

extension ShelfVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shelf?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) ?? UITableViewCell(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        let item = shelf![indexPath.row]
        cell.textLabel?.text = item.Book?.title
        cell.detailTextLabel?.text = item.Book?.authors.first
        return cell
    }
    
    
    
}
