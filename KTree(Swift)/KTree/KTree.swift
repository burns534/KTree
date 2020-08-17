//
//  KTree.swift
//  KTree(Swift)
//
//  Created by Kyle Burns on 8/14/20.
//  Copyright © 2020 Kyle Burns. All rights reserved.
//

import UIKit

open class KTree {
    static let COUNT = 10
    
    var root: Node?
    var count: Int = 0
    var stamps: UInt = 0
    
    var rotateLeftHandler: (Node) -> () = {_ in}
    var rotateRightHandler: (Node) -> () = {_ in}
    
    func rotateLeft(node: Node) {
        if node.parent == nil || node == node.parent?.left { return }
        rotateLeftHandler(node)
        let grandparent = node.parent?.parent
        node.parent?.right = node.left
        node.left = node.parent
        if grandparent == nil {
            root = node
        } else if node.parent == grandparent?.left {
            grandparent?.left = node
        } else {
            grandparent?.right = node
        }
        node.parent?.right?.parent = node.left
        node.parent?.parent = node
        node.parent = grandparent
    }
    
    func rotateRight(node: Node) {
        if node.parent == nil || node == node.parent?.right { return }
        rotateRightHandler(node)
        let grandparent = node.parent?.parent
        node.parent?.left = node.right
        node.right = node.parent
        if (grandparent == nil) {
            root = node
        } else if (node.parent == grandparent?.left) {
            grandparent?.left = node
        } else {
            grandparent?.right = node;
        }
        node.parent?.left?.parent = node.right
        node.parent?.parent = node
        node.parent = grandparent
    }
    
    func insert(node: Node?, parent: Node?, depth: UInt) {
        guard let node = node else { return }
        if root == nil {
            root = node
            node.depth = 0
            return
        }
        guard let parent = parent else { return }
        if node.isLessThan(object: parent) {
            if parent.left == nil {
                parent.left = node
                node.parent = parent
                node.depth = depth
                return
            }
            insert(node: node, parent: parent.left, depth: depth + 1)
        } else if node.isEqualTo(object: parent) {
            print("KTree: insert: Duplicate entries not allowed")
            return
        } else {
            if parent.right == nil {
                parent.right = node
                node.parent = parent
                node.depth = depth
                return
            }
            insert(node: node, parent: parent.right, depth: depth + 1)
        }
    }
    
    func delete(node: Node) {
        if root == nil || count == 0{ return }
        if node == root {
            count = 0
            root = nil
        }
        // this means they're both nil
        if node.right == node.left {
            if node == node.parent?.left {
                node.parent?.left = nil
            } else {
                node.parent?.right = nil
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
            if node == node.parent?.left {
                if let left = node.left {
                    node.parent?.left = left
                    left.parent = node.parent
                } else {
                    node.parent?.left = node.right
                    node.right?.parent = node.parent
                }
            } else {
                if let left = node.left {
                    node.parent?.right = left
                    left.parent = node.parent
                } else {
                    node.parent?.right = node.right
                    node.right?.parent = node.parent
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
