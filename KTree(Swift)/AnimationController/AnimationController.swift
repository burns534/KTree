//
//  AnimationController.swift
//  KTree(Swift)
//
//  Created by Kyle Burns on 8/14/20.
//  Copyright © 2020 Kyle Burns. All rights reserved.
//

import UIKit

class AnimationController: UIViewController {
    let nums = [15, 10, 17, 5, 6, 7, 18, 4, 11, 14, 19, 0, 8, 13, 3, 12, 2, 1, 9, 16]
    var tree: AnimationTree!
    var containerView: UIView!
    var insertButton: UIButton!
    var insertField: PaddedTextField!
    var scrollView: UIScrollView!
    var undo: UIButton!
    var contentFrame: CGRect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 600)

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    func setup() {
        view.backgroundColor = .white
        
        scrollView = UIScrollView()
        scrollView.contentSize = contentFrame.size
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bouncesZoom = true
        scrollView.delegate = self
        scrollView.minimumZoomScale = 0.05
        scrollView.maximumZoomScale = 1.5
        view.addSubview(scrollView)
        
        containerView = UIView(frame: contentFrame)
        scrollView.addSubview(containerView)
        
        insertButton = UIButton()
        insertButton.setTitle("Insert", for: .normal)
        insertButton.setTitleColor(.white, for: .normal)
        insertButton.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .light)
        insertButton.addTarget(self, action: #selector(insertHandler), for: .touchUpInside)
        insertButton.layer.cornerRadius = 30
        insertButton.setShadow(radius: 5, color: .darkGray, opacity: 0.4, offset: CGSize(width: 0, height: 5))
        insertButton.backgroundColor = .olive
        view.addSubview(insertButton)
        
        undo = UIButton()
        undo.setTitle("Undo", for: .normal)
        undo.setTitleColor(.white, for: .normal)
        undo.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .light)
        undo.addTarget(self, action: #selector(undoHandler), for: .touchUpInside)
        undo.setShadow(radius: 5, color: .darkGray, opacity: 0.4, offset: CGSize(width: 0, height: 5))
        undo.layer.cornerRadius = 30
        undo.backgroundColor = .olive
        view.addSubview(undo)
        
        
        insertField = PaddedTextField()
        insertField.setPadding(.standard)
        insertField.backgroundColor = .darkWhite
        insertField.placeholder = "Enter Number"
        insertField.delegate = self
        insertField.textAlignment = .center
        insertField.layer.cornerRadius = 5
        view.addSubview(insertField)
        
        view.subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            scrollView.heightAnchor.constraint(equalToConstant: 600),
            
            insertButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            insertButton.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 100),
            insertButton.widthAnchor.constraint(equalToConstant: 150),
            insertButton.heightAnchor.constraint(equalToConstant: 60),
            
            undo.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            undo.topAnchor.constraint(equalTo: insertButton.topAnchor),
            undo.widthAnchor.constraint(equalToConstant: 150),
            undo.heightAnchor.constraint(equalToConstant: 60),
            
            insertField.centerXAnchor.constraint(equalTo: insertButton.centerXAnchor),
            insertField.bottomAnchor.constraint(equalTo: insertButton.topAnchor, constant: -20)
        ])

        tree = AnimationTree(position: CGPoint(x: contentFrame.midX, y: 50), contentView: containerView)
        
        nums.shuffled().forEach {
            tree.insert(tag: $0)
        }
        
        tree.printTree {
            print(($0 as! ViewNode).tag)
        }
    }
    
    @objc func insertHandler(_ sender: UIButton) {
        guard let text = insertField.text else { return }
        guard let tag = Int(text) else { return }
        tree.insert(tag: tag)
        resignFirstResponder()
        insertField.endEditing(true)
        insertField.text = ""
    }
    
    @objc func undoHandler(_ sender: UIButton) {
        guard let delNode = tree.nodes.last else { return }
        print(delNode.tag)
        tree.delete(node: delNode)
    }

}

extension AnimationController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return containerView
    }
     
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        return
    }
}

extension AnimationController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        resignFirstResponder()
        view.endEditing(true)
        guard let text = textField.text,
        let num = Int(text) else { return false }
        tree.insert(tag: num)
        insertField.text = ""
        return true
    }
}


