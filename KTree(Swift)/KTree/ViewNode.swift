//
//  ViewNode.swift
//  KTree(Swift)
//
//  Created by Kyle Burns on 8/14/20.
//  Copyright © 2020 Kyle Burns. All rights reserved.
//

import UIKit

protocol ViewNodeDelegate: AnyObject {
    func getSuperview() -> UIView
    func setSuperviewFrame(frame: CGRect)
    func getViewController() -> UIViewController
    func getScrollView() -> UIScrollView
}

class ViewNode: Node {
    
    static var nodeRadius: CGFloat = 12.5
    private let nodeFrame = CGRect(x: 0, y: 0, width: 2 * ViewNode.nodeRadius, height: 2 * ViewNode.nodeRadius)
    
    var tag: Int
    var view: UIView!
    var location: CGPoint?
    var links = [CAShapeLayer]()
    var circle: CAShapeLayer?
    var label: UILabel?
    var detailButton: UIButton!
    var leftWidth: CGFloat = 0
    var rightWidth: CGFloat = 0
    
    weak var delegate: ViewNodeDelegate?
    
    init(withTag tag: Int) {
        self.tag = tag
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
        view = UIView(frame: nodeFrame)
        view.backgroundColor = .olive
        view.layer.cornerRadius = radius
        let path = UIBezierPath(arcCenter: .zero + radius, radius: radius, startAngle: 0, endAngle: 2 * CGFloat(2 * Float.pi), clockwise: true).cgPath
        circle = CAShapeLayer()
        circle?.strokeColor = UIColor.black.cgColor
        circle?.fillColor = UIColor.clear.cgColor
        circle?.path = path
        circle?.lineWidth = 1
        view.layer.addSublayer(circle!)
        
        label = UILabel(frame: nodeFrame)
        label?.textAlignment = .center
        label?.text = String(tag)
        label?.textColor = .white
        label?.adjustsFontSizeToFitWidth = true
        view.addSubview(label!)
        
        detailButton = UIButton(frame: nodeFrame)
        detailButton.addTarget(self, action: #selector(detailHandler), for: .touchUpInside)
        view.addSubview(detailButton)
        delegate?.getSuperview().addSubview(view)
    }
    
    @objc func detailHandler(_ sender: UIButton) {
        let vc = ViewNodeDetailViewController()
        vc.configure(node: self)
        delegate?.getViewController().present(vc, animated: true)
    }
    
    func refresh() {
        guard let loc = location else { return }
        view.frame.origin = loc - ViewNode.nodeRadius
        removeLinks()
        guard let parent = parent as? ViewNode else { return }
        link(to: parent)
    }
    
    func link(to node: ViewNode, color: UIColor = .black) {
        guard let here = location else { return }
        guard let there = node.location else { return }
        let path = UIBezierPath()
        path.move(to: here)
        path.addLine(to: there)
        
        let shape = CAShapeLayer()
        shape.path = path.cgPath
        shape.strokeColor = color.cgColor
        shape.lineWidth = 2
        links.append(shape)
        delegate?.getSuperview().layer.insertSublayer(shape, at: 0)
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
    
//    func rootConfigure() {
//        guard let container = delegate?.getSuperview(),
//            let scrollView = delegate?.getScrollView() else { fatalError() }
//        let insets = AnimationTree.treeEdgeInsets
//        let width = 3 * (2 * ViewNode.nodeRadius + insets.left + insets.right)
//        let height = 3 * (2 * ViewNode.nodeRadius + insets.top + insets.bottom) // ??
//        let frame = CGRect(x: 0, y: 0, width: width, height: height)
//        container.frame = frame
//        scrollView.contentSize = frame.size
//        ViewNode.contentFrame = frame / 3.0
//        ViewNode.contentFrame.origin = CGPoint(x: width / 3, y: height / 3)
//    }
    
    func correct(correction: @escaping (CGSize?) -> ()) {
        print("Correct called")
        guard let loc = location,
        let container = delegate?.getSuperview(),
        let scrollView = delegate?.getScrollView() else { fatalError() }
        let insets = AnimationTree.treeEdgeInsets
        let radius = ViewNode.nodeRadius
//        let contentFrame = ViewNode.contentFrame
        print("location: \(loc.x), \(loc.y)")
        if loc.x < insets.left + radius {
            let offset = insets.left + radius - loc.x
            print("offset: \(offset)")
            print("contentSize before: \(scrollView.contentSize.width)")
            print("containerView bounds before: \(container.bounds.width)")
            print("containerView frame before: \(container.frame.width)")
            var frame = CGRect(x: 0, y: 0, width: container.frame.width + offset, height: container.frame.height)
            frame.origin = container.frame.origin
            delegate?.setSuperviewFrame(frame: frame)
            scrollView.contentSize = frame.size
            print("contentSize after: \(scrollView.contentSize.width)")
            print("containerView bounds after: \(container.bounds.width)")
            print("containerView frame after: \(container.frame.width)")
            correction(CGSize(width: offset, height: 0))
        } else if loc.x > container.frame.width - radius - insets.right {
            let offset = loc.x - container.frame.width + insets.left + ViewNode.nodeRadius
            print("offset: \(offset)")
            print("contentSize before: \(scrollView.contentSize.width)")
            print("containerView bounds before: \(container.bounds.width)")
            print("containerView frame before: \(container.frame.width)")
            var frame = CGRect(x: 0, y: 0, width: container.frame.width + offset, height: container.frame.height)
            frame.origin = container.frame.origin
            delegate?.setSuperviewFrame(frame: frame)
            scrollView.contentSize = frame.size
            scrollView.scrollRectToVisible(frame.offsetBy(dx: offset, dy: 0), animated: true)
            print("contentSize after: \(scrollView.contentSize.width)")
            print("containerView bounds after: \(container.bounds.width)")
            print("containerView frame after: \(container.frame.width)")
        }
        if loc.y > container.frame.height - radius - insets.bottom {
            let offset = loc.y - container.frame.height + radius + insets.bottom
            print("offset: \(offset)")
            print("container before: \(container.frame.width), \(container.frame.height)")
            var frame = CGRect(x: 0, y: 0, width: container.frame.width, height: container.frame.height + offset)
            frame.origin = container.frame.origin
            delegate?.setSuperviewFrame(frame: frame)
            scrollView.contentSize = frame.size
            print("container after: \(container.frame.width), \(container.frame.height)")
            scrollView.scrollRectToVisible(frame.offsetBy(dx: 0, dy: offset), animated: true)
        }
    }
}
