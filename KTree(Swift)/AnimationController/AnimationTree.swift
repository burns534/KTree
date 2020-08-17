//
//  AnimationTree.swift
//  KTree(Swift)
//
//  Created by Kyle Burns on 8/17/20.
//  Copyright © 2020 Kyle Burns. All rights reserved.
//

import UIKit


class AnimationTree: KTree {
    var nodes = [ViewNode]()
    var position: CGPoint
    var contentView: UIView
    let verticalStep: CGFloat = 30.0
    let horizontalStep: CGFloat = 30.0
    
    init(position: CGPoint, contentView view: UIView) {
        self.position = position
        contentView = view
    }
    
    func insert(tag: Int) {
        print("inserting: \(tag)")
        count += 1
        let newNode = ViewNode(withTag: tag, contentView: contentView)
        newNode.configureView()
        nodes.append(newNode)
        print("nodes.count: \(nodes.count)")
        insert(node: newNode, parent: root, depth: 0)
        correctTree()
    }
    
    func delete(node: ViewNode) {
        node.deconfigure()
        _ = nodes.popLast()
        super.delete(node: node)
        correctTree()
    }
    
    private func correctTree() {
        _ = resizeWidths(start: root)
        guard let root = root as? ViewNode else { return }
//        if root.leftWidth < position.x {
//            position.x = root.leftWidth
//        } else if root.rightWidth > position.x {
//            position.x = max(root.leftWidth, 2 * position.x - root.rightWidth) // no clue
//        }
        adjustSubtree(start: root, x: position.x, y: position.y, subTree: nil)
    }
    
    private func resizeWidths(start node: Node?) -> CGFloat{
        guard let node = node else { return 0 }
        guard let viewNode = node as? ViewNode else { fatalError() }
        viewNode.leftWidth = max(0.5 * horizontalStep, resizeWidths(start: node.left))
        viewNode.rightWidth = max(0.5 * horizontalStep, resizeWidths(start: node.right))
        return viewNode.leftWidth + viewNode.rightWidth
    }
    
    private func adjustSubtree(start node: Node?, x: CGFloat, y: CGFloat, subTree: Node.SubTree?) {
        guard let node = node, let viewNode = node as? ViewNode else { return }
        var xPos = x
        if let side = subTree {
            if side == .left {
                xPos -= viewNode.rightWidth
            } else if side == .right {
                xPos += viewNode.leftWidth
            }
        }
        let location = CGPoint(x: xPos, y: y)
        viewNode.location = location
//        if !contentView.point(inside: location, with: nil) {
//            let sv = contentView.superview as! UIScrollView
//            sv.setZoomScale(sv.zoomScale * 0.95, animated: true)
//        }
//        if location.x < contentView.bounds.minX {
//            let offset = contentView.bounds.minX - location.x
//            contentView.frame = CGRect(x: location.x, y: 0, width: contentView.frame.width + offset, height: contentView.frame.height)
//        }
//        if location.y < contentView.bounds.minY {
//            let offset = contentView.bounds.minY - location.y
//            contentView.frame = CGRect(x: location.x, y: 0, width: contentView.frame.width + offset, height: contentView.frame.height)
//        }
        viewNode.refresh()
        adjustSubtree(start: node.left, x: xPos, y: y + verticalStep, subTree: .left)
        adjustSubtree(start: node.right, x: xPos, y: y + verticalStep, subTree: .right)
    }

// MARK: Needs to be completed
    func animateDelete(node: ViewNode) {
        delete(node: node)
        nodes.removeAll { $0 == node }
    }
}
