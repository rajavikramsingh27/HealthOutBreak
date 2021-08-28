//
//  HomeTableViewCell.swift
//  healthOutbreak
//
//  Created by iOS-Appentus on 04/April/2020.
//  Copyright © 2020 Appentus Technologies Pvt. Ltd. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    @IBOutlet weak var iconImg:UIImageView!
    @IBOutlet weak var descLbl:UILabel!
    @IBOutlet weak var timeLbl:UILabel!
    @IBOutlet weak var selectedBtn:UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
