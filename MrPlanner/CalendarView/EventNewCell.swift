//
//  EventNewCell.swift
//  MrPlanner
//
//  Created by Mohammad Gharari on 5/25/19.
//  Copyright © 2019 Mohammad Gharari. All rights reserved.
//

import UIKit
import JZCalendarWeekView

class EventNewCell: UICollectionViewCell {
    
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var pageLabel: UILabel!
    
    var event: DefaultEvent!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupBasic()
    }
    
    func setupBasic() {
        self.clipsToBounds = true
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 5
        layer.shadowOpacity = 0
        pageLabel.font = UIFont.systemFont(ofSize: 9)
        titleLabel.font = UIFont.systemFont(ofSize: 11, weight: .medium)
        titleLabel.text = titleLabel.text?.trunc(length: 15)
        self.backgroundColor = UIColor(hex: 0xEEF7FF)
        //borderView.backgroundColor = UIColor(hex: 0x0899FF)
    }
    
    func configureCell(event: DefaultEvent) {
        self.event = event
        pageLabel.text = event.page
        titleLabel.text = event.title
    }
    
}
