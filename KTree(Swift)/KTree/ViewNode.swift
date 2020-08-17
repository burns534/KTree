//
//  ViewNode.swift
//  KTree(Swift)
//
//  Created by Kyle Burns on 8/14/20.
//  Copyright © 2020 Kyle Burns. All rights reserved.
//

import UIKit


class ViewNode: Node {
    
    static var nodeRadius: CGFloat = 12.5
    
    var tag: Int
    var view: UIView!
    var location: CGPoint?
    var links = [CAShapeLayer]()
    var circle: CAShapeLayer?
    var label: UILabel?
    var contentView: UIView
    var leftWidth: CGFloat = 0
    var rightWidth: CGFloat = 0
    
    
    init(withTag tag: Int, contentView view: UIView) {
        self.tag = tag
        contentView = view
    }
    
    override func isLessThan(object: Comparable?) -> (Bool) {
        guard let node = object as? ViewNode else { fatalError() }
        return tag < node.tag
    }
    
    override func isGreaterThan(object: Comparable?) -> (Bool) {
        guard let node = object as? ViewNode else { fatalError() }
        return tag > node.tag
    }
    
    override func isEqualTo(object: Comparable?) -> Bool {
        guard let node = object as? ViewNode else { fatalError() }
        return tag == node.tag
    }
    
    func configureView() {
        let radius = ViewNode.nodeRadius
        view = UIView(frame: CGRect(x: 0, y: 0, width: 2 * radius, height: 2 * radius))
        view.backgroundColor = .olive
        view.layer.cornerRadius = radius
        let path = UIBezierPath(arcCenter: .zero + radius, radius: radius, startAngle: 0, endAngle: 2 * CGFloat(2 * Float.pi), clockwise: true).cgPath
        circle = CAShapeLayer()
        circle?.strokeColor = UIColor.black.cgColor
        circle?.fillColor = UIColor.clear.cgColor
        circle?.path = path
        circle?.lineWidth = 1
        view.layer.addSublayer(circle!)
        
        label = UILabel(frame: CGRect(x: 0, y: 0, width: 2 * radius, height: 2 * radius))
        label?.textAlignment = .center
        label?.text = String(tag)
        label?.textColor = .white
        label?.adjustsFontSizeToFitWidth = true
        view.addSubview(label!)
        contentView.addSubview(view)
    }
    
    func refresh() {
        view.frame.origin = location!
        removeLinks()
        guard let parent = parent as? ViewNode else { return }
        link(to: parent)
    }
    
    func link(to node: ViewNode, color: UIColor = .black) {
        guard let here = location else { return }
        guard let there = node.location else { return }
        let path = UIBezierPath()
        path.move(to: here + ViewNode.nodeRadius)
        path.addLine(to: there + ViewNode.nodeRadius)
        
        let shape = CAShapeLayer()
        shape.path = path.cgPath
        shape.strokeColor = color.cgColor
        shape.lineWidth = 2
        links.append(shape)
        contentView.layer.insertSublayer(shape, at: 0)
    }
    
    func removeLinks() {
        links.forEach { $0.removeFromSuperlayer() }
        links = []
    }
    
    func highlight(withDuration duration: TimeInterval, delay: TimeInterval) {
        print("highlight node \(tag)")
        UIView.animate(withDuration: duration, delay: delay, animations: {
            print("animating node \(self.tag)")
            self.view.transform = self.view.transform.scaledBy(x: 1.2, y: 1.2)
            self.view.backgroundColor = .yellow
            self.circle?.strokeColor = UIColor.white.cgColor
        }, completion: { success in
            self.view.transform = .identity
            self.view.backgroundColor = .systemTeal
            self.circle?.strokeColor = UIColor.black.cgColor
        })
    }
    
    func isCrossed(withNode node: ViewNode) -> Bool {
        guard let that = node.location,
        let this = location else { fatalError() }
        if this.y != that.y || this.x >= that.x { return false }
        print("isCrossed: passed second check: tag: \(tag), node.tag: \(node.tag)")
        return tag > node.tag
    }
    
    func isTooClose(toNode node: ViewNode, min: CGFloat) -> Bool {
        guard let that = node.location,
        let this = location else { fatalError() }
        if this.y != that.y { return false }
        return abs(this.x - that.x) < min
    }
    
    func deconfigure() {
        circle?.removeFromSuperlayer()
        removeLinks()
        view.removeFromSuperview()
    }
}
