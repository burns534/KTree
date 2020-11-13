//
//  KTree.swift
//  KTree(Swift)
//
//  Created by Kyle Burns on 8/14/20.
//  Copyright © 2020 Kyle Burns. All rights reserved.
//

import UIKit

protocol Node: class {
    var parentNode: Node? { get set }
    var left: Node? { get set }
    var right: Node? { get set }
    func isEqualTo(_ node: Node?) -> Bool
    func isLessThan(_ node: Node?) -> Bool
    func isGreaterThan(_ node: Node?) -> Bool
    func swap(withNode node: Node?)
}

open class KTree {
    static let COUNT = 10
    
    var root: Node?
    var count: Int64 = 0
    
    var rotateLeftHandler: (Node) -> () = {_ in}
    var rotateRightHandler: (Node) -> () = {_ in}
    
    func rotateLeft(node: Node) {
        guard let parent = node.parentNode, node.isEqualTo(node.parentNode?.left)
        else { return }
        rotateLeftHandler(node)
        let grandparentNode = node.parentNode?.parentNode
        node.parentNode?.right = node.left
        node.left = node.parentNode
        if grandparentNode == nil {
            root = node
        } else if parent.isEqualTo(grandparentNode?.left) {
            grandparentNode?.left = node
        } else {
            grandparentNode?.right = node
        }
        node.parentNode?.right?.parentNode = node.left
        node.parentNode?.parentNode = node
        node.parentNode = grandparentNode
    }
    
    func rotateRight(node: Node) {
        guard let parent = node.parentNode,
              node.isEqualTo(node.parentNode?.right)
        else { return }
        rotateRightHandler(node)
        let grandparentNode = node.parentNode?.parentNode
        node.parentNode?.left = node.right
        node.right = node.parentNode
        if (grandparentNode == nil) {
            root = node
        } else if parent.isEqualTo(grandparentNode?.left) {
            grandparentNode?.left = node
        } else {
            grandparentNode?.right = node;
        }
        node.parentNode?.left?.parentNode = node.right
        node.parentNode?.parentNode = node
        node.parentNode = grandparentNode
    }
    
    func insert(node: Node?, parentNode: Node?, depth: UInt) -> Bool {
        guard let node = node else { return false }
        if root == nil {
            root = node
//            node.depth = 0
            return true
        }
        guard let parentNode = parentNode else { return false }
        if node.isLessThan(parentNode) {
            if parentNode.left == nil {
                parentNode.left = node
                node.parentNode = parentNode
//                node.depth = depth
                return true
            }
            return insert(node: node, parentNode: parentNode.left, depth: depth + 1)
        } else if node.isEqualTo(parentNode) {
            print("KTree: insert: Duplicate entries not allowed")
            return false
        } else {
            if parentNode.right == nil {
                parentNode.right = node
                node.parentNode = parentNode
//                node.depth = depth
                return true
            }
            return insert(node: node, parentNode: parentNode.right, depth: depth + 1)
        }
    }
    
    func delete(node: Node) {
        if root == nil || count == 0{ return }
        if node.isEqualTo(root) {
            count = 0
            root = nil
        }
        
        if node.right == nil && node.left == nil {
            if node.isEqualTo(node.parentNode?.left) {
                node.parentNode?.left = nil
            } else {
                node.parentNode?.right = nil
            }
            count -= 1;
        } else if node.right != nil && node.left != nil {
            var swap = node.left
            while (swap?.right != nil) {
                swap = swap?.right
            }
            node.swap(withNode: swap)
            delete(node: node)
        } else {
            count -= 1
            if node.isEqualTo(node.parentNode?.left) {
                if let left = node.left {
                    node.parentNode?.left = left
                    left.parentNode = node.parentNode
                } else {
                    node.parentNode?.left = node.right
                    node.right?.parentNode = node.parentNode
                }
            } else {
                if let left = node.left {
                    node.parentNode?.right = left
                    left.parentNode = node.parentNode
                } else {
                    node.parentNode?.right = node.right
                    node.right?.parentNode = node.parentNode
                }
            }
        }
    }
    
    func printTree(printBlock: @escaping (Node) -> ()) {
        print2DUtil(node: root, space: 0, printBlock: printBlock)
    }
    
    func animate(start: CGPoint, animation: @escaping (Node) -> ()) {
        animate2DUtil(node: root, animation: animation)
    }
    
    private func print2DUtil(node: Node?, space: Int, printBlock: @escaping (Node) -> ()) {
        guard let node = node else { return }
        
        print2DUtil(node: node.right, space: space + KTree.COUNT, printBlock: printBlock)
        
        print()
        var i = KTree.COUNT
        while i < space {
            print(" ", terminator: "")
            i += 1
        }
        
        printBlock(node)
        
        print2DUtil(node: node.left, space: space + KTree.COUNT, printBlock: printBlock)
    }
    
    private func animate2DUtil(node: Node?, animation: @escaping (Node) -> ()) {
        guard let node = node else { return }
        animate2DUtil(node: node.left, animation: animation)
        animation(node)
        animate2DUtil(node: node.right, animation: animation)
    }
}
