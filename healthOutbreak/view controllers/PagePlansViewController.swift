//  PagePlansViewController.swift
//  healthOutbreak
//
//  Created by iOS-Appentus on 06/April/2020.
//  Copyright © 2020 Appentus Technologies Pvt. Ltd. All rights reserved.
//

import UIKit

class PagePlansViewController: UIPageViewController , UIPageViewControllerDelegate, UIPageViewControllerDataSource , UIScrollViewDelegate{
    var pages = [UIViewController]()
    var curr = Int()
    
    var last_x : CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        self.dataSource = self
        
        let page_1 = storyboard!.instantiateViewController(withIdentifier: "PlanListViewController") as! PlanListViewController
        let page_2 = storyboard!.instantiateViewController(withIdentifier: "PlanHistoryViewController") as! PlanHistoryViewController
        
        pages.append(page_1)
        pages.append(page_2)
        
        setViewControllers([page_1], direction: UIPageViewController.NavigationDirection.forward, animated: false, completion: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.move_by_buttons(_:)), name: Notification.Name("move_by_buttons_events"), object: nil)
    }
    
    @objc func move_by_buttons(_ sender:NSNotification) {
        let index = sender.object as! Int
        
        if index == 1 {
            self.setViewControllers([pages[index]], direction:.forward, animated:true, completion: nil)
        } else {
            self.setViewControllers([pages[index]], direction: .reverse, animated:true, completion: nil)
        }
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController)-> UIViewController? {
        curr = pages.firstIndex(of: viewController)!
        
        NotificationCenter.default.post(name: NSNotification.Name (rawValue:"selected_events"), object:curr)
        
        // if you prefer to NOT scroll circularly, simply add here:
        if curr == 0 { return nil }
        let prev = abs((curr - 1) % pages.count)
        return pages[prev]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController)-> UIViewController? {
        curr = pages.firstIndex(of: viewController)!
        
        NotificationCenter.default.post(name: NSNotification.Name (rawValue:"selected_events"), object:curr)
        
        if curr == (pages.count - 1) { return nil }
        let nxt = abs((curr + 1) % pages.count)
        return pages[nxt]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if (!completed)
        {
            return
        }
    }
    
    
    
}

