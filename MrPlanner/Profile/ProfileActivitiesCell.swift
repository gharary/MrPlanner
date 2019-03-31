//
//  ProfileActivitiesCell.swift
//  MrPlanner
//
//  Created by Mohammad Gharari on 3/31/19.
//  Copyright © 2019 Mohammad Gharari. All rights reserved.
//

import UIKit

class ProfileActivitiesCell: UITableViewCell {

    
    @IBOutlet weak var clockImg: UIImageView!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var bookNameLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
