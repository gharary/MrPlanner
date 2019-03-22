//
//  PopularBookCVC.swift
//  MrPlanner
//
//  Created by Mohammad Gharari on 3/2/19.
//  Copyright © 2019 Mohammad Gharari. All rights reserved.
//

import UIKit

private let reuseIdentifier = "BookCell"

class PopularBookCVC: UICollectionViewController {

    let columns: CGFloat = 3.5
    let inset: CGFloat = 8.0
    let spacing: CGFloat = 20.0
    let lineSpacing:CGFloat = 8.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Do any additional setup after loading the view.
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
        return 50
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PopularBookCell
    
        // Configure the cell
        
        cell.bookImage.image = UIImage(named: "Traction")
        
        cell.titleLbl.text = "Traction"
        cell.authorLbl.text = "Gabriel Weinberg"
        
        cell.titleLbl.textColor = UIColor(red: 0.33, green: 0.39, blue: 0.47, alpha: 1)
        cell.authorLbl.textColor = UIColor(red: 0.85, green: 0.86, blue: 0.89, alpha: 1)
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "BookDetailVC", sender: nil)
        
    }
    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "BookDetailVC" {
            let vc = segue.destination as! BookDetailVC
            let cell = sender as! UICollectionViewCell
            
            if let indexPath = self.collectionView.indexPath(for: cell) {
                
                
                /*
                vc.bookImage = searchData?[indexPath.row].image ?? ""
                vc.booktitle = searchData?[indexPath.row].title ?? "No title"
                vc.bookAuthor = searchData?[indexPath.row].author ?? "No Author"
                vc.bookID = searchData[indexPath.row].id ?? ""
                vc.averageRating = searchData[indexPath.row].avgRating ?? ""
                 */
            }
 
        }
    }
    

}
extension PopularBookCVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width / columns, height: collectionView.frame.size.height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
