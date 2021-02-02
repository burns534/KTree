//
//  TreeNode.swift
//  KTree(Swift)
//
//  Created by Kyle Burns on 11/13/20.
//  Copyright © 2020 Kyle Burns. All rights reserved.
//

import SpriteKit

class Link: NSObject {
    var link_node: SKShapeNode
    var first_node: AnimationNode
    var second_node: AnimationNode
    
    init(path: CGPath, first_node: AnimationNode, second_node: AnimationNode) {
        self.link_node = SKShapeNode(path: path)
        self.first_node = first_node
        self.second_node = second_node
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func deconfigure() {
        first_node.links.removeAll { $0 == self }
        second_node.links.removeAll { $0 == self }
        link_node.removeFromParent()
    }
}

class AnimationNode: SKNode, Node {
    var parentNode: Node?
    var left: Node?
    var right: Node?
    var timestamp: UInt64
    var weight: Double
    var subTree: SubTree
    
    func isEqualTo(_ node: Node?) -> Bool {
        guard let node = node as? AnimationNode else {
            return false
        }
        return node.tag == tag
    }
    
    func isLessThan(_ node: Node?) -> Bool {
        guard let node = node as? AnimationNode else {
            return false
        }
        return tag < node.tag
    }
    
    func isGreaterThan(_ node: Node?) -> Bool {
        guard let node = node as? AnimationNode else {
            return false
        }
        return tag > node.tag
    }
    
//    static var nodeColor: UIColor = .blue
    static let nodeRadius: CGFloat = 20
/// Decays proportional to own weight and time since last feeding (measured in stamps). The decay factor represents factor of weight to be lost at the threshold.
//    static let thresholdFactor: Double = 2.0
    
    var tag: Int
    var links = [Link]()
    var stamp: Int64 = 0
    var leftWidth: CGFloat = 0
    var rightWidth: CGFloat = 0
    
    static let heavyColor = UIColor.red
    static let lightColor = UIColor.blue
    
    
    
    init(tag: Int) {
        self.tag = tag
        super.init()
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let circle = SKShapeNode(circleOfRadius: AnimationNode.nodeRadius)
    let label = SKLabelNode(fontNamed: "Helvetica")
    func configure() {
        addChild(circle)
        circle.strokeColor = .black
        label.text = "\(tag)"
        label.fontSize = AnimationNode.nodeRadius * 0.5
        label.verticalAlignmentMode = .center
        label.fontColor = .black
        addChild(label)
    }
    
    func refresh() {
        label.text = "\(tag)"
        let ratio = min(CGFloat(10000 * (abs(weight - 1.0)) / AnimationNode.maxWeight), 1.0)
        if weight > 1.0 {
            circle.fillColor = UIColor.blend(color1: .white, intensity1: 1 - ratio, color2: heavyColor, intensity2: ratio)
        } else {
            circle.fillColor = UIColor.blend(color1: .white, intensity1: 1 - ratio, color2: lightColor, intensity2: ratio)
        }
    }
    
    func deconfigure() {
        print("deconfiguring node", tag)
        removeFromParent()
        removeLinks()
    }
    
    func link(to node: AnimationNode) {
        let path = CGMutablePath()
        path.move(to: position)
        path.addLine(to: node.position)
        let link = Link(path: path, first_node: self, second_node: node)
        link.link_node.strokeColor = .black
        links.append(link)
        node.links.append(link)
        parent?.addChild(link.link_node)
    }
    
    func removeLinks() {
        links.forEach { $0.deconfigure() }
        links = []
    }
}
