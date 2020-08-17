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
    enum SubTree {
        case left, right
    }
    open var parent: Node?
    open var left: Node?
    open var right: Node?
    var depth: UInt = 0
    var subTree: SubTree?
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
    
}


