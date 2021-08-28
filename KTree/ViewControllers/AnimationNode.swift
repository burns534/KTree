//
//  TreeNode.swift
//  KTree(Swift)
//
//  Created by Kyle Burns on 11/13/20.
//  Copyright © 2020 Kyle Burns. All rights reserved.
//

import SpriteKit

class Link: NSObject {
    var linkNode: SKShapeNode
    var first_node: AnimationNode
    var second_node: AnimationNode
    
    init(path: CGPath, first_node: AnimationNode, second_node: AnimationNode) {
        self.linkNode = SKShapeNode(path: path)
        self.first_node = first_node
        self.second_node = second_node
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func deconfigure() {
        first_node.links.removeAll { $0 == self }
        second_node.links.removeAll { $0 == self }
        linkNode.removeFromParent()
    }
}

public class AnimationNode: SKNode, Node {
    public var parentNode: Node?
    public var left: Node?
    public var right: Node?
    public var timestamp: UInt64
    public var weight: Double
    public var usage: Double
    public var subtree: SubTree
    
    public func isEqualTo(_ node: Node?) -> Bool {
        guard let node = node as? AnimationNode else {
            return false
        }
        return node.tag == tag
    }
    
    public func isLessThan(_ node: Node?) -> Bool {
        guard let node = node as? AnimationNode else {
            return false
        }
        return tag < node.tag
    }
    
    public func isGreaterThan(_ node: Node?) -> Bool {
        guard let node = node as? AnimationNode else {
            return false
        }
        return tag > node.tag
    }
    
    public func display() {
        print("\(tag)", terminator: "")
    }
    
    public func debug() {
        
    }
        
    public var tag: Int
    var links = [Link]()
    var leftWidth: CGFloat = 0
    var rightWidth: CGFloat = 0
    
    static var maxWeight: Double = 1000
    static var heavyColor: UIColor = .red
    static var lightColor: UIColor = .blue
    static var nodeRadius: CGFloat = 20
    let circle = SKShapeNode(circleOfRadius: nodeRadius)
    let label = SKLabelNode(fontNamed: "Helvetica")
    
    public init(tag: Int) {
        // protocol initializations
        self.parentNode = nil
        self.right = nil
        self.left = nil
        self.timestamp = 0
        self.weight = 0
        self.usage = 0
        self.subtree = .none
        // animation initializations
        self.tag = tag
        super.init()
        createSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func createSubviews() {
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
            circle.fillColor = UIColor.blend(color1: .white, intensity1: 1 - ratio, color2: AnimationNode.heavyColor, intensity2: ratio)
        } else {
            circle.fillColor = UIColor.blend(color1: .white, intensity1: 1 - ratio, color2: AnimationNode.lightColor, intensity2: ratio)
        }
    }
    
    func deconfigure() {
        print("deconfiguring node", tag)
        removeFromParent()
        removeLinks()
    }
    
    func link(to node: Node?) {
        guard let node = node as? AnimationNode else { return }
        let path = CGMutablePath()
        path.move(to: position)
        path.addLine(to: node.position)
        let link = Link(path: path, first_node: self, second_node: node)
        link.linkNode.strokeColor = .black
        links.append(link)
        node.links.append(link)
        parent?.addChild(link.linkNode)
    }
    
    func removeLinks() {
        links.forEach { $0.deconfigure() }
        links = []
    }
}
