//
//  AnimationTree.swift
//  KTree(Swift)
//
//  Created by Kyle Burns on 8/17/20.
//  Copyright © 2020 Kyle Burns. All rights reserved.
//

import UIKit
import SpriteKit

open class AnimationTree {
    private let tree = CollectionReference("yup")
    private let scene: Scene
    private let verticalStep: CGFloat = 15.0
    private let horizontalStep: CGFloat = 15.0
    private let dispatchGroup = DispatchGroup()
    private let nodeRadius: CGFloat
    
    private var isAnimating: Bool = false
    private var animationQueue: [() -> Void] = []
    var nodeCount = 0
    private var root: AnimationNode?
    
    public enum SubTree {
        case left, right, none
    }

    var animationSpeed: TimeInterval = 0.15
    var step: CGSize {
        CGSize(width: verticalStep + 2 * nodeRadius, height: horizontalStep + 2 * nodeRadius)
    }
    
    init(scene: Scene, nodeRadius: CGFloat = 20) {
        self.scene = scene
        self.nodeRadius = nodeRadius
    }
    
    func batchInsert(iterations: Int, range: Range<Int>) {
        for _ in 0..<iterations {
            let tag = Int.random(in: range)
            let newNode = AnimationNode(tag: tag)
            newNode.zPosition = 0.1
//            if insert(node: newNode) {
//                scene.treeContainer.addChild(newNode)
//                if let parent = newNode.parentNode as? AnimationNode {
//                    newNode.link(to: parent)
//                }
//                nodeCount += 1
//            }
        }
        correctTree()
    }
    
    func insert(tag: Int) {
//        let work = { [self] in
//            let newNode = AnimationNode(tag: tag)
//            newNode.zPosition = 0.1
//            if insert(node: newNode) {
//                scene.treeContainer.addChild(newNode)
//                if let parent = newNode.parentNode as? AnimationNode {
//                    newNode.link(to: parent)
//                }
//                correctTree()
//            } else {
//                popQueue()
//            }
//        }
//        if isAnimating {
//            animationQueue.append(work)
//        } else {
//            work()
//        }
    }
    
    func delete(tag: Int) {
//        let work = { [self] in
//            let node = AnimationNode(tag: tag)
//            if let node = pop(node: node) as? AnimationNode {
//                node.deconfigure()
//                node.link(to: node.parentNode)
//                correctTree()
//            } else {
//                popQueue()
//            }
//        }
//        if isAnimating {
//            animationQueue.append(work)
//        } else {
//            work()
//        }
    }
    
    @discardableResult
    func search(tag: Int) -> Bool {
//        let node = AnimationNode(tag: tag)
//        return search(node: node) != nil
        return false
    }
    
    private func popQueue() {
        if animationQueue.first != nil {
            animationQueue.removeFirst()
        }
    }
    
    private func performQueue() {
        
    }
    
    private func correctTree() {
        resizeWidths(start: root)
        adjustSubtree(start: root, x: 0, y: 0, subTree: .none)
        dispatchGroup.notify(queue: .main) { [self] in
            isAnimating = false
            popQueue()
        }
    }
    
    @discardableResult
    private func resizeWidths(start node: AnimationNode?) -> CGFloat {
        guard let node = node else { return 0 } // ???
        node.leftWidth = max(0.5 * step.width, resizeWidths(start: node.left))
        node.rightWidth = max(0.5 * step.width, resizeWidths(start: node.right))
        return node.leftWidth + node.rightWidth
    }

    private func adjustSubtree(start node: AnimationNode?, x: CGFloat, y: CGFloat, subTree: SubTree) {
        guard let node = node else { return }
        isAnimating = true
        var position = CGPoint(x: x, y: y)
        
        if subTree == .left {
            position.x -= node.rightWidth
        } else if subTree == .right {
            position.x += node.leftWidth
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


