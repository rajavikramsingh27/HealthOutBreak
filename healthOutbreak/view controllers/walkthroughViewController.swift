//  walkthroughViewController.swift
//  healthOutbreak
//  Created by Ayush Pathak on 01/04/20.
//  Copyright © 2020 Appentus Technologies Pvt. Ltd. All rights reserved.


import UIKit
class walkthroughViewController: UIViewController {
    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var nextLbl: UILabel!
    @IBOutlet weak var skipBtn: UIButton!
    @IBOutlet weak var pageControl: PageControl!
    
    var currentIndex = 0
    var arrImages:[UIImage] = [#imageLiteral(resourceName: "Group 492.png"),#imageLiteral(resourceName: "Group 491.png"),#imageLiteral(resourceName: "Group 489.png"),#imageLiteral(resourceName: "Group 493.png")]
    var arrTitles = ["Welcome HOM","Monitor your area","Track Symptoms","Global Statistics"]
    var arrSubTitles = ["Introducing a self-service tool to support, aid, and inform during any outbreak","Using live maps, public information and user reported information, HOM highlights areas of concentration for confirmed and potential cases so you  stay safe.","HOM delivers the ability to track current and past symptoms along with preventive measures and support if necessary.","With live data feeds and pattern analysis, HOM provides the latest information, verified news stories and statistics to keep you informed."]
    
    @IBOutlet weak var viewToRound:UIView!
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pageControl.numberOfPages = 4
        currentIndex = 0
        self.pageControl.currentPage = 0
        
        var arrHeightSubtitles = [CGFloat]()
        
        for string in arrSubTitles {
            arrHeightSubtitles.append(string.sizeAccordingText(self.view.frame.width-40,UIFont (name:"NunitoSans-Regular", size:17.0)!).height)
        }
        
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        collView.delegate = self
        collView.dataSource = self
        self.collView.reloadData()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var visibleRect = CGRect()
        
        visibleRect.origin = collView.contentOffset
        visibleRect.size = collView.bounds.size
        
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        
        guard let indexPath = collView.indexPathForItem(at: visiblePoint) else { return }
        
        currentIndex = indexPath.row
        if currentIndex == 3{
            nextLbl.text = "Get Started"
            self.skipBtn.setTitleColor(UIColor.clear, for: .normal)
            self.skipBtn.isUserInteractionEnabled = false
        } else {
            nextLbl.text = "Next"
            self.skipBtn.setTitleColor(hexStringToUIColor(hex: "#B9B9B9"), for: .normal)
            self.skipBtn.isUserInteractionEnabled = true
        }
        self.pageControl.currentPage = currentIndex
    }
    
    @IBAction func nextBtn(_ sender: Any) {
        if nextLbl.text == "Get Started" {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "privacyPolicyViewController") as! privacyPolicyViewController
            self.navigationController?.pushViewController(vc, animated: true)
            
            return
        }
        
        if currentIndex == 2 {
            nextLbl.text = "Get Started"
            self.skipBtn.setTitleColor(UIColor.clear, for: .normal)
            self.skipBtn.isUserInteractionEnabled = false
            collView.scrollToItem(at: IndexPath(row: currentIndex+1, section: 0), at: .right, animated: true)
            self.pageControl.currentPage = currentIndex+1
            currentIndex += 1
        } else {
            nextLbl.text = "Next"
            self.skipBtn.setTitleColor(hexStringToUIColor(hex: "#B9B9B9"), for: .normal)
            self.skipBtn.isUserInteractionEnabled = true
            collView.scrollToItem(at: IndexPath(row: currentIndex+1, section: 0), at: .right, animated: true)
            self.pageControl.currentPage = currentIndex+1
            currentIndex += 1
        }
    }
    
    @IBAction func skipBtn(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "privacyPolicyViewController") as! privacyPolicyViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}



extension walkthroughViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "walkthroughCollectionViewCell", for: indexPath) as! walkthroughCollectionViewCell
        
        cell.imageView.contentMode = .scaleAspectFit
        cell.imageView.image = arrImages[indexPath.row]
        cell.titleLbl.text = arrTitles[indexPath.row]
        cell.subTitleLbl.text = arrSubTitles[indexPath.row]
        
//        cell.heightSubtitles = cell.imageView.heightAnchor.constraint(lessThanOrEqualToConstant:120)
//        cell.heightSubtitles?.isActive = true
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:collView.frame.size.width, height:collView.frame.size.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
}





