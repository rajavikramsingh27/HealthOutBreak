//  PlanListTableViewCell.swift
//  healthOutbreak
//  Created by iOS-Appentus on 06/April/2020.
//  Copyright © 2020 Appentus Technologies Pvt. Ltd. All rights reserved.

import UIKit

class PlanListTableViewCell: UITableViewCell {
    @IBOutlet weak var btnSelect:UIButton!
    
    @IBOutlet weak var lblFrom:UILabel!
    @IBOutlet weak var lblTo:UILabel!
    @IBOutlet weak var lblStartDate:UILabel!
    @IBOutlet weak var lblEndDate:UILabel!
    @IBOutlet weak var lblplace_stay:UILabel!
    @IBOutlet weak var btnPurpose:UIButton!
    @IBOutlet weak var widhtPurpose:NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
