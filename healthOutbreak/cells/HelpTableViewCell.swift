



//
//  HelpTableViewCell.swift
//  healthOutbreak
//
//  Created by iOS-Appentus on 15/April/2020.
//  Copyright © 2020 Appentus Technologies Pvt. Ltd. All rights reserved.
//

import UIKit

class HelpTableViewCell: UITableViewCell {
    @IBOutlet weak var lblName:UILabel!
    @IBOutlet weak var lblLocation:UILabel!
    @IBOutlet weak var lblNumber:UILabel!
    @IBOutlet weak var btnCall:UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
