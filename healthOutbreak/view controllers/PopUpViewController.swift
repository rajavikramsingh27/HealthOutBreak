//  PopUpViewController.swift
//  healthOutbreak
//  Created by iOS-Appentus on 03/April/2020.
//  Copyright © 2020 Appentus Technologies Pvt. Ltd. All rights reserved.



protocol PopUpDelegate {
    func dontAllowPermission()
    func allowPermission()
}

import UIKit

class PopUpViewController: UIViewController {
    @IBOutlet weak var containerView:UIView!
    @IBOutlet weak var titleLbl:UILabel!
    @IBOutlet weak var descLbl:UILabel!
    @IBOutlet weak var headerImg:UIImageView!
    
    var delegate:PopUpDelegate?
    
    var arrDetails = [Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showAnimate()
        
        headerImg.image = arrDetails[0] as? UIImage
        titleLbl.text = arrDetails[1] as? String
        descLbl.text = arrDetails[2] as? String
        
        
        containerView.layer.cornerRadius = 18
        containerView.clipsToBounds = true
    }
    
    @IBAction func dontAllowPermission(_ sender:UIButton) {
        removeAnimate()
        delegate?.dontAllowPermission()
    }
    
    @IBAction func allowPermission(_ sender:UIButton) {
        removeAnimate()
        delegate?.allowPermission()
        
    }
    
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }

    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0
        }, completion: {(finished : Bool) in
            if(finished)
            {
                self.willMove(toParent: nil)
                self.view.removeFromSuperview()
                self.removeFromParent()
            }
        })
    }
}