//class walkthroughViewController: UIViewController {
//    @IBOutlet weak var collView: UICollectionView!
//    @IBOutlet weak var nextLbl: UILabel!
//    @IBOutlet weak var skipBtn: UIButton!
//    @IBOutlet weak var pageControl: PageControl!
//
//    var currentIndex = 0
//    var arrImages:[UIImage] = [#imageLiteral(resourceName: "Group 492.png"),#imageLiteral(resourceName: "Group 491.png"),#imageLiteral(resourceName: "Group 489.png"),#imageLiteral(resourceName: "Group 493.png")]
//    var arrTitles = ["Welcome HOM","Monitor your area","Track Symptoms","Global Statistics"]
//    var arrSubTitles = ["Introducing a self-service tool to support, aid, and inform during any outbreak","Using live maps, public information and user reported information, HOM highlights areas of concentration for confirmed and potential cases so you  stay safe.","HOM delivers the ability to track current and past symptoms along with preventive measures and support if necessary.","With live data feeds and pattern analysis, HOM provides the latest information, verified news stories and statistics to keep you informed."]
//
//    @IBOutlet weak var viewToRound:UIView!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        self.pageControl.numberOfPages = 4
//        let visibleRect = CGRect(origin: collView.contentOffset, size: collView.bounds.size)
//        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
//        let visibleIndexPath = collView.indexPathForItem(at: visiblePoint)
//        currentIndex = visibleIndexPath!.row
//        self.pageControl.currentPage = visibleIndexPath!.row
//
//        var arrHeightSubtitles = [CGFloat]()
//
//        for string in arrSubTitles {
//            arrHeightSubtitles.append(string.sizeAccordingText(self.view.frame.width-40,UIFont (name:"NunitoSans-Regular", size:17.0)!).height)
//        }
//
//    }
//
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        var visibleRect = CGRect()
//
//        visibleRect.origin = collView.contentOffset
//        visibleRect.size = collView.bounds.size
//
//        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
//
//        guard let indexPath = collView.indexPathForItem(at: visiblePoint) else { return }
//
//        currentIndex = indexPath.row
//        if currentIndex == 3{
//            nextLbl.text = "Get Started"
//            self.skipBtn.setTitleColor(UIColor.clear, for: .normal)
//            self.skipBtn.isUserInteractionEnabled = false
//        } else {
//            nextLbl.text = "Next"
//            self.skipBtn.setTitleColor(hexStringToUIColor(hex: "#B9B9B9"), for: .normal)
//            self.skipBtn.isUserInteractionEnabled = true
//        }
//        self.pageControl.currentPage = currentIndex
//    }
//
//    @IBAction func nextBtn(_ sender: Any) {
//        if nextLbl.text == "Get Started"{
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "privacyPolicyViewController") as! privacyPolicyViewController
//            self.navigationController?.pushViewController(vc, animated: true)
//            return
//        }
//
//        if currentIndex == 2{
//            nextLbl.text = "Get Started"
//            self.skipBtn.setTitleColor(UIColor.clear, for: .normal)
//            self.skipBtn.isUserInteractionEnabled = false
//            collView.scrollToItem(at: IndexPath(row: currentIndex+1, section: 0), at: .right, animated: true)
//            self.pageControl.currentPage = currentIndex+1
//            currentIndex += 1
//        }else{
//            nextLbl.text = "Next"
//            self.skipBtn.setTitleColor(hexStringToUIColor(hex: "#B9B9B9"), for: .normal)
//            self.skipBtn.isUserInteractionEnabled = true
//            collView.scrollToItem(at: IndexPath(row: currentIndex+1, section: 0), at: .right, animated: true)
//            self.pageControl.currentPage = currentIndex+1
//            currentIndex += 1
//        }
//    }
//
//    @IBAction func skipBtn(_ sender: Any) {
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "privacyPolicyViewController") as! privacyPolicyViewController
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
//
//}
//
//
//
//extension walkthroughViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 4
//    }
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "walkthroughCollectionViewCell", for: indexPath) as! walkthroughCollectionViewCell
//
//        cell.imageView.contentMode = .scaleAspectFit
//        cell.imageView.image = arrImages[indexPath.row]
//        cell.titleLbl.text = arrTitles[indexPath.row]
//        cell.subTitleLbl.text = arrSubTitles[indexPath.row]
//
////        cell.heightSubtitles = cell.imageView.heightAnchor.constraint(lessThanOrEqualToConstant:120)
////        cell.heightSubtitles?.isActive = true
//
//        return cell
//    }
//
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width:UIScreen.main.bounds.width, height:collView.frame.size.height)
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets.zero
//    }
//}
