//
//  Node.swift
//  KTree(Swift)
//
//  Created by Kyle Burns on 8/14/20.
//  Copyright © 2020 Kyle Burns. All rights reserved.
//

import UIKit

protocol Comparable: AnyObject {
    func isLessThan(object: Comparable?) -> (Bool);
    func isGreaterThan(object: Comparable?) -> (Bool);
    func isEqualTo(object: Comparable?) -> (Bool);
}

open class Node: NSObject, Comparable {
    static var feedFactor: Double = 0.00001
    static var maxWeight: Double = 1000
    static var midPoint: Double = 400000
// MARK: Decay Factor
/* Decays proportional to own weight and time since last feeding (measured in stamps). The decay factor represents factor of weight to be lost at the threshold */
    static var decayFactor: Double = 0.05
    static var thresholdFactor: Double = 2.0
    static var sigmoid = Sigmoid(max: Node.maxWeight, mid: Node.midPoint, k: Node.feedFactor)
    static var totalStamps: Int64 = 0
    
    var decayThreshold: Double {
        Node.thresholdFactor * Double(tree.count)
    }

    enum SubTree {
        case left, right, root
    }
    open var tree: KTree!
    open var parent: Node?
    open var left: Node?
    open var right: Node?
    var depth: UInt = 0
    var subTree: SubTree? {
        guard let parent = parent else { return .root }
        if self == parent.right {
            return .right
        }
        return .left
    }
    
    var subRoot: Node? {
        if parent == nil { return nil }
        var result = self
        if self == parent?.left {
            while result.parent != nil && result == result.parent?.left {
                result = result.parent!
            }
        } else {
            while result.parent != nil && result == result.parent?.right {
                result = result.parent!
            }
        }
        return result
    }
    
    var weight: Double = 1.0
    var stamp: Int64 = 0
    var stamps: Int64 = 0
    
    func isLessThan(object: Comparable?) -> (Bool) {
        return false
    }
    
    func isGreaterThan(object: Comparable?) -> (Bool) {
        return false
    }
    
    func isEqualTo(object: Comparable?) -> (Bool) {
        return false
    }
    
    func swap(withNode node: Node?) {
        guard let node = node else { return }
        var temp: Node? = nil
        
        if node == node.parent?.left {
            node.parent?.left = self
        } else if node == node.parent?.right {
            node.parent?.right = self
        }
        
        if self == parent?.left {
            self.parent?.left = node
        } else if self == parent?.right {
            self.parent?.right = node
        }
        
        temp = parent
        parent = node.parent
        node.parent = temp
        
        temp = left
        left = node.left
        node.left = temp
        
        temp = right
        right = node.right
        node.right = temp
    }
    
    func feed(stamp: Int64) {
//        print("\nFeeding \((self as! ViewNode).tag)\n")
        let difference = Double(stamp - self.stamp)
        let decay = difference > decayThreshold ? (ViewNode.decayFactor * weight * log(Double(difference)) / decayThreshold) : 0.0
        let growth = Node.sigmoid.dx(weight)
        
//        print("weight: \(weight), decay: \(decay), growth: \(Node.sigmoid.dx(weight))")
        
        weight += growth - decay
        if weight < 0.0 { weight = 0.0 }
        self.stamp = stamp
//        print("difference: \(difference)")
    }
}


