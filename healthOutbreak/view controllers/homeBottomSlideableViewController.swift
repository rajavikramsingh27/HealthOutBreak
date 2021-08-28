//
//  homeBottomSlideableViewController.swift
//  healthOutbreak
//
//  Created by Ayush Pathak on 09/04/20.
//  Copyright © 2020 Appentus Technologies Pvt. Ltd. All rights reserved.
//

import UIKit
import CoreLocation

class homeBottomSlideableViewController: UIViewController {
       
    @IBOutlet weak var tablwView: UITableView!
    
    let fullView: CGFloat = 100
    var partialView: CGFloat {
        return (UIScreen.main.bounds.height/4)*3 - 100
    }
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(self.panGesture))
        gesture.delegate = self
        self.view.addGestureRecognizer(gesture)
        tablwView.delegate = self
        tablwView.dataSource = self
        self.view.backgroundColor = UIColor.clear
        
        NotificationCenter.default.addObserver(self, selector:#selector(reloadTable), name: NSNotification.Name("home"), object: nil)
    }
    
    @objc func reloadTable() {
        tablwView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            let frame = self?.view.frame
            let yComponent = self?.partialView
            self?.view.frame = CGRect(x: 0, y: yComponent!, width: frame!.width, height: frame!.height - 100)
            })
    }
    
    @IBAction func btnCurrentLocation(_ sender:UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name (rawValue:"currentLocation"), object: nil)
    }
    
    @objc func panGesture(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.view)
        let velocity = recognizer.velocity(in: self.view)
        
        let y = self.view.frame.minY
        if (y + translation.y >= fullView) && (y + translation.y <= partialView) {
            self.view.frame = CGRect(x: 0, y: y + translation.y, width: view.frame.width, height: UIScreen.main.bounds.height)
            recognizer.setTranslation(CGPoint.zero, in: self.view)
        }
        
        if recognizer.state == .ended {
            var duration =  velocity.y < 0 ? Double((y - fullView) / -velocity.y) : Double((partialView - y) / velocity.y )
            
            duration = duration > 1.3 ? 1 : duration
            
            UIView.animate(withDuration: duration, delay: 0.0, options: [.allowUserInteraction], animations: {
                if  velocity.y >= 0 {
                    self.view.frame = CGRect(x: 0, y: self.partialView, width: self.view.frame.width, height: UIScreen.main.bounds.height)
                } else {
                    self.view.frame = CGRect(x: 0, y: self.fullView, width: self.view.frame.width, height: UIScreen.main.bounds.height)
                }
                
                }, completion: { [weak self] _ in
                    if ( velocity.y < 0 ) {
                        self?.tablwView.isScrollEnabled = true
                    }
            })
        }
    }
    
    
}
extension homeBottomSlideableViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"cell", for: indexPath) as! HomeTableViewCell
        
        let newsData = newsList[indexPath.row]
        
        cell.iconImg.sd_setImage(with: URL(string:newsData.urlImage.userProfile), placeholderImage: UIImage(named:""))
        cell.descLbl.text = newsData.newsDescription
        cell.timeLbl.text = newsData.published.getElapsedInterval("yyyy-MM-dd HH:mm:ss")
        
        cell.iconImg.contentMode = .scaleAspectFill
        cell.iconImg.layer.cornerRadius = cell.iconImg.frame.size.height/2
        cell.iconImg.clipsToBounds = true
        
        cell.selectedBtn.tag = indexPath.row
        cell.selectedBtn.addTarget(self, action:#selector(selectedBtn(_:)), for:.touchUpInside)
        
        return cell
    }
    
    @objc func selectedBtn(_ sender:UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "NewsArticlsWithImage") as! NewsArticlsWithImage
        vc.newsData = newsList[sender.tag]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}



extension homeBottomSlideableViewController: UIGestureRecognizerDelegate {
    
    // Solution
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        let gesture = (gestureRecognizer as! UIPanGestureRecognizer)
        let direction = gesture.velocity(in: view).y
        
        let y = view.frame.minY
        if (y == fullView && tablwView.contentOffset.y == 0 && direction > 0) || (y == partialView) {
            tablwView.isScrollEnabled = false
        } else {
            tablwView.isScrollEnabled = true
        }
        
        return false
    }
    
}
