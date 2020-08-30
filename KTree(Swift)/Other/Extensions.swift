//
//  Extensions.swift
//  KTree Demo
//
//  Created by Kyle Burns on 8/12/20.
//  Copyright © 2020 Kyle Burns. All rights reserved.
//

import UIKit

extension UIImageView {
    func sizeForImageInImageViewAspectFit() -> CGSize
    {
        if let img = self.image {
            let imageRatio = img.size.width / img.size.height;

            let viewRatio = self.frame.size.width / self.frame.size.height;

            if (imageRatio < viewRatio) {
                let scale = self.frame.size.height / img.size.height

                let width = scale * img.size.width

                return CGSize(width: width, height: frame.size.height)
            } else {
                let scale = self.frame.size.width / img.size.width

                let height = scale * img.size.height

                return CGSize(width: frame.size.width, height: height);
            }
        }
        return .zero
    }
}

extension CALayer {
    func setShadow(radius: CGFloat, color: UIColor = .darkGray, opacity: Float = 0.6, offset: CGSize = .zero) {
        masksToBounds = false
        shadowRadius = radius
        shadowColor = color.cgColor
        shadowOffset = offset
        shadowOpacity = opacity
    }
    
    func prepareSublayersForShadow() {
        sublayers?.filter{ $0.frame.equalTo(self.bounds) }
            .forEach{ $0.cornerRadius = cornerRadius }
        if let contents = self.contents {
            self.contents = nil
            let contentLayer = CALayer()
            contentLayer.contents = contents
            contentLayer.frame = bounds
            contentLayer.cornerRadius = cornerRadius
            contentLayer.masksToBounds = true
            insertSublayer(contentLayer, at: 0)
        }
    }
}
extension UIView {
    func setShadow(radius: CGFloat, color: UIColor = .darkGray, opacity: Float = 0.6, offset: CGSize = .zero) {
        layer.shadowRadius = radius
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowOpacity = opacity
    }
}
// from paul hudson
extension String {
    subscript(i: Int) -> String {
        return String(self[index(startIndex, offsetBy: i)])
    }
}

extension CGSize {
    static func +(left: CGSize, right: CGSize) -> CGSize {
        return CGSize(width: left.width + right.width, height: left.height + right.height)
    }
    
    static func +=(left: inout CGSize, right: CGSize) {
        left = CGSize(width: left.width + right.width, height: left.height + right.height)
    }
    
    static func /(left: CGSize, right: Int) -> CGSize {
        let r = CGFloat(right)
        return CGSize(width: left.width / r, height: left.height / r)
    }
    
    static func -(left: CGSize, right: Int) -> CGSize {
        let r = CGFloat(right)
        return CGSize(width: left.width - r, height: left.height - r)
    }
    
    static func -=(left: inout CGSize, right: CGSize) {
        left = CGSize(width: left.width - right.width, height: left.height - right.height)
    }
    
    static prefix func -(size: CGSize) -> CGSize {
        return CGSize(width: -size.width, height: -size.height)
    }
}

extension CGPoint {
    static func +(left: CGPoint, right: CGFloat) -> CGPoint {
        return CGPoint(x: left.x + right, y: left.y + right)
    }
    static func +=(left: inout CGPoint, right: CGFloat) {
        left = CGPoint(x: left.x + right, y: left.y + right)
    }
    static func +=(left: inout CGPoint, right: CGPoint) {
        left = CGPoint(x: left.x + right.x, y: left.y + right.y)
    }
    static func -(left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x - right.x, y: left.y - right.y)
    }
    static func -(left: CGPoint, right: CGFloat) -> CGPoint {
        return CGPoint(x: left.x - right, y: left.y - right)
    }
}

// Not mine
extension UIColor {
  public convenience init(rgba: String) {
    var red:   CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue:  CGFloat = 0.0
    var alpha: CGFloat = 1.0
    
    if rgba.hasPrefix("#") {
        let index   = rgba.index(rgba.startIndex, offsetBy: 1)
        let hex     = rgba.suffix(from: index)
        let scanner = Scanner(string: String(hex))
      var hexValue: CUnsignedLongLong = 0
        if scanner.scanHexInt64(&hexValue) {
        switch (hex.count) {
        case 3:
          red   = CGFloat((hexValue & 0xF00) >> 8)       / 15.0
          green = CGFloat((hexValue & 0x0F0) >> 4)       / 15.0
          blue  = CGFloat(hexValue & 0x00F)              / 15.0
        case 4:
          red   = CGFloat((hexValue & 0xF000) >> 12)     / 15.0
          green = CGFloat((hexValue & 0x0F00) >> 8)      / 15.0
          blue  = CGFloat((hexValue & 0x00F0) >> 4)      / 15.0
          alpha = CGFloat(hexValue & 0x000F)             / 15.0
        case 6:
          red   = CGFloat((hexValue & 0xFF0000) >> 16)   / 255.0
          green = CGFloat((hexValue & 0x00FF00) >> 8)    / 255.0
          blue  = CGFloat(hexValue & 0x0000FF)           / 255.0
        case 8:
          red   = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
          green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
          blue  = CGFloat((hexValue & 0x0000FF00) >> 8)  / 255.0
          alpha = CGFloat(hexValue & 0x000000FF)         / 255.0
        default:
          print("Invalid RGB string, number of characters after '#' should be either 3, 4, 6 or 8")
        }
      } else {
        print("Scan hex error")
      }
    } else {
      print("Invalid RGB string, missing '#' as prefix")
    }
    self.init(red:red, green:green, blue:blue, alpha:alpha)
  }
}

