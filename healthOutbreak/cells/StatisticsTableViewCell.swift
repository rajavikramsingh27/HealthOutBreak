
//
//  StatisticsTableViewCell.swift
//  healthOutbreak
//
//  Created by iOS-Appentus on 06/April/2020.
//  Copyright © 2020 Appentus Technologies Pvt. Ltd. All rights reserved.
//

import UIKit

class StatisticsTableViewCell: UITableViewCell {
    @IBOutlet weak var imgBG:UIImageView!
    @IBOutlet weak var lblStaName:UILabel!
    @IBOutlet weak var lblStaCount:UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
