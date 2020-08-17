//
//  Stepper.swift
//  KTree Demo
//
//  Created by Kyle Burns on 8/13/20.
//  Copyright © 2020 Kyle Burns. All rights reserved.
//

import UIKit

final class Stepper {
    var current: Node?
    var root: Node
    var node: Node
    var offset: CGPoint = .zero
    var didBegin: Bool = false
    
    init(start: Node, nodeToInsert: Node) {
        root = start
        current = root
        node = nodeToInsert
    }
    
    func reconfigure(start: Node, nodeToInsert: Node) {
        root = start
        current = root
        node = nodeToInsert
    }
    
    func next() -> (Node?) {
        didBegin = true
        node.depth += 1
        print("next")
        if node.isLessThan(object: current) {
            if current?.left == nil {
                current?.left = node
                node.parent = current
                return node
            }
            current = current?.left
//            offset.x -= KTree.horizontalStep
//            offset.y += KTree.verticalStep
            return current
        } else if node.isEqualTo(object: current) && current != root {
            print("\((node as! ViewNode).tag), \((current as! ViewNode).tag)")
            print("Error: Stepper: next: duplicate entires not allowed")
            return current
        } else {
            if current?.right == nil {
                current?.right = node
                node.parent = current
                return node
            }
            current = current?.right
//            offset.x -= KTree.horizontalStep
//            offset.y += KTree.verticalStep
            return current
        }
    }
}


