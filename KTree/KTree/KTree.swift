////
////  KTree.swift
////  KTree(Swift)
////
////  Created by Kyle Burns on 8/14/20.
////  Copyright © 2020 Kyle Burns. All rights reserved.
////
//
//import UIKit
//
//public enum SubTree {
//    case left, right, none
//
//    func toString() -> String {
//        switch self {
//        case .left: return "left"
//        case .right: return "right"
//        case .none: return "none"
//        }
//    }
//}
//
///// Abstract class must be subclassed. This is the workaround to Comparable protocol ambiguity issues
//open class TreeKey {
//    public static func == (lhs: TreeKey, rhs: TreeKey) -> Bool {
//        return false
//    }
//    public static func < (lhs: TreeKey, rhs: TreeKey) -> Bool {
//        return false
//    }
//}
//
//open class Node: NSObject {
//    public init(key: TreeKey, weight: Double) {
//        self.key = key
//        self.weight = weight
//        self.timestamp = 0
//    }
//    open var parent: Node?
//    open var left: Node?
//    open var right: Node?
//    open var key: TreeKey
//    /// Timestamp at most recent access
//    open var timestamp: Double
//    /// Current weight of node
//    open var weight: Double
//    /// Whether node is parent's right or left child
//    open var subtree: SubTree
//    /// For debugging purposes
//    open func print() {}
//
//    open var data: AnyClass
//}
////
////public protocol Node: Comparable {
////    var parent: Node? { get set }
////    var left: Node? { get set }
////    var right: Node? { get set }
/////// Timestamp at most recent access.
////    var timestamp: UInt64 { get set }
/////// Current weight of node.
////    var weight: Double { get set }
/////// Ratio of current weight to maximum.
////    var usage: Double { get set }
/////// Whether node is parent's right or left child.
////    var subtree: SubTree { get set }
////    func isEqualTo(_ node: Node?) -> Bool
////    func isLessThan(_ node: Node?) -> Bool
////    func isGreaterThan(_ node: Node?) -> Bool
////    func display()
////    func debugString()
////}
//
//public typealias GrowthFunction = (Double) -> Double
//
//open class KTree {
////    private var timestamp: UInt64 = 0
//    open var growthRate: Double
//    open var decayRate: Double
//    open var decayThreshold: UInt64
////    open var maxWeight: Double // ??
///// User-defined growth function
////    open var growthFunction: GrowthFunction
//    open var root: Node?
///// Stores the current number of nodes in tree
//    open var count: UInt64 = 0
//
//    open var empty: Bool {
//        count == 0
//    }
//
////    public init(growth: Double = 0.000_01, decay: Double = 0.05, decayThreshold: UInt64 = 200, maxWeight: Double = 1000, midPoint: Double = 400_000) {
////        self.growth = growth
////        self.decay = decay
////        self.decayThreshold = decayThreshold
////        self.maxWeight = maxWeight
////        self.sigmoid = Sigmoid(max: maxWeight, mid: midPoint, k: growth)
////    }
//
//    public init(growthRate: Double, decayRate: Double) {
//        self.growthRate = growthRate
//        self.decayRate = decayRate
//    }
//
//// MARK: Public functions
///** Deletes node matching ```key``` from tree if present.
//
//- Parameter key: Key of node to be deleted.
//- Returns: ```true``` if successful deletion, otherwise ```false```.
//*/
//    @discardableResult
//    open func delete(key: TreeKey) -> Bool {
//        guard let result = search(key: key, root: root) else { return false }
//        return deleteUtil(node: result)
//    }
//
///** Removes ```node``` from tree.
//
//As with search, ```node``` does not need to be a reference to the node you want to delete. It only needs to pass the ```isEqualTo``` function from the ```Node``` protocol.
//
//- Parameter node: Node to be deleted.
//- Returns: Reference to removed node if successful, otherwise ```nil```.
//*/
//
////    open func pop(node: Node) -> Node? {
////        guard let result = search(node: node, root: root) else { return nil }
////        if delete(withReference: result) {
////            return result
////        } else {
////            return nil
////        }
////    }
//
//
///** Checks if tree contains a node matching ```key```.
//
//- Parameter key: The key to check against containment
//- Returns: ```true``` if found, otherwise ```false```.
//*/
//    open func contains(key: TreeKey) -> Bool {
//        search(key: key, root: root) != nil
//    }
//
///** Searches tree for node matching ```key```.
//- Parameter key: The key for which to search the tree.
//- Returns: Reference to ```node``` if found, otherwise ```nil```.
//*/  @discardableResult
//    open func search(key: TreeKey) -> Node? {
//        search(key: key, root: root)
//    }
//
///** Inserts ```node``` into tree.
//- Parameter node: The node to be inserted.
//- Returns: ```true``` on successful insert, otherwise ```false```.
// */ @discardableResult
//    open func insert(node: Node) -> Bool {
//        insert(node: node, root: root)
//    }
//
///** Prints tree to console
//
//The callback allows customization of the print output for each ```node```.
//- Parameters:
//     - spacing: Horizontal spacing between nodes
//*/
//    open func printTree(spacing: Int = 10) {
//        print("<-------Printing Tree-------->")
//        print2DUtil(root: root, space: 0, spacing: spacing)
//        print("\n<---------------------------->")
//    }
//
//
//// MARK: Utility Functions
//
///** Utility function which rotates node left about its parent.
//- Parameter node: The node to be rotated.
//*/
//    private func rotateLeft(node: Node) {
//        guard let parent = node.parent, node == node.parent?.right
//        else { return }
//        let grandparent = node.parent?.parent
//        node.parent?.right = node.left
//        node.left = node.parent
//        if grandparent == nil {
//            root = node
//        } else if parent == grandparent?.left {
//            grandparent?.left = node
//        } else {
//            grandparent?.right = node
//        }
//        node.parent?.right?.parent = node.left
//        node.parent?.parent = node
//        node.parent = grandparent
//    }
///** Utility function which rotates node right about its parent.
//- Parameter node: The node to be rotated.
//*/
//    private func rotateRight(node: Node) {
//        guard let parent = node.parent, node == node.parent?.left
//        else { return }
//        let grandparent = node.parent?.parent
//        node.parent?.left = node.right
//        node.right = node.parent
//        if (grandparent == nil) {
//            root = node
//        } else if parent == grandparent?.left {
//            grandparent?.left = node
//        } else {
//            grandparent?.right = node;
//        }
//        node.parent?.left?.parent = node.right
//        node.parent?.parent = node
//        node.parent = grandparent
//    }
//
///** Balances tree if needed following query
//- Parameter node: The node which was just accessed.
//- Returns: true if rotation occurred, false if not.
//*/
//    @discardableResult
//    private func queryCorrect(node: Node) -> Bool {
//        decay(node: node, stamp: timestamp);
//        feed(node: node);
//        if let parent = node.parent {
//            if parent.weight < node.weight {
//                if node == parent.left {
//                    rotateRight(node: node)
//                } else {
//                    rotateLeft(node: node)
//                }
//                return true
//            }
//        }
//        return false
//    }
///** Utility function for decreasing nodde weight after successful access.
//
//    The decay function applies a linear decay to the node proportional to the "time" since last access if after grace period indicated by threshold.
//- Parameters:
//     - node: The node to decay.
//     - stamp: The current timestamp or total current number of node accesses
// */
//    private func decay(node: Node, stamp: UInt64) {
//        guard stamp - node.timestamp > decayThreshold else {
//            node.timestamp = stamp
//            return
//        }
//        node.weight -= decay * Double(stamp - node.timestamp)
//        node.usage = node.weight / maxWeight
//        node.timestamp = stamp
//    }
//// FIXME: The derivative needs to be checked. Apparently it's not a good way to do this.
///** Utility function for increasing node weight after successfull access.
//
//    The feed function applies a growth based on the derivative of the sigmoid function at the current weight of ```node```.
//    This results in a logistic growth pattern for the node.
//- Parameter node: The node to be fed.
//*/
//    private func feed(node: Node) {
//        node.weight += sigmoid.dx(node.weight)
//        node.usage = node.weight / maxWeight
//    }
//
//// FIXME: Needs to be checked
///** Utility function for swapping two nodes.
//- Parameters:
//     - first: First node to be swapped.
//     - second: Second node to be swapped.
//- Returns ```true``` on success, ```false``` on failure.
//*/
//    @discardableResult
//    private func swap(first: Node?, second: Node?) -> Bool {
//        guard let first = first, let second = second else { return false }
//
//        Swift.swap(&first.left, &second.left)
//        Swift.swap(&first.right, &second.right)
//        if first.subtree == .left {
//            first.parent?.left = second
//        } else {
//            first.parent?.right = second
//        }
//        if second.subtree == .left {
//            second.parent?.left = first
//        } else {
//            second.parent?.right = first
//        }
//        Swift.swap(&first.parent, &second.parent)
//        Swift.swap(&first.subtree, &second.subtree)
//        return true
//    }
//
///** Inserts node into search tree.
//- Parameters:
//     - node: The node to be inserted.
//     - root: The starting point for the search.
//- Returns: true for success, false for failure.
//*/
//    private func insert(node: Node, root: Node?) -> Bool {
//        guard let root = root, self.root != nil else {
//            self.root = node
//            return true
//        }
//
//        if node.key < root.key {
//            if root.left == nil {
//                root.left = node
//                node.subtree = .left
//                node.parent = root
//                count += 1
//                return true
//            } else {
//                return insert(node: node, root: root.left)
//            }
//        } else if root.key < node.key {
//            if root.right == nil {
//                root.right = node
//                node.subtree = .right
//                node.parent = root
//                count += 1
//                return true
//            } else {
//                return insert(node: node, root: root.right)
//            }
//        } else {
//            print("KTree: insert: Duplicate entries not allowed")
//            return false
//        }
//    }
///** Utility function for searching for node.
//     Recursively searches the tree for a node entry matching ```key```
//- Parameters:
//     - key: The key for which to search.
//     - root: The starting point for the search.
//- Returns: The desired node if found, nil otherwise.
//*/
//    private func search(key: TreeKey, root: Node?) -> Node? {
//        guard let root = root else { return nil }
//        if key == root.key {
//            queryCorrect(node: root)
//            return root
//        } else if key < root.key {
//            return search(key: key, root: root.left)
//        } else {
//            return search(key: key, root: root.right)
//        }
//    }
//
///** Utility function for printing tree to console.
//- Parameters:
//     - node: The starting node for the print function.
//     - space: The current space from 0.
//     - spacing: The spacing increment.
//*/
//    private func print2DUtil(root: Node?, space: Int, spacing: Int) {
//        guard let root = root else { return }
//
//        print2DUtil(root: root.right, space: space + spacing, spacing: spacing)
//
//        print()
//        for _ in 0..<space {
//            print(" ", terminator: "")
//        }
//
//        root.print() // post-order traversal for console printing
//
//        print2DUtil(root: root.left, space: space + spacing, spacing: spacing)
//    }
//
///** Utility function for deleting node from tree.
//
//Node must be a reference to the actual node to be deleted.
//
//- Parameter node: Reference to the node to be deleted.
//- Returns: ```true``` on successful deletion, ```false``` otherwise.
//*/
//    private func deleteUtil(node: Node) -> Bool {
//        // tree is empty
//        guard let root = root, count > 0 else { print("delete: bad"); return false }
//        // deleting root
//        if node == root && count == 1{
//            print("delete: root")
//            count = 0
//            self.root = nil
//            return true
//        // no children
//        } else if node.left == nil && node.right == nil {
//            print("delete: no children")
//            if node.subtree == .right {
//                node.parent?.right = nil
//            } else {
//                node.parent?.left = nil
//            }
//            count -= 1
//            return true
//        // one child
//        } else if node.right == nil || node.left == nil {
//            print("delete: one child")
//            if node.right == nil {
//                if node == root {
//                    self.root = node.left
//                }
//                node.left?.parent = node.parent
//                if node.subtree == .right {
//                    node.parent?.right = node.left
//                } else {
//                    node.parent?.left = node.left
//                }
//            } else {
//                if node == root {
//                    self.root = node.right
//                }
//                node.right?.parent = node.parent
//                if node.subtree == .right {
//                    node.parent?.right = node.right
//                } else {
//                    node.parent?.left = node.right
//                }
//            }
//            count -= 1
//            return true
//        // two children
//        } else {
//            print("delete: two kids")
//            var predecessor: Node? = node.left
//            while(predecessor?.right != nil) {
//                predecessor = predecessor?.right
//            }
//            if node == root {
//                self.root = predecessor
//            }
//            if swap(first: predecessor, second: node) {
//                return deleteUtil(node: node)
//            } else {
//                fatalError("Swap failure")
//            }
//        }
//    }
//}
