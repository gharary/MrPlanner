//
//  LeadersBooksVC.swift
//  MrPlanner
//
//  Created by Mohammad Gharari on 6/18/19.
//  Copyright © 2019 Mohammad Gharari. All rights reserved.
//

import UIKit
import SVProgressHUD

private let reuseIdentifier = "BookCell"

class LeadersBooksVC: UICollectionViewController {

    
    
    var leaderID:String = ""
    private var goodReadsBook : [Book] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        loadBooks(LeaderID: leaderID)

        // Do any additional setup after loading the view.
    }
    
    private func loadBooks(LeaderID:String) {
        SVProgressHUD.showProgress(0.2, status: "Loading...")
        DispatchQueue.main.async {
           
            
            GoodreadsService.sharedInstance.loadLeadersBooks(sender: self, passID: LeaderID, completion: { (books) in
                self.goodReadsBook = books
                SVProgressHUD.showSuccess(withStatus: "Finished!")
                self.collectionView.reloadData()
                SVProgressHUD.dismiss()
            
            })
            SVProgressHUD.dismiss()
        }
    }

    @IBAction func returnBackBtn(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return goodReadsBook.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SearchResultCell
    
        // Configure the cell
        
        let item = goodReadsBook[indexPath.row]
        cell.titleLbl.text = item.title
        cell.authorLbl.text = item.author.name
        if !item.imageUrl.isEmpty {
            let url:URL! = URL(string: item.imageUrl)
            cell.bookImage.kf.indicatorType = .activity
            cell.bookImage.kf.setImage(with: url)
        }
        
        return cell
    }

    
    
    let columns: CGFloat = 3
    let inset: CGFloat = 8.0
    let spacing: CGFloat = 8.0
    let lineSpacing: CGFloat = 8.0
    

}
extension LeadersBooksVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = Int((collectionView.frame.width / columns) - (inset + spacing))
        //let height = Int(collectionView.frame.height / columns)
        
        //let height = 138 - width + (inset + spacing))
        return CGSize(width: width, height: width * 2)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return lineSpacing
    }
    
}
