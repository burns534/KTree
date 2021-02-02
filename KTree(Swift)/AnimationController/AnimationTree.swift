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
    let scene: Scene
    let verticalStep: CGFloat = 15.0
    let horizontalStep: CGFloat = 15.0
    
    var animationSpeed: TimeInterval = 0.15
    
    private var isAnimating: Bool = false
    private var queue: [() -> Void] = []
    
    private let dispatchGroup = DispatchGroup()

    var step: CGSize {
        CGSize(width: verticalStep + 2 * AnimationNode.nodeRadius, height: horizontalStep + 2 * AnimationNode.nodeRadius)
    }
    
    init(scene: Scene) {
        self.scene = scene
// MARK: Need to change the way the sigmoid works. The derivative isn't the answer to the issue. I would need to take the integral of the derivative which is just the orginal function of weight. Need to handle it on the decay side rather than sigmoid side.
//        print(TreeNode.sigmoid.dx(1000.0))
    }
    
    func batchInsert(iterations: Int, range: Int) {
        for _ in 0..<iterations {
            let tag = Int.random(in: 0..<range)
            let newNode = AnimationNode(tag: tag)
            newNode.zPosition = 0.1
            if insert(node: newNode, parentNode: root, depth: 0) {
                scene.treeContainer.addChild(newNode)
                if let parent = newNode.parentNode as? AnimationNode {
                    newNode.link(to: parent)
                }
                count += 1
            }
        }
        correctTree()
    }
        
    func insert(tag: Int) {
        let work = { [self] in
            let newNode = AnimationNode(tag: tag)
            newNode.zPosition = 0.1
            if insert(node: newNode, parentNode: root, depth: 0) {
                scene.treeContainer.addChild(newNode)
                if let parent = newNode.parentNode as? AnimationNode {
                    newNode.link(to: parent)
                }
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
    
    func remove_node(tag: Int) {
        if let node = delete(tag: tag) as? AnimationNode {
            node.deconfigure()
            correctTree()
            node.link(to: node.parentNode as! AnimationNode)
        } else {
            fatalError("Big problem")
        }
    }
    
    func next() {
        if queue.first != nil {
            queue.removeFirst()()
        }
    }
    
    private func correctTree() {
        resizeWidths(start: root)
        adjustSubtree(start: root, x: 0, y: 0, subTree: nil)
        dispatchGroup.notify(queue: .main) { [self] in
            isAnimating = false
            next()
        }
    }
    
    @discardableResult
    private func resizeWidths(start node: Node?) -> CGFloat {
        guard let node = node as? AnimationNode else { return 0 }
        node.leftWidth = max(0.5 * step.width, resizeWidths(start: node.left))
        node.rightWidth = max(0.5 * step.width, resizeWidths(start: node.right))
        return node.leftWidth + node.rightWidth
    }

    private func adjustSubtree(start node: Node?, x: CGFloat, y: CGFloat, subTree: AnimationNode.SubTree?) {
        guard let node = node as? AnimationNode else { return }
        isAnimating = true
        var position = CGPoint(x: x, y: y)
        if let side = subTree {
            if side == .left {
                position.x -= node.rightWidth
            } else if side == .right {
                position.x += node.leftWidth
            }
        }

        adjustSubtree(start: node.left, x: position.x, y: position.y - step.height, subTree: .left)
        
        dispatchGroup.enter()

        let startPos = node.position
        node.run(SKAction.customAction(withDuration: animationSpeed) { [self] node, elapsed in
            guard let node = node as? AnimationNode else { return }
            let step = elapsed / CGFloat(animationSpeed)
            node.position = startPos + (position - startPos) * step
            node.removeLinks()
            if let parent = node.parentNode as? AnimationNode {
                node.link(to: parent)
            }
            if let leftChild = node.left as? AnimationNode {
                node.link(to: leftChild)
            }
            if let rightChild = node.right as? AnimationNode {
                node.link(to: rightChild)
            }
        }) { [self] in
            dispatchGroup.leave()
            node.refresh()
            adjustSubtree(start: node.right, x: position.x, y: position.y - step.height, subTree: .right)
        }
    }

}


