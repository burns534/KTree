//
//  KTree.swift
//  KTree(Swift)
//
//  Created by Kyle Burns on 8/14/20.
//  Copyright © 2020 Kyle Burns. All rights reserved.
//

import UIKit

enum SubTree {
    case left, right
}

protocol Node: class {
    var parentNode: Node? { get set }
    var left: Node? { get set }
    var right: Node? { get set }
    var timestamp: UInt64 { get set }
    var weight: Double { get set }
    var subTree: SubTree { get set }
    func isEqualTo(_ node: Node?) -> Bool
    func isLessThan(_ node: Node?) -> Bool
    func isGreaterThan(_ node: Node?) -> Bool
}

open class KTree {
    private var root: Node?
    private var timestamp: UInt64 = 0
    private let growth: Double
    private let decay: Double
    private let decayThreshold: UInt64
    private let maxWeight: Double
    private let sigmoid: Sigmoid
    var count: UInt64 = 0
    
    public init(growth: Double = 0.000_01, decay: Double = 0.05, decayThreshold: UInt64 = 200, maxWeight: Double = 1000, midPoint: Double = 400_000) {
        self.growth = growth
        self.decay = decay
        self.decayThreshold = decayThreshold
        self.maxWeight = maxWeight
        self.sigmoid = Sigmoid(max: maxWeight, mid: midPoint, k: growth)
    }

// MARK: Public functions
/** Deletes ```node``` from tree
     
As with search, ```node``` does not need to be a reference to the node you want to delete. It only needs to pass the ```isEqualTo``` function from the ```Node``` protocol.
     
- Parameter node: Node to be deleted.
- Returns: ```true``` if successful deletion, otherwise ```false```.
*/
    func delete(node: Node) -> Bool {
        guard let result = search(node: node, root: root) else { return false }
        return delete(node: result, root: root)
    }
    
/// Prints tree to console
    ///
/// The callback allows customization in the print output of the tree.
    ///
/// - Parameters:
///     - spacing: Horizontal spacing between nodes
///     - printBlock: Callback which provides each node for printing
    func printTree(spacing: Int = 10, printBlock: @escaping (Node) -> () = { _ in }) {
        print2DUtil(root: root, space: spacing, printBlock: printBlock)
    }
    
    
// MARK: Utility Functions
    
/// Utility function which rotates node left about its parent.
/// - parameter node: The node to be rotated.
    private func rotateLeft(node: Node) {
        guard let parent = node.parentNode, node.isEqualTo(node.parentNode?.right)
        else { return }
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
/// Utility function which rotates node right about its parent.
///- parameter node: The node to be rotated.
    private func rotateRight(node: Node) {
        guard let parent = node.parentNode, node.isEqualTo(node.parentNode?.left)
        else { return }
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
    
/** Balances tree if needed following query
- Parameters:
     - node: The node which was just accessed.
- Returns: true if rotation occurred, false if not.
*/
    private func queryCorrect(node: Node) -> Bool {
        timestamp += 1;
        decay(node: node, stamp: timestamp);
        feed(node: node);
        if let parent = node.parentNode {
            if parent.weight < node.weight {
                if node.isEqualTo(parent.left) {
                    rotateRight(node: node)
                } else {
                    rotateLeft(node: node)
                }
                return true
            }
        }
        return false
    }
/** Inserts node into search tree.
- Parameters:
     - node: The node to be inserted.
     - root: The starting point for the search.
- Returns: true for success, false for failure.
*/
    func insert(node: Node, root: Node?) -> Bool {
        if root == nil {
            self.root = node
            return true
        } else if node.isLessThan(root) {
            return insert(node: node, root: root?.left)
        } else if node.isGreaterThan(root) {
            return insert(node: node, root: root?.right)
        } else {
            print("KTree: insert: Duplicate entries not allowed")
            return false
        }
    }
/// Utility function for searching for node.
///
///It is crucial to understand that the comparison behavior of nodes is defined by the user by conforming to the Node protocol. Therefore, the parameter ```node``` is not *equal* to the node returned. It merely passes the user-implemented comparison function.
///- Parameters:
///     - node: The desired node.
///     - root: The starting point for the search.
///- Returns: The desired node if found, nil otherwise.
    private func search(node: Node, root: Node?) -> Node? {
        guard let root = root else { return nil }
        if node.isEqualTo(root) {
            return node
        } else if node.isLessThan(root) {
            return search(node: node, root: root.left)
        } else {
            return search(node: node, root: root.right)
        }
    }
    
/** Utility function for printing tree to console.
- Parameters:
     - node: The starting node for the print function.
     - space: The desired spacing
     - printBlock: Closure which is called for each node to provide user control of print format
*/
    private func print2DUtil(root: Node?, space: Int, printBlock: @escaping (Node) -> ()) {
        guard let root = root else { return }
        
        print2DUtil(root: root.right, space: space, printBlock: printBlock)
        
        print()
        for _ in 0..<space {
            print(" ", terminator: "")
        }
        
        printBlock(root) // post-order traversal for console printing

        print2DUtil(root: root.left, space: space, printBlock: printBlock)
    }
/** Utility function for decreasing nodde weight after successful access.
     
    The decay function applies a linear decay to the node proportional to the "time" since last access if after grace period indicated by threshold.
- Parameters:
     - node: The node to decay.
     - stamp: The current timestamp or total current number of node accesses
 */
    private func decay(node: Node, stamp: UInt64) {
        guard stamp - node.timestamp > decayThreshold else {
            node.timestamp = stamp
            return
        }
        node.weight -= decay * Double(stamp - node.timestamp)
        node.timestamp = stamp
    }
/** Utility function for increasing node weight after successfull access.
     
    The feed function applies a growth based on the derivative of the sigmoid function at the current weight of ```node```.
    This results in a logistic growth pattern for the node.
- Parameter node: The node to be fed.
*/
    private func feed(node: Node) {
        node.weight += sigmoid.dx(node.weight)
    }
    
// FIXME: Needs to be checked
/** Utility function for swapping two nodes.
- Parameters:
     - first: First node to be swapped.
     - second: Second node to be swapped.
- Returns ```true``` on success, ```false``` on failure.
*/
    @discardableResult
    private func swap(first: Node?, second: Node?) -> Bool {
        guard let first = first, let second = second else { return false }
        let temp = first
        first.left = second.left
        first.right = second.right
        if first.subTree == .left {
            first.parentNode?.left = second
        } else {
            first.parentNode?.right = second
        }
        first.parentNode = second.parentNode
        
        second.left = temp.left
        second.right = temp.right
        if second.subTree == .left {
            second.parentNode?.left = temp
        } else {
            second.parentNode?.right = temp
        }
        second.parentNode = temp.parentNode
        return true
    }
/** Utility function for deleting node from tree.
     
Node must be a reference to the actual node to be deleted.
     
- Parameters:
     - node: The node to be deleted
     - root: The root of the tree from which to delete.
- Returns: ```true``` on successful deletion, ```false``` otherwise.
*/
    private func delete(node: Node, root: Node?) -> Bool {
        // tree is empty
        guard let root = root, count > 0 else { return false }
        if node.isEqualTo(root) {
            assert(count == 1)
            count = 0
            self.root = nil
            return true
        // no children
        } else if node.left == nil && node.right == nil {
            return true
        // one child
        } else if node.right == nil || node.left == nil {
            return true
        // two children
        } else {
            return true
        }
    }
}
