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
    
    private var isAnimating: Bool = false
    var animationSpeed: TimeInterval = 0.3

    var step: CGSize {
        CGSize(width: verticalStep + 2 * TreeNode.nodeRadius, height: horizontalStep + 2 * TreeNode.nodeRadius)
    }
    
    var scene: Scene
    
    init(scene: Scene) {
        self.scene = scene
// MARK: Need to change the way the sigmoid works. The derivative isn't the answer to the issue. I would need to take the integral of the derivative which is just the orginal function of weight. Need to handle it on the decay side rather than sigmoid side.
        print(TreeNode.sigmoid.dx(1000.0))
    }
    
    private var queue: [() -> Void] = []
        
    func insert(tag: Int) {
        let work = { [self] in
            print("work \(tag)")
            let newNode = TreeNode(tag: tag)
            newNode.zPosition = 0.1
            if insert(node: newNode, parentNode: root, depth: 0) {
                scene.treeContainer.addChild(newNode)
                if let parent = newNode.parentNode as? TreeNode {
                    newNode.link(to: parent)
                }
                nodes.append(newNode)
                count += 1
                correctTree()
            } else {
                next()
            }
        }
        if isAnimating {
            queue.append(work)
        } else {
            work()
        }
    }
    
    func delete(node: TreeNode) {
        node.deconfigure()
        nodes.removeAll { $0 == node }
        super.delete(node: node)
        correctTree()
    }

    private var offset: CGFloat = 0
    private var dispatchGroup = DispatchGroup()
    
    func next() {
        if queue.first != nil {
            queue.removeFirst()()
        }
    }
    
    private func correctTree() {
        offset = 0
        resizeWidths(start: root)
        adjustSubtree(start: root, x: scene.treeContainer.position.x, y: scene.treeContainer.position.y, subTree: nil)
        dispatchGroup.notify(queue: .main) { [self] in
            scene.treeContainer.run(SKAction.move(by: CGVector(dx: offset, dy: 0), duration: animationSpeed)) {
                isAnimating = false
                next()
            }
        }
    }
    @discardableResult
    private func resizeWidths(start node: Node?) -> CGFloat {
        guard let node = node as? TreeNode else { return 0 }
        node.leftWidth = max(0.5 * step.width, resizeWidths(start: node.left))
        node.rightWidth = max(0.5 * step.width, resizeWidths(start: node.right))
        return node.leftWidth + node.rightWidth
    }

    private func adjustSubtree(start node: Node?, x: CGFloat, y: CGFloat, subTree: TreeNode.SubTree?) {
        guard let node = node as? TreeNode else {
            return
        }
        isAnimating = true
        var position = CGPoint(x: x, y: y)
        if let side = subTree {
            if side == .left {
                position.x -= node.rightWidth
            } else if side == .right {
                position.x += node.leftWidth
            }
        }
        
        let convertedPosition = scene.treeContainer.convert(position, to: scene)
        if convertedPosition.x + offset < 0 {
            print(offset, convertedPosition.x)
            offset = 0 - convertedPosition.x
//            print("less than, \(node.tag)")
        } else if convertedPosition.x + offset > UIScreen.main.bounds.width {
            offset = UIScreen.main.bounds.width - convertedPosition.x
//            print("greater than \(node.tag)")
        }
        
        adjustSubtree(start: node.left, x: position.x, y: position.y - step.height, subTree: .left)
        
        dispatchGroup.enter()

// MARK: Mostly works, could be smoother with rotations maybe
        let startPos = node.position
        node.run(SKAction.customAction(withDuration: animationSpeed) { [self] node, elapsed in
            guard let node = node as? TreeNode else { return }
            let step = elapsed / CGFloat(animationSpeed)
            node.position = startPos + (position - startPos) * step
            node.removeLinks()
            if let parent = node.parentNode as? TreeNode {
                node.link(to: parent)
            }
            if let leftChild = node.left as? TreeNode {
                node.link(to: leftChild)
            }
            if let rightChild = node.right as? TreeNode {
                node.link(to: rightChild)
            }
        }) { [self] in
            dispatchGroup.leave()
            node.refresh()
            adjustSubtree(start: node.right, x: position.x, y: position.y - step.height, subTree: .right)
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


