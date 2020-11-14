//
//  TreeNode.swift
//  KTree(Swift)
//
//  Created by Kyle Burns on 11/13/20.
//  Copyright © 2020 Kyle Burns. All rights reserved.
//

import SpriteKit

class TreeNode: SKNode, Node {
    var parentNode: Node?
    
    var left: Node?
    
    var right: Node?
    
    func isEqualTo(_ node: Node?) -> Bool {
        guard let node = node as? TreeNode else { return false }
        return node.tag == tag
    }
    
    func isLessThan(_ node: Node?) -> Bool {
        guard let node = node as? TreeNode else { return false
        }
        return tag < node.tag
    }
    
    func isGreaterThan(_ node: Node?) -> Bool {
        guard let node = node as? TreeNode else { return false }
        return tag > node.tag
    }
    
    enum SubTree {
        case left, right, root
    }
    static var nodeRadius: CGFloat = 20
    static var nodeColor: UIColor = .blue
    static var feedFactor: Double = 0.00001
    static var maxWeight: Double = 1000
    static var midPoint: Double = 400000
// MARK: Decay Factor
/* Decays proportional to own weight and time since last feeding (measured in stamps). The decay factor represents factor of weight to be lost at the threshold */
    static var decayFactor: Double = 0.05
    static var thresholdFactor: Double = 2.0
    static let sigmoid = Sigmoid(max: TreeNode.maxWeight, mid: TreeNode.midPoint, k: TreeNode.feedFactor)
    var tag: Int
    var links: [SKShapeNode?] = []
    var leftWidth: CGFloat = 0
    var rightWidth: CGFloat = 0
    let heavyColor = UIColor.red
    let lightColor = UIColor.blue
    
    var subTree: SubTree? {
        guard let parentNode = parentNode else { return .root }
        if self.isEqualTo(parentNode.right) {
            return .right
        }
        return .left
    }
    
    var subRoot: Node? {
        if parentNode == nil { return nil }
        var result: Node = self
        if self.isEqualTo(parentNode?.left) {
            while result.parentNode != nil && result.isEqualTo(result.parentNode?.left) {
                result = result.parentNode!
            }
        } else {
            while result.parentNode != nil && result.isEqualTo(result.parentNode?.right) {
                result = result.parentNode!
            }
        }
        return result
    }
    
    var weight: Double = 1.0
    var stamp: Int64 = 0
    var stamps: Int64 = 0
    
    init(tag: Int) {
        self.tag = tag
        super.init()
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let circle = SKShapeNode(circleOfRadius: TreeNode.nodeRadius)
    let label = SKLabelNode(fontNamed: "Helvetica")
    func configure() {
        addChild(circle)
        circle.strokeColor = .black
        label.text = "\(tag)"
        label.fontSize = TreeNode.nodeRadius * 0.5
        label.verticalAlignmentMode = .center
        label.fontColor = .black
        addChild(label)
    }
    
    func refresh() {
        label.text = "\(tag)"
        let ratio = min(CGFloat(10000 * (abs(weight - 1.0)) / TreeNode.maxWeight), 1.0)
        if weight > 1.0 {
            circle.fillColor = UIColor.blend(color1: .white, intensity1: 1 - ratio, color2: heavyColor, intensity2: ratio)
        } else {
            circle.fillColor = UIColor.blend(color1: .white, intensity1: 1 - ratio, color2: lightColor, intensity2: ratio)
        }
    }
    
    func deconfigure() {
        removeFromParent()
        removeLinks()
    }
    
    func link(to node: TreeNode) {
        let path = CGMutablePath()
        path.move(to: position)
        path.addLine(to: node.position)
        let line = SKShapeNode(path: path)
        line.strokeColor = .black
        links.append(line)
        node.links.append(line)
        parent?.addChild(line)
    }
    
    func removeLinks() {
        links.forEach {
            $0?.removeFromParent()
        }
        links = []
    }

// MARK: Tree operations
    func swap(withNode node: Node?) {
        guard let node = node as? TreeNode else { return }
        var temp: Node? = nil
        
        if node.isEqualTo(node.parentNode?.left) {
            node.parentNode?.left = self
        } else if node.isEqualTo(node.parentNode?.right) {
            node.parentNode?.right = self
        }
        
        if self.isEqualTo(parentNode?.left) {
            self.parentNode?.left = node
        } else if self.isEqualTo(parentNode?.right) {
            self.parentNode?.right = node
        }
        
        temp = parentNode
        parentNode = node.parentNode
        node.parentNode = temp
        
        temp = left
        left = node.left
        node.left = temp
        
        temp = right
        right = node.right
        node.right = temp
    }
    
    func feed(stamp: Int64, nodeCount: Int) {
        let decayThreshold = TreeNode.thresholdFactor * Double(nodeCount)
        let difference = Double(stamp - self.stamp)
        let decay = difference > decayThreshold ? (TreeNode.decayFactor * weight * log(Double(difference)) / decayThreshold) : 0.0
        let growth = TreeNode.sigmoid.dx(weight)
        
//        print("weight: \(weight), decay: \(decay), growth: \(Node.sigmoid.dx(weight))")
        
        weight += growth - decay
        if weight < 0.0 { weight = 0.0 }
        self.stamp = stamp

    }
}
