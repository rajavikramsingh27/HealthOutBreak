
//  NewsArticlsWithOutImage.swift
//  healthOutbreak
//
//  Created by iOS-Appentus on 04/April/2020.
//  Copyright © 2020 Appentus Technologies Pvt. Ltd. All rights reserved.
//

import UIKit

class NewsArticlsWithOutImage: UIViewController {
    var newsData:NewsList!
    
    @IBOutlet weak var titleLbl:UILabel!
    @IBOutlet weak var timeLbl:UILabel!
    @IBOutlet weak var descLbl:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLbl.text = newsData.title
        descLbl.text = newsData.content
        let strNewsDate = newsData.published.dateFromString("yyyy-MM-dd HH:mm:ss").dateToString("dd MMMM yyyy")
        
        timeLbl.text = "\(strNewsDate) | \(newsData.source)"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @IBAction func btnReadMore(_ sender:UIButton) {
        UIApplication.shared.open(URL(string:newsData.url)!, options:[:]) { (thanks) in
            
        }
        
//        let readMoreVC = storyboard?.instantiateViewController(withIdentifier:"ReadMoreViewController") as! ReadMoreViewController
//        readMoreVC.strTitle = newsData.title
//        readMoreVC.urlReadMore = newsData.url
//        navigationController?.pushViewController(readMoreVC, animated: true)
    }
    
    @IBAction func btnBack(_ sender:UIButton) {
        navigationController?.popViewController(animated:true)
    }

}
