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
    var stackView: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    func configure(node: TreeNode) {
        tagLabel.text = "tag: \(node.tag)"
        weightLabel.text = "weight: \(node.weight)"
        stampLabel.text = "stamp: \(node.stamp)"
        stampsLabel.text = "node stamps: \(node.stamps)"
        parentLabel.text = "parent: \((node.parentNode as? TreeNode) == nil ? "" : String((node.parentNode as! TreeNode).tag))"
        leftLabel.text = "left: \((node.left as? TreeNode) == nil ? "" : String((node.left as! TreeNode).tag))"
        rightLabel.text = "right: \((node.right as? TreeNode) == nil ? "" : String((node.right as! TreeNode).tag))"

        subTreeLabel.text = "subTree: \((node.subTree == .left && node.subTree != nil) ? "left" : "right")"
        subRootLabel.text = "subRoot: \((node.subRoot as? TreeNode) == nil ? "" : String((node.subRoot as! TreeNode).tag))"
        locationLabel.text = String(format: "location: (%.2f, %.2f)", node.position.x, node.position.y)
        leftWidthLabel.text = "leftWidth: \(node.leftWidth)"
        rightWidthLabel.text = "rightWidth: \(node.rightWidth)"
        
        stackView = UIStackView(arrangedSubviews: [
            tagLabel,
            weightLabel,
            stampLabel,
            stampsLabel,
            parentLabel,
            leftLabel,
            rightLabel,
            subTreeLabel,
            subRootLabel,
            locationLabel,
            leftWidthLabel,
            rightWidthLabel
        ])
        
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .leading
        stackView.spacing = 10
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50)
        ])
    }

}
