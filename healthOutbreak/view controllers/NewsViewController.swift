//  NewsViewController.swift
//  healthOutbreak
//  Created by iOS-Appentus on 04/April/2020.
//  Copyright © 2020 Appentus Technologies Pvt. Ltd. All rights reserved.


import UIKit
import SwiftMessageBar


class NewsViewController: UIViewController {
    @IBOutlet weak var collNews:UICollectionView!
    @IBOutlet weak var tblNews:UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        let layout = PagingCollectionViewLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left:15, bottom: 0, right:15)
        let size = collNews.frame.size
        layout.itemSize = CGSize(width:size.width-50, height:size.height-20)
        layout.minimumLineSpacing = 10
        collNews.collectionViewLayout = layout
        collNews.isPagingEnabled = true
        
        news()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @IBAction func btnBack(_ sender:UIButton) {
        navigationController?.popViewController(animated:true)
    }
    
    func news() {
        showLoader()
        APIFunc.getAPI("news", [:]) { (json,status, message) in
            DispatchQueue.main.async {
                self.dismissLoader()
                
                if json.dictionaryObject == nil {
                    return
                }
                let status = return_status(json.dictionaryObject!)
                
                switch status {
                case .success:
                    let decoder = JSONDecoder()
                    if let jsonData = json[result_resp].description.data(using: .utf8) {
                        do {
                            newsList = try decoder.decode([NewsList].self, from: jsonData)
                            
                            self.collNews.reloadData()
                            self.tblNews.reloadData()
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                case .fail:
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.3, execute: {
                        SwiftMessageBar.showMessage(withTitle: "Error", message:message, type:.error)
                    })
                case .error_from_api:
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.3, execute: {
                        SwiftMessageBar.showMessage(withTitle: "Error", message:"\(json["Error from API"])", type:.error)
                    })
                }
            }
        }
        
    }
}



extension NewsViewController:UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collNews.frame.size
        return CGSize(width:size.width-50, height:size.height-20)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collNews.dequeueReusableCell(withReuseIdentifier:"cell", for: indexPath) as! NewsCollectionViewCell
        
        let newsData = newsList[indexPath.row]
        cell.iconImg.sd_setImage(with: URL(string:newsData.urlImage.userProfile), placeholderImage: UIImage(named:""))
        cell.descLbl.text = newsData.title
        
        let strNewsDate = newsData.published.dateFromString("yyyy-MM-dd HH:mm:ss").dateToString("dd MMMM yyyy")
        cell.timeLbl.text = "\(strNewsDate) | \(newsData.source)"
        
        cell.btnSelect.tag = indexPath.row
        cell.btnSelect.addTarget(self, action:#selector(btnSelect(_:)), for:.touchUpInside)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "NewsArticlsWithImage") as! NewsArticlsWithImage
        vc.newsData = newsList[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func btnSelect(_ sender:UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "NewsArticlsWithImage") as! NewsArticlsWithImage
        vc.newsData = newsList[sender.tag]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension NewsViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"cell", for:indexPath) as! NewsTableViewCell
        
        let newsData = newsList[indexPath.row]
        cell.iconImg.sd_setImage(with: URL(string:newsData.urlImage.userProfile), placeholderImage: UIImage(named:""))
        cell.descLbl.text = newsData.title
        
        let strNewsDate = newsData.published.dateFromString("yyyy-MM-dd HH:mm:ss").dateToString("dd MMMM yyyy")
        cell.timeLbl.text = "\(strNewsDate) | \(newsData.source)"
        
        cell.selectButton.tag = indexPath.row
        cell.selectButton.addTarget(self, action:#selector(selectButton(_:)), for:.touchUpInside)
        
        if indexPath.row > 1 {
            cell.widthIconImg.constant = 0
            cell.leadIconImg.constant = 0
        } else {
            cell.widthIconImg.constant = 80
            cell.leadIconImg.constant = 20
        }
        
        return cell
    }
    
    @IBAction func selectButton(_ sender:UIButton) {
        if sender.tag > 1 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "NewsArticlsWithOutImage") as! NewsArticlsWithOutImage
            vc.newsData = newsList[sender.tag]
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "NewsArticlsWithImage") as! NewsArticlsWithImage
            vc.newsData = newsList[sender.tag]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
