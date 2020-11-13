//
//  Scene.swift
//  KTree(Swift)
//
//  Created by Kyle Burns on 11/13/20.
//  Copyright © 2020 Kyle Burns. All rights reserved.
//

import UIKit
import SpriteKit

class Scene: SKScene {
    
    var viewController: AnimationController?
    var treeContainer: SKNode = SKNode()
    
    private var previousTouchPosition: CGPoint = .zero
    private var panSpeed: CGFloat = 1.0
    
    override func didMove(to view: SKView) {
        addChild(treeContainer)
        treeContainer.position = CGPoint(x: size.width / 4, y: size.height / 2 - 100)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touchCount == 0, touches.count == 1, let touch = touches.first {
            previousTouchPosition = touch.location(in: self)
        }
        touchCount += 1
        if touchCount == 2 {
            initialTouchDistance = 0
        }
    }
    
    private var initialTouchDistance: CGFloat = 0
    private var zoomSpeed: CGFloat = 1.0
    private var previousScale: CGFloat = 1.0
    private var currentScale: CGFloat = 1.0
    private var touchCount: Int = 0
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.count == 1, touchCount == 1, let touch = touches.first {
            let loc = touch.location(in: self)
            let dx = (loc.x - previousTouchPosition.x)
            let dy = (loc.y - previousTouchPosition.y)
            treeContainer.position = CGPoint(x: treeContainer.position.x + dx * panSpeed, y: treeContainer.position.y + dy * panSpeed)
            previousTouchPosition = loc
        } else if touches.count == 2 {
            var location1: CGPoint = .zero
            var location2: CGPoint = .zero
            for touch in touches {
                if location1 == .zero {
                    location1 = touch.location(in: self)
                } else {
                    location2 = touch.location(in: self)
                }
            }
            let distance = sqrt(pow(location1.x - location2.x, 2) + pow(location1.y - location2.y, 2))
            if initialTouchDistance == 0 {
                initialTouchDistance = distance
            }
            if initialTouchDistance != 0 && initialTouchDistance != CGFloat.nan {
                let scale = distance / initialTouchDistance
                currentScale = previousScale * scale
                treeContainer.setScale(currentScale * zoomSpeed)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
// MARK: Touch up inside
        if let touch = touches.first, previousTouchPosition == touch.location(in: self) {
            print("true)")
            if let node = treeContainer.nodes(at: touch.location(in: treeContainer)).first as? TreeNode {
                let detailViewController = ViewNodeDetailViewController()
                detailViewController.configure(node: node)
                viewController?.present(detailViewController, animated: true)
            }
        }
        previousScale = currentScale
        touchCount = 0
    }
}
