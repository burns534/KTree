//
//  AnimationTree.swift
//  KTree(Swift)
//
//  Created by Kyle Burns on 8/17/20.
//  Copyright © 2020 Kyle Burns. All rights reserved.
//

import UIKit
import SpriteKit

class AnimationTree: KTree {
    var nodes = [TreeNode]()
    let verticalStep: CGFloat = 15.0
    let horizontalStep: CGFloat = 15.0
    private var totalStamps: Int64 = 0
    
    var isAnimating: Bool = false
    
    static var treeEdgeInsets: UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    var step: CGSize {
        CGSize(width: verticalStep + 2 * TreeNode.nodeRadius, height: horizontalStep + 2 * TreeNode.nodeRadius)
    }
    
    var treeNode: SKNode
    
    init(treeNode: SKNode) {
        self.treeNode = treeNode
// MARK: Need to change the way the sigmoid works. The derivative isn't the answer to the issue. I would need to take the integral of the derivative which is just the orginal function of weight. Need to handle it on the decay side rather than sigmoid side.
        print(TreeNode.sigmoid.dx(1000.0))
    }
    
    func insert(tag: Int) {
        let newNode = TreeNode(tag: tag)
        newNode.zPosition = 0.1
        if insert(node: newNode, parentNode: root, depth: 0) {
            treeNode.addChild(newNode)
            nodes.append(newNode)
            count += 1
            correctTree()
//            newNode.correct { offset in
//                guard let offset = offset else { return }
//                self.adjustTree(offset: offset)
//            }
        }
    }
    
    func delete(node: TreeNode) {
        node.deconfigure()
        nodes.removeAll { $0 == node }
        super.delete(node: node)
        correctTree()
    }
    
    func adjustTree(offset: CGSize) {
        isAnimating = true
        treeNode.run(SKAction.move(by: CGVector(dx: -offset.width, dy: -offset.height), duration: 0.5)) {
            self.adjustment(root: self.root, offset: offset)
            self.isAnimating = false
        }
    }
    
    private func correctTree() {
        _ = resizeWidths(start: root)
        adjustSubtree(start: root, x: treeNode.position.x, y: treeNode.position.y, subTree: nil)
    }
    
    private func resizeWidths(start node: Node?) -> CGFloat {
        guard let node = node as? TreeNode else {
            return 0
        }
        node.leftWidth = max(0.5 * step.width, resizeWidths(start: node.left))
        node.rightWidth = max(0.5 * step.width, resizeWidths(start: node.right))
        return node.leftWidth + node.rightWidth
    }
    
    private func adjustSubtree(start node: Node?, x: CGFloat, y: CGFloat, subTree: TreeNode.SubTree?) {
        guard let node = node as? TreeNode else { return }
        var xPos = x
        if let side = subTree {
            if side == .left {
                xPos -= node.rightWidth
            } else if side == .right {
                xPos += node.leftWidth
            }
        }
        isAnimating = true
        node.run(SKAction.move(to: CGPoint(x: xPos, y: y), duration: 0.5)) { [self] in
            node.refresh()
            adjustSubtree(start: node.left, x: xPos, y: y - step.height, subTree: .left)
            adjustSubtree(start: node.right, x: xPos, y: y - step.height, subTree: .right)
            isAnimating = false
        }
    }

    private func adjustment(root: Node?, offset: CGSize) {
        guard let node = root as? TreeNode else { return }
        isAnimating = true
        node.run(SKAction.move(by: CGVector(dx: -offset.width, dy: -offset.height), duration: 0.5)) { [self] in
            node.refresh()
            adjustment(root: node.right, offset: offset)
            adjustment(root: node.left, offset: offset)
            isAnimating = false
        }
    }

// MARK: Needs to be completed
    func animateDelete(node: TreeNode) {
        delete(node: node)
        nodes.removeAll { $0 == node }
    }
}

// This should not be here, should be a method of parent class
extension AnimationTree {
    func query(tag: Int) {
        _ = query(tag: tag, start: root)
    }
    private func query(tag: Int, start node: Node?) -> Bool {
        guard let node = node as? TreeNode else {
            return false
        }
        if tag == node.tag {
            queryCorrect(node: node)
            return true
        } else if tag < node.tag {
            return query(tag: tag, start: node.left)
        } else {
            return query(tag: tag, start: node.right)
        }
    }

    private func queryCorrect(node: TreeNode) {
        totalStamps += 1
        node.stamps += 1
        node.feed(stamp: totalStamps, nodeCount: nodes.count)
        if let parent = node.parentNode as? TreeNode {
            if parent.weight < node.weight {
                if node.isEqualTo(parent.left) {
                    rotateRight(node: node)
                } else {
                    rotateLeft(node: node)
                }
                correctTree()
            }
        }
    }
}


