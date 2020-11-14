//
//  AnimationQueue.swift
//  KTree(Swift)
//
//  Created by Kyle Burns on 11/14/20.
//  Copyright © 2020 Kyle Burns. All rights reserved.
//

import SpriteKit

class AnimationQueue {
    private var queue: [Operation] = []
    
    func addOperation(_ operation: Operation) {
        queue.append(operation)
    }
    
    func next() {
        let op = queue.removeFirst()
        op.start()
    }
}


