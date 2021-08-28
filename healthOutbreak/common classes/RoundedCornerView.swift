//  RoundedCornerView.swift
//  healthOutbreak
//  Created by Ayush Pathak on 01/04/20.
//  Copyright © 2020 Appentus Technologies Pvt. Ltd. All rights reserved.


import Foundation
import UIKit


@IBDesignable
class RoundedCornerView: UIView {
    @IBInspectable var cornerRadius: CGFloat = 45 {
        didSet {
            self.layer.cornerRadius = cornerRadius
            if #available(iOS 11.0, *) {
                self.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMinXMaxYCorner]
            }
        }
    }
}

@IBDesignable
class RoundedTop: UIView {
    @IBInspectable var cornerRadius: CGFloat = 45 {
        didSet {
            self.layer.cornerRadius = cornerRadius
            if #available(iOS 11.0, *) {
                self.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMinXMaxYCorner]
                self.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
            }
        }
    }
}


//{
//
//    var cornerRadiusValue : CGFloat = 0
//    var corners : UIRectCorner = []
//
//    @IBInspectable public var cornerRadius : CGFloat {
//        get {
//            return cornerRadiusValue
//        }
//        set {
//            cornerRadiusValue = newValue
//        }
//    }
//
//    @IBInspectable public var topLeft : Bool {
//        get {
//            return corners.contains(.topLeft)
//        }
//        set {
//            setCorner(newValue: newValue, for: .topLeft)
//        }
//    }
//
//    @IBInspectable public var topRight : Bool {
//        get {
//            return corners.contains(.topRight)
//        }
//        set {
//            setCorner(newValue: newValue, for: .topRight)
//        }
//    }
//
//    @IBInspectable public var bottomLeft : Bool {
//        get {
//            return corners.contains(.bottomLeft)
//        }
//        set {
//            setCorner(newValue: newValue, for: .bottomLeft)
//        }
//    }
//
//    @IBInspectable public var bottomRight : Bool {
//        get {
//            return corners.contains(.bottomRight)
//        }
//        set {
//            setCorner(newValue: newValue, for: .bottomRight)
//        }
//    }
//
//    func setCorner(newValue: Bool, for corner: UIRectCorner) {
//        if newValue {
//            addRectCorner(corner: corner)
//        } else {
//            removeRectCorner(corner: corner)
//        }
//    }
//
//    func addRectCorner(corner: UIRectCorner) {
//        corners.insert(corner)
//        updateCorners()
//    }
//
//    func removeRectCorner(corner: UIRectCorner) {
//        if corners.contains(corner) {
//            corners.remove(corner)
//            updateCorners()
//        }
//    }
//
//    func updateCorners() {
//        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: cornerRadiusValue, height: cornerRadiusValue))
//        let mask = CAShapeLayer()
//        mask.path = path.cgPath
//        self.layer.mask = mask
//    }
//
//}

@IBDesignable
class CornerView: UIView {

    @IBInspectable var leftTopRadius : CGFloat = 0{
        didSet{
            self.applyMask()
        }
    }
    @IBInspectable var rightTopRadius : CGFloat = 0{
        didSet{
            self.applyMask()
        }
    }
    @IBInspectable var rightBottomRadius : CGFloat = 0{
        didSet{
            self.applyMask()
        }
    }

    @IBInspectable var leftBottomRadius : CGFloat = 0{
        didSet{
            self.applyMask()
        }
    }


    override func layoutSubviews() {
        super.layoutSubviews()
        self.applyMask()
    }

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    /*override func draw(_ rect: CGRect) {
        super.draw(rect)

    }*/

    func applyMask()
    {
        let shapeLayer = CAShapeLayer(layer: self.layer)
        shapeLayer.path = self.pathForCornersRounded(rect:self.bounds).cgPath
        shapeLayer.frame = self.bounds
        shapeLayer.masksToBounds = true
        self.layer.mask = shapeLayer
    }

    func pathForCornersRounded(rect:CGRect) ->UIBezierPath
    {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0 + leftTopRadius , y: 0))
        path.addLine(to: CGPoint(x: rect.size.width - rightTopRadius , y: 0))
        path.addQuadCurve(to: CGPoint(x: rect.size.width , y: rightTopRadius), controlPoint: CGPoint(x: rect.size.width, y: 0))
        path.addLine(to: CGPoint(x: rect.size.width , y: rect.size.height - rightBottomRadius))
        path.addQuadCurve(to: CGPoint(x: rect.size.width - rightBottomRadius , y: rect.size.height), controlPoint: CGPoint(x: rect.size.width, y: rect.size.height))
        path.addLine(to: CGPoint(x: leftBottomRadius , y: rect.size.height))
        path.addQuadCurve(to: CGPoint(x: 0 , y: rect.size.height - leftBottomRadius), controlPoint: CGPoint(x: 0, y: rect.size.height))
        path.addLine(to: CGPoint(x: 0 , y: leftTopRadius))
        path.addQuadCurve(to: CGPoint(x: 0 + leftTopRadius , y: 0), controlPoint: CGPoint(x: 0, y: 0))
        path.close()

        return path
    }

}
@IBDesignable
class RoundButton: UIButton {

    @IBInspectable var cornerRadius: CGFloat = 0{
        didSet{
        self.layer.cornerRadius = cornerRadius
        }
    }

    @IBInspectable var borderWidth: CGFloat = 0{
        didSet{
            self.layer.borderWidth = borderWidth
        }
    }

    @IBInspectable var borderColor: UIColor = UIColor.clear{
        didSet{
            self.layer.borderColor = borderColor.cgColor
        }
    }
}

extension UITextField {
   @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
}
