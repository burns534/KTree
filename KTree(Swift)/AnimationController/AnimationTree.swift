//
//  AnimationTree.swift
//  KTree(Swift)
//
//  Created by Kyle Burns on 8/17/20.
//  Copyright © 2020 Kyle Burns. All rights reserved.
//

import UIKit

class AnimationTree: KTree {
    var nodes = [ViewNode]()
    var position: CGPoint
    let verticalStep: CGFloat = 30.0
    let horizontalStep: CGFloat = 30.0
    
    weak var delegate: ViewNodeDelegate?
    
    static var treeEdgeInsets: UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    init(position: CGPoint) {
        self.position = position
// MARK: Need to change the way the sigmoid works. The derivative isn't the answer to the issue. I would need to take the integral of the derivative which is just the orginal function of weight. Need to handle it on the decay side rather than sigmoid side.
        print(Node.sigmoid.dx(1000.0))
    }
    
    func insert(tag: Int) {
        print("\ninserting: \(tag)")
        let newNode = ViewNode(withTag: tag)
        newNode.delegate = delegate
        print("nodes.count: \(nodes.count)")
        if insert(node: newNode, parent: root, depth: 0) {
            newNode.configureView()
            nodes.append(newNode)
            count += 1
            correctTree()
            newNode.correct { offset in
                guard let offset = offset else { return }
                self.adjustTree(offset: offset)
            }
        }
    }
    
    func delete(node: ViewNode) {
        node.deconfigure()
        _ = nodes.popLast()
        super.delete(node: node)
        correctTree()
    }
    
    func adjustTree(offset: CGSize) {
        print("adjustTree called")
        position += CGPoint(x: offset.width, y: offset.height)
        adjustment(root: root, offset: offset)
    }
    
    private func correctTree() {
        _ = resizeWidths(start: root)
//        guard let root = root as? ViewNode else { return }
//        if root.leftWidth < position.x {
//            position.x = root.leftWidth
//        } else if root.rightWidth > position.x {
//            position.x = max(root.leftWidth, 2 * position.x - root.rightWidth) // no clue
//        }
        adjustSubtree(start: root, x: position.x, y: position.y, subTree: nil)
    }
    
    private func resizeWidths(start node: Node?) -> CGFloat{
        guard let node = node as? ViewNode else { return 0 }
        node.leftWidth = max(0.5 * horizontalStep, resizeWidths(start: node.left))
        node.rightWidth = max(0.5 * horizontalStep, resizeWidths(start: node.right))
        return node.leftWidth + node.rightWidth
    }
    
    private func adjustSubtree(start node: Node?, x: CGFloat, y: CGFloat, subTree: Node.SubTree?) {
        guard let node = node as? ViewNode else { return }
        var xPos = x
        if let side = subTree {
            if side == .left {
                xPos -= node.rightWidth
            } else if side == .right {
                xPos += node.leftWidth
            }
        }
        let location = CGPoint(x: xPos, y: y)
        if location != node.location {
            node.location = location
            node.correct { offset in
                guard let offset = offset else { return }
                self.adjustTree(offset: offset)
            }
        }
//        print("node \(node.tag) located at \(node.location!.x), \(node.location!.y)")
        node.refresh()
        adjustSubtree(start: node.left, x: xPos, y: y + verticalStep, subTree: .left)
        adjustSubtree(start: node.right, x: xPos, y: y + verticalStep, subTree: .right)
    }
    
//    private func contentAdjustment(root: Node?, found: inout Bool) {
//        if found { return }
//        guard let node = root as? ViewNode,
//        let location = node.location,
//        let delegate = delegate else { return }
////        complete = delegate.adjustContentFrame(violatingPoint: location)
//
//
//        contentAdjustment(root: node.left, found: &found)
//        contentAdjustment(root: node.right, found: &found)
//    }
    
    private func adjustment(root: Node?, offset: CGSize) {
        guard let node = root as? ViewNode else { return }
        if node.location != nil {
            node.location! += CGPoint(x: offset.width, y: offset.height)
        }
        node.refresh()
        adjustment(root: node.right, offset: offset)
        adjustment(root: node.left, offset: offset)
    }

// MARK: Needs to be completed
    func animateDelete(node: ViewNode) {
        delete(node: node)
        nodes.removeAll { $0 == node }
    }
}

extension AnimationTree {
    func query(tag: Int) {
        _ = query(tag: tag, start: root)
    }
    private func query(tag: Int, start node: Node?) -> Bool {
        guard let node = node else { return false }
        guard let viewNode = node as? ViewNode else { fatalError() }
        if tag == viewNode.tag {
            queryCorrect(node: node)
            return true
        } else if tag < viewNode.tag {
//            print("Searching left subtree")
            return query(tag: tag, start: node.left)
        } else {
//            print("Searching right subtree")
            return query(tag: tag, start: node.right)
        }
    }

    private func queryCorrect(node: Node) {
        Node.totalStamps += 1
        node.stamps += 1
        node.feed(stamp: Node.totalStamps)
        if let parent = node.parent {
            if parent.weight < node.weight {
                if node == parent.left {
                    rotateRight(node: node)
                } else {
                    rotateLeft(node: node)
                }
                correctTree()
            }
        }
    }
}
