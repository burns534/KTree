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
    var field: PaddedTextField!
    var iterationsField: PaddedTextField!
    var insertButton: UIButton!
    var searchButton: UIButton!
    var scrollView: UIScrollView!
    var paretoQuery: UIButton!
    var undo: UIButton!
    
    var treeFrame: CGRect = .zero
    
    let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapHandler))

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    func setup() {
        view.backgroundColor = .white
        
        view.addGestureRecognizer(tapRecognizer)
        view.isUserInteractionEnabled = true
        
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 500))
        scrollView.contentSize = .zero
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bouncesZoom = true
        scrollView.delegate = self
        scrollView.minimumZoomScale = 0.05
        scrollView.maximumZoomScale = 1.5
        view.addSubview(scrollView)
        
        containerView = UIView(frame: .zero)
        scrollView.addSubview(containerView)
//        view.addSubview(containerView)
        
        tree = AnimationTree(position: CGPoint(x: view.bounds.midX, y: 50 ))
        tree.delegate = self
        
        
        field = PaddedTextField()
        field.setPadding(.standard)
        field.backgroundColor = .darkWhite
        field.placeholder = "Enter Value"
        field.delegate = self
        field.textAlignment = .center
        field.layer.cornerRadius = 5
        view.addSubview(field)
        
        iterationsField = PaddedTextField()
        iterationsField.setPadding(.standard)
        iterationsField.backgroundColor = .darkWhite
        iterationsField.placeholder = "Iterations"
        iterationsField.delegate = self
        iterationsField.textAlignment = .center
        iterationsField.layer.cornerRadius = 5
        view.addSubview(iterationsField)
        
        undo = UIButton()
        undo.setTitle("Undo", for: .normal)
        undo.setTitleColor(.white, for: .normal)
        undo.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .light)
        undo.addTarget(self, action: #selector(undoHandler), for: .touchUpInside)
        undo.setShadow(radius: 5, color: .darkGray, opacity: 0.4, offset: CGSize(width: 0, height: 5))
        undo.layer.cornerRadius = 5
        undo.backgroundColor = .olive
        view.addSubview(undo)
        
        insertButton = UIButton()
        insertButton.setTitle("Insert", for: .normal)
        insertButton.setTitleColor(.white, for: .normal)
        insertButton.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .light)
        insertButton.addTarget(self, action: #selector(insertHandler), for: .touchUpInside)
        insertButton.layer.cornerRadius = 5
        insertButton.setShadow(radius: 5, color: .darkGray, opacity: 0.4, offset: CGSize(width: 0, height: 5))
        insertButton.backgroundColor = .olive
        view.addSubview(insertButton)
        
        searchButton = UIButton()
        searchButton.setTitle("Search", for: .normal)
        searchButton.setTitleColor(.white, for: .normal)
        searchButton.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .light)
        searchButton.addTarget(self, action: #selector(searchHandler), for: .touchUpInside)
        searchButton.layer.cornerRadius = 5
        searchButton.setShadow(radius: 5, color: .darkGray, opacity: 0.4, offset: CGSize(width: 0, height: 5))
        searchButton.backgroundColor = .olive
        view.addSubview(searchButton)
        
        paretoQuery = UIButton()
        paretoQuery.setTitle("Pareto", for: .normal)
        paretoQuery.setTitleColor(.white, for: .normal)
        paretoQuery.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .light)
        paretoQuery.addTarget(self, action: #selector(randomQueryHandler), for: .touchUpInside)
        paretoQuery.layer.cornerRadius = 5
        paretoQuery.setShadow(radius: 5, color: .darkGray, opacity: 0.4, offset: CGSize(width: 0, height: 5))
        paretoQuery.backgroundColor = .olive
        view.addSubview(paretoQuery)
        
        view.subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            scrollView.heightAnchor.constraint(equalToConstant: 600),
//
            undo.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            undo.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            undo.widthAnchor.constraint(equalToConstant: 180),
            undo.heightAnchor.constraint(equalToConstant: 60),
            
            insertButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            insertButton.bottomAnchor.constraint(equalTo: undo.topAnchor, constant: -10),
            insertButton.widthAnchor.constraint(equalTo: undo.widthAnchor),
            insertButton.heightAnchor.constraint(equalTo: undo.heightAnchor),
            
            searchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            searchButton.topAnchor.constraint(equalTo: insertButton.topAnchor),
            searchButton.widthAnchor.constraint(equalTo: undo.widthAnchor),
            searchButton.heightAnchor.constraint(equalTo: undo.heightAnchor),
            
            paretoQuery.bottomAnchor.constraint(equalTo: undo.bottomAnchor),
            paretoQuery.centerXAnchor.constraint(equalTo: searchButton.centerXAnchor),
            paretoQuery.widthAnchor.constraint(equalTo: undo.widthAnchor),
            paretoQuery.heightAnchor.constraint(equalTo: undo.heightAnchor),
            
            field.bottomAnchor.constraint(equalTo: insertButton.topAnchor, constant: -10),
            field.centerXAnchor.constraint(equalTo: insertButton.centerXAnchor),
            field.widthAnchor.constraint(equalTo: undo.widthAnchor),
            
            iterationsField.bottomAnchor.constraint(equalTo: searchButton.topAnchor, constant: -10),
            iterationsField.centerXAnchor.constraint(equalTo: searchButton.centerXAnchor),
            iterationsField.widthAnchor.constraint(equalTo: undo.widthAnchor)
        ])
        
//        nums.shuffled().forEach {
//            tree.insert(tag: $0)
//        }
//
//        tree.printTree {
//            print(($0 as! ViewNode).tag)
//        }
    }
    
    @objc func insertHandler(_ sender: UIButton) {
        guard let text = field.text else { return }
        if let tag = Int(text) {
            tree.insert(tag: tag)
        } else if let it = iterationsField.text,
            let iterations = Int(it),
            text == "$0" {
            for _ in 0..<iterations { tree.insert(tag: Int.random(in: 0..<200)) }
        }
        resignFirstResponder()
        field.endEditing(true)
        field.text = ""
    }
    
// MARK: Not fully functional
    @objc func undoHandler(_ sender: UIButton) {
        guard let delNode = tree.nodes.last else { return }
        print(delNode.tag)
        tree.delete(node: delNode)
    }
    
    @objc func searchHandler(_ sender: UIButton) {
        guard let text = field.text,
            let num = Int(text) else { return }
        if let stringIterations = iterationsField.text,
            let iterations = Int(stringIterations) {
            for _ in 0..<iterations { tree.query(tag: num) }
            return
        }
        tree.query(tag: num)
    }
    
    @objc func randomQueryHandler(_ sender: UIButton) {
        guard let text = iterationsField.text,
            let num = Int(text) else { return }
        var count = 0
        while count < num {
            let index = Int.random(in: 0..<tree.nodes.count)
            let p = Pareto.pareto.value(Double(index))
            if Probability.roll(p) {
                count += 1
                tree.query(tag: tree.nodes[index].tag)
            }
        }
    }
// MARK: Doesn't work
    @objc func tapHandler(_ gesture: UITapGestureRecognizer) {
        let loc = gesture.location(in: view)
        print("called")
        if field.frame.contains(loc) { return }
        print("it doesn't")
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
        textField.endEditing(true)
        resignFirstResponder()
        return true
    }
}

extension AnimationController: ViewNodeDelegate {
    func getSuperview() -> UIView {
        return containerView
    }
    
    func getViewController() -> UIViewController {
        return self
    }
    
    func getScrollView() -> UIScrollView {
        return scrollView
    }
}


