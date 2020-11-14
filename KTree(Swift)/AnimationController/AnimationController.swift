//
//  AnimationController.swift
//  KTree(Swift)
//
//  Created by Kyle Burns on 8/14/20.
//  Copyright © 2020 Kyle Burns. All rights reserved.
//

import UIKit
import SpriteKit

let kControlViewHeight: CGFloat = 400

class AnimationController: UIViewController {
    var tree: AnimationTree!
    let controlView = ControlView(frame: .zero)
    
    private let maxNodeValue: Float = 9999
    
    var controlViewBottomAnchor: NSLayoutConstraint!
    
    override func loadView() {
        view = SKView()
    }
    
    var currentScene: Scene?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        controlViewBottomAnchor = NSLayoutConstraint(item: controlView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0)
        
        if let view = view as? SKView {
            view.ignoresSiblingOrder = true
            let scene = Scene(size: UIScreen.main.bounds.size)
            scene.viewController = self
            scene.backgroundColor = .white
            scene.scaleMode = .aspectFill
            view.isUserInteractionEnabled = true
            view.presentScene(scene)
            view.isMultipleTouchEnabled = true
            tree = AnimationTree(scene: scene)
            currentScene = scene
        }

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        view.backgroundColor = .white
        view.isUserInteractionEnabled = true
        
        controlView.infoButton.addTarget(self, action: #selector(infoHandler), for: .touchUpInside)
        controlView.valueSlider.addTarget(self, action: #selector(sliderChanged), for: .valueChanged)
        controlView.valueSlider.maximumValue = Float(maxNodeValue)
        controlView.valueSlider.value = ceil(maxNodeValue / 2)
        sliderChanged()
        iterationSliderChange()
        controlView.valueField.delegate = self
        controlView.iterationSlider.addTarget(self, action: #selector(iterationSliderChange), for: .valueChanged)
        
        controlView.undoButton.addTarget(self, action: #selector(undoButtonHandler), for: .touchUpInside)
        controlView.insertButton.addTarget(self, action: #selector(insertHandler), for: .touchUpInside)
        controlView.searchButton.addTarget(self, action: #selector(searchHandler), for: .touchUpInside)
        controlView.paretoButton.addTarget(self, action: #selector(paretoHandler), for: .touchUpInside)
        
        
        view.addSubview(controlView)
        
        controlView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            controlView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            controlView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            controlViewBottomAnchor,
            controlView.heightAnchor.constraint(equalToConstant: kControlViewHeight)
        ])
        for _ in 0..<20 {
            let rand = Int.random(in: 0...300)
            tree.insert(tag: rand)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func insertHandler(_ sender: UIButton) {
        guard let text = controlView.valueField.text else { return }
        if let tag = Int(text) {
            tree.insert(tag: tag)
        } else if text.hasPrefix("$") {
            let index = text.firstIndex { $0 != "$" }!
            let substring = text[index...]
            guard let iterations = Int(substring) else { return }
            for _ in 0..<iterations {
                tree.insert(tag: Int.random(in: 0..<Int(controlView.valueSlider.value)))
            }
        }
        resignFirstResponder()
        controlView.valueField.endEditing(true)
        controlView.valueField.text = ""
    }
    
// MARK: Not fully functional
    @objc func undoButtonHandler(_ sender: UIButton) {
        guard let delNode = tree.nodes.last else { return }
        tree.delete(node: delNode)
    }
    
    @objc func iterationSliderChange() {
        controlView.iterationSliderLabel.text = "\(Int(controlView.iterationSlider.value)) Iterations"
    }
    
    @objc func searchHandler(_ sender: UIButton) {
        guard let text = controlView.valueField.text,
            let num = Int(text) else { return }
        let iterations = Int(controlView.iterationSlider.value)
        if iterations > 0 {
            for _ in 0..<iterations { tree.query(tag: num) }
            return
        }
        tree.query(tag: num)
    }
    
    @objc func paretoHandler(_ sender: UIButton) {
        let num = Int(controlView.iterationSlider.value)
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
    
    @objc func keyboardWillAppear(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let height = keyboardFrame.cgRectValue.height
            if controlViewBottomAnchor.constant == 0 {
                controlViewBottomAnchor.constant = -height
            }
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillDisappear(_ notification: Notification) {
        controlViewBottomAnchor.constant = 0
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func sliderChanged() {
        controlView.sliderValueLabel.text = String(Int(controlView.valueSlider.value))
    }
    
    @objc func infoHandler(_ sender: UIButton) {
        //
    }
}

extension AnimationController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        resignFirstResponder()
        return true
    }
}


