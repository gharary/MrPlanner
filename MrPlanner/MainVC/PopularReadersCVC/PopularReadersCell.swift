//
//  PopularReadersCell.swift
//  MrPlanner
//
//  Created by Mohammad Gharari on 3/2/19.
//  Copyright © 2019 Mohammad Gharari. All rights reserved.
//

import UIKit

class PopularReadersCell: UICollectionViewCell {
    @IBOutlet weak var popularImage: UIImageView!
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.layer.cornerRadius = self.frame.height / 2
        //15//self.frame.size.width / 2
    }
    
    func setCircularImageView() {
        self.popularImage.layer.cornerRadius = 10 // CGFloat(roundf(Float(self.imageView.frame.size.width / 2.0)))
    }
    
}
