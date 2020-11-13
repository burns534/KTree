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
    var subTreeLabel = UILabel()
    var subRootLabel = UILabel()
    var locationLabel = UILabel()
    var leftWidthLabel = UILabel()
    var rightWidthLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    func configure(node: TreeNode) {
        tagLabel.text = "node: \(node.tag)"
        view.addSubview(tagLabel)
        weightLabel.text = "weight: \(node.weight)"
        view.addSubview(weightLabel)
        stampLabel.text = "stamp: \(node.stamp)"
        view.addSubview(stampLabel)
//        totalStampsLabel.text = "total stamps: \(Node.totalStamps)"
        view.addSubview(totalStampsLabel)
        stampsLabel.text = "node stamps: \(node.stamps)"
        view.addSubview(stampsLabel)
        parentLabel.text = "parent: \((node.parentNode as? TreeNode) == nil ? "" : String((node.parentNode as! TreeNode).tag))"
        view.addSubview(parentLabel)
        leftLabel.text = "left: \((node.left as? TreeNode) == nil ? "" : String((node.left as! TreeNode).tag))"
        view.addSubview(leftLabel)
        rightLabel.text = "right: \((node.right as? TreeNode) == nil ? "" : String((node.right as! TreeNode).tag))"
        view.addSubview(rightLabel)

        subTreeLabel.text = "subTree: \((node.subTree == .left && node.subTree != nil) ? "left" : "right")"
        view.addSubview(subTreeLabel)
        subRootLabel.text = "subRoot: \((node.subRoot as? TreeNode) == nil ? "" : String((node.subRoot as! TreeNode).tag))"
        view.addSubview(subRootLabel)
        locationLabel.text = String(format: "location: (%.2f, %.2f)", node.position.x, node.position.y)
        view.addSubview(locationLabel)
        leftWidthLabel.text = "leftWidth: \(node.leftWidth)"
        view.addSubview(leftWidthLabel)
        rightWidthLabel.text = "rightWidth: \(node.rightWidth)"
        view.addSubview(rightWidthLabel)
        
        var y = 10
        view.subviews.forEach { subview in
            subview.frame = CGRect(x: 20, y: y, width: 350, height: 30)
            y += 40
        }
    }

}
