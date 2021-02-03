//
//  KTree.swift
//  KTree(Swift)
//
//  Created by Kyle Burns on 8/14/20.
//  Copyright © 2020 Kyle Burns. All rights reserved.
//

import UIKit

public enum SubTree {
    case left, right, none
    
    func toString() -> String {
        switch self {
        case .left: return "left"
        case .right: return "right"
        case .none: return "none"
        }
    }
}

public protocol Node: class {
    var parentNode: Node? { get set }
    var left: Node? { get set }
    var right: Node? { get set }
/// Timestamp at most recent access.
    var timestamp: UInt64 { get set }
/// Current weight of node.
    var weight: Double { get set }
/// Ratio of current weight to maximum.
    var usage: Double { get set }
/// Whether node is parent's right or left child.
    var subTree: SubTree { get set }
    func isEqualTo(_ node: Node?) -> Bool
    func isLessThan(_ node: Node?) -> Bool
    func isGreaterThan(_ node: Node?) -> Bool
}

open class KTree {
    private var timestamp: UInt64 = 0
    private let growth: Double
    private let decay: Double
    private let decayThreshold: UInt64
    private let maxWeight: Double
    private let sigmoid: Sigmoid
    var root: Node?
///Stores the current number of nodes in tree
    var count: UInt64 = 0
///Tells whether or not tree is empty.
    var empty: Bool {
        count == 0
    }
    
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
*/ @discardableResult
    open func delete(node: Node) -> Bool {
        guard let result = search(node: node, root: root) else { return false }
        return delete(withReference: result)
    }

/** Removes ```node``` from tree.
     
As with search, ```node``` does not need to be a reference to the node you want to delete. It only needs to pass the ```isEqualTo``` function from the ```Node``` protocol.
     
- Parameter node: Node to be deleted.
- Returns: Reference to removed node if successful, otherwise ```nil```.
*/
    open func pop(node: Node) -> Node? {
        guard let result = search(node: node, root: root) else { return nil }
        if delete(withReference: result) {
            return result
        } else {
            return nil
        }
    }
    
    
/** Checks if tree contains ```node```.
    
    ```node``` does not need to be a reference to the desired node. The supplied node only needs to be equivalent to the desired node when compared with ```isEqualTo``` method in ```Node``` protocol.
- Parameter node: The desired node.
- Returns: ```true``` if found, otherwise ```false```.
*/
    open func contains(node: Node) -> Bool {
        return search(node: node, root: root) != nil
    }
    
/** Searches tree for ```node```.
    
    ```node``` does not need to be a reference to the desired node. The supplied node only needs to be equivalent to the desired node when compared with ```isEqualTo``` method in ```Node``` protocol.
- Parameter node: The desired node.
- Returns: Reference to ```node``` if found, otherwise ```nil```.
*/  @discardableResult
    open func search(node: Node) -> Node? {
        return search(node: node, root: root)
    }
    
/** Inserts ```node``` into tree.
- Parameter node: The node to be inserted.
- Returns: ```true``` on successful insert, otherwise ```false```.
 */ @discardableResult
    open func insert(node: Node) -> Bool {
        return insert(node: node, root: root)
    }
    
/** Prints tree to console

The callback allows customization of the print output for each ```node```.
- Parameters:
     - spacing: Horizontal spacing between nodes.
     - printBlock: Callback which provides each node for printing.
*/
    open func printTree(spacing: Int = 10, printBlock: @escaping (Node) -> ()) {
        print2DUtil(root: root, space: 0, spacing: spacing, printBlock: printBlock)
    }
    
    
// MARK: Utility Functions
    
/** Utility function which rotates node left about its parent.
- Parameter node: The node to be rotated.
*/
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
/** Utility function which rotates node right about its parent.
- Parameter node: The node to be rotated.
*/
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
- Parameter node: The node which was just accessed.
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
        node.usage = node.weight / maxWeight
        node.timestamp = stamp
    }
// FIXME: The derivative needs to be checked. Apparently it's not a good way to do this.
/** Utility function for increasing node weight after successfull access.
     
    The feed function applies a growth based on the derivative of the sigmoid function at the current weight of ```node```.
    This results in a logistic growth pattern for the node.
- Parameter node: The node to be fed.
*/
    private func feed(node: Node) {
        node.weight += sigmoid.dx(node.weight)
        node.usage = node.weight / maxWeight
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
/** Inserts node into search tree.
- Parameters:
     - node: The node to be inserted.
     - root: The starting point for the search.
- Returns: true for success, false for failure.
*/
    func insert(node: Node, root: Node?) -> Bool {
        if self.root == nil {
            self.root = node
            return true
        } else if node.isLessThan(root) {
            if root?.left == nil {
                root?.left = node
                node.subTree = .left
                node.parentNode = root
                count += 1
                return true
            } else {
                return insert(node: node, root: root?.left)
            }
        } else if node.isGreaterThan(root) {
            if root?.right == nil {
                root?.right = node
                node.subTree = .right
                node.parentNode = root
                count += 1
                return true
            } else {
                return insert(node: node, root: root?.right)
            }
        } else {
            print("KTree: insert: Duplicate entries not allowed")
            return false
        }
    }
/** Utility function for searching for node.

It is crucial to understand that the comparison behavior of nodes is defined by the user by conforming to the Node protocol. Therefore, the parameter ```node``` is not *equal* to the node returned. It merely passes the user-implemented comparison function.
- Parameters:
     - node: The desired node.
     - root: The starting point for the search.
- Returns: The desired node if found, nil otherwise.
*/
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
     - space: The current space from 0.
     - spacing: The spacing increment.
     - printBlock: Closure which is called for each node to provide user control of print format
*/
    private func print2DUtil(root: Node?, space: Int, spacing: Int, printBlock: @escaping (Node) -> ()) {
        guard let root = root else { return }
        
        print2DUtil(root: root.right, space: space + spacing, spacing: spacing, printBlock: printBlock)
        
        print()
        for _ in 0..<space {
            print(" ", terminator: "")
        }
        
        printBlock(root) // post-order traversal for console printing

        print2DUtil(root: root.left, space: space + spacing, spacing: spacing, printBlock: printBlock)
    }

/** Utility function for deleting node from tree.
     
Node must be a reference to the actual node to be deleted.
     
- Parameter withReference: The node to be deleted.
- Returns: ```true``` on successful deletion, ```false``` otherwise.
*/
    private func delete(withReference node: Node) -> Bool {
        // tree is empty
        guard let root = root, count > 0 else { return false }
        if node.isEqualTo(root) {
            assert(count == 1)
            count = 0
            self.root = nil
            return true
        // no children
        } else if node.left == nil && node.right == nil {
            if node.subTree == .right {
                node.parentNode?.right = nil
            } else {
                node.parentNode?.left = nil
            }
            count -= 1
            return true
        // one child
        } else if node.right == nil || node.left == nil {
            if node.right == nil {
                node.left?.parentNode = node.parentNode
                if node.subTree == .right {
                    node.parentNode?.right = node.left
                } else {
                    node.parentNode?.left = node.left
                }
            } else {
                node.right?.parentNode = node.parentNode
                if node.subTree == .right {
                    node.parentNode?.right = node.right
                } else {
                    node.parentNode?.left = node.right
                }
            }
            count -= 1
            return true
        // two children
        } else {
            var predecessor: Node? = node.left
            while(predecessor?.right != nil) {
                predecessor = predecessor?.right
            }
            if swap(first: predecessor, second: node) {
                return delete(withReference: node)
            } else {
                fatalError("Swap failure")
            }
        }
    }
}
