//
//  ViewNodeDetailViewController.swift
//  KTree(Swift)
//
//  Created by Kyle Burns on 8/21/20.
//  Copyright © 2020 Kyle Burns. All rights reserved.
//

import UIKit

class ViewNodeDetailViewController: UIViewController {
    
    var tagLabel = UILabel()
    var weightLabel = UILabel()
    var stampLabel = UILabel()
    var totalStampsLabel = UILabel()
    var stampsLabel = UILabel()
    var parentLabel = UILabel()
    var leftLabel = UILabel()
    var rightLabel = UILabel()
    var depthLabel = UILabel()
    var subTreeLabel = UILabel()
    var subRootLabel = UILabel()
    var locationLabel = UILabel()
    var leftWidthLabel = UILabel()
    var rightWidthLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
    }
    
    func configure(node: ViewNode) {
        tagLabel.text = "node: \(node.tag)"
        view.addSubview(tagLabel)
        weightLabel.text = "weight: \(node.weight)"
        view.addSubview(weightLabel)
        stampLabel.text = "stamp: \(node.stamp)"
        view.addSubview(stampLabel)
        totalStampsLabel.text = "total stamps: \(Node.totalStamps)"
        view.addSubview(totalStampsLabel)
        stampsLabel.text = "node stamps: \(node.stamps)"
        view.addSubview(stampsLabel)
        parentLabel.text = "parent: \((node.parent as? ViewNode) == nil ? "" : String((node.parent as! ViewNode).tag))"
        view.addSubview(parentLabel)
        leftLabel.text = "left: \((node.left as? ViewNode) == nil ? "" : String((node.left as! ViewNode).tag))"
        view.addSubview(leftLabel)
        rightLabel.text = "right: \((node.right as? ViewNode) == nil ? "" : String((node.right as! ViewNode).tag))"
        view.addSubview(rightLabel)
        depthLabel.text = "depth: \(node.depth)"
        view.addSubview(depthLabel)
        subTreeLabel.text = "subTree: \((node.subTree == .left && node.subTree != nil) ? "left" : "right")"
        view.addSubview(subTreeLabel)
        subRootLabel.text = "subRoot: \((node.subRoot as? ViewNode) == nil ? "" : String((node.subRoot as! ViewNode).tag))"
        view.addSubview(subRootLabel)
        locationLabel.text = "location: (\(node.location?.x ?? 0), \(node.location?.y ?? 0))"
        view.addSubview(locationLabel)
        leftWidthLabel.text = "leftWidth: \(node.leftWidth)"
        view.addSubview(leftWidthLabel)
        rightWidthLabel.text = "rightWidth: \(node.rightWidth)"
        view.addSubview(rightWidthLabel)
        
        var y = 10
        view.subviews.forEach { subview in
            subview.frame = CGRect(x: 20, y: y, width: 200, height: 30)
            y += 40
        }
    }

}
