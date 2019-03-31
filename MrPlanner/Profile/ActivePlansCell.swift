//
//  ActivePlansCell.swift
//  MrPlanner
//
//  Created by Mohammad Gharari on 3/31/19.
//  Copyright © 2019 Mohammad Gharari. All rights reserved.
//

import UIKit

class ActivePlansCell: UITableViewCell {

    override func layoutSubviews() {
        super.layoutSubviews()
        
        //Your separatorLineHeight with scalefactor
        let separatorLineHeight: CGFloat = 1.5 // /UIScreen.main.scale
        
        let separator = UIView()
        
        separator.frame = CGRect(x: self.frame.origin.x,
                                 y: self.frame.size.height - separatorLineHeight,
                                 width: self.frame.size.width,
                                 height: separatorLineHeight)
        
        separator.backgroundColor = .white
        
        self.addSubview(separator)
    }

}
