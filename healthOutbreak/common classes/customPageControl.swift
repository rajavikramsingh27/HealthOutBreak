//
//  customPageControl.swift
//  Teesas
//
//  Created by Ayush Pathak on 02/03/20.
//  Copyright © 2020 Appentus Technologies Pvt. Ltd. All rights reserved.
//

import Foundation
import UIKit

class PageControl: UIStackView {

    @IBInspectable var currentPageImage: UIImage = #imageLiteral(resourceName: "selectedPage.png")
    @IBInspectable var pageImage: UIImage = #imageLiteral(resourceName: "unselectedPage.png")
    /**
     Sets how many page indicators will show
     */
    var numberOfPages = 3 {
        didSet {
            layoutIndicators()
        }
    }
    /**
     Sets which page indicator will be highlighted with the **currentPageImage**
     */
    var currentPage = 0 {
        didSet {
            setCurrentPageIndicator()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        axis = .horizontal
        distribution = .fillEqually
        alignment = .fill
        spacing = 8

        layoutIndicators()
    }

    private func layoutIndicators() {

        for i in 0..<numberOfPages {

            let imageView: UIImageView

            
            if i < arrangedSubviews.count {
                imageView = arrangedSubviews[i] as! UIImageView // reuse subview if possible
            } else {
                imageView = UIImageView()
                addArrangedSubview(imageView)
            }

            if i == currentPage {
                imageView.image = currentPageImage
            } else {
                imageView.image = pageImage
            }
            imageView.contentMode = .scaleAspectFit
        }

        // remove excess subviews if any
        let subviewCount = arrangedSubviews.count
        if numberOfPages < subviewCount {
            for _ in numberOfPages..<subviewCount {
                arrangedSubviews.last?.removeFromSuperview()
            }
        }
    }

    private func setCurrentPageIndicator() {

        for i in 0..<arrangedSubviews.count {

            let imageView = arrangedSubviews[i] as! UIImageView

            if i == currentPage {
                imageView.image = currentPageImage
            } else {
                imageView.image = pageImage
            }
        }
    }
}
