//
//  SearchResultCell.swift
//  MrPlanner
//
//  Created by Mohammad Gharari on 3/10/19.
//  Copyright © 2019 Mohammad Gharari. All rights reserved.
//

import UIKit
import JonContextMenu

class SearchResultCell: UICollectionViewCell {
    
    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var authorLbl: UILabel!
    @IBOutlet weak var checkMarkView: CheckMarkView!
    
    
    override var bounds: CGRect {
        didSet {
            self.layoutIfNeeded()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.bookImage.layer.masksToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.setCircularImageView()
    }
    
    
    func setCircularImageView() {
        self.bookImage.layer.cornerRadius = 5 
    }
    
    
}

    

    

