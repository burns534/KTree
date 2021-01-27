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

    var currentScene: Scene?

    override func viewDidLoad() {
        super.viewDidLoad()
        controlViewBottomAnchor = NSLayoutConstraint(item: controlView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0)

        let sceneView = SKView()
        view.addSubview(sceneView)
        sceneView.ignoresSiblingOrder = true
        let scene = Scene(size: UIScreen.main.bounds.size)
        scene.viewController = self
        scene.backgroundColor = .white
        scene.scaleMode = .aspectFill
        sceneView.isUserInteractionEnabled = true
        sceneView.presentScene(scene)
        sceneView.isMultipleTouchEnabled = true
        sceneView.showsFPS = true
        sceneView.showsNodeCount = true
        sceneView.showsQuadCount = true
        sceneView.showsDrawCount = true
        tree = AnimationTree(scene: scene)
        currentScene = scene
        
        sceneView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            sceneView.topAnchor.constraint(equalTo: view.topAnchor),
            sceneView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sceneView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sceneView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -kControlViewHeight)
        ])

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.view.backgroundColor = .white
        self.view.isUserInteractionEnabled = true
        
        controlView.translatesAutoresizingMaskIntoConstraints = false
        controlView.infoButton.addTarget(self, action: #selector(infoHandler), for: .touchUpInside)
        controlView.picker.dataSource = self
        controlView.picker.delegate = self
        controlView.picker.delegate?.pickerView?(controlView.picker, didSelectRow: 0, inComponent: 0)
        controlView.performButton.addTarget(self, action: #selector(performButtonHandler), for: .touchUpInside)
        controlView.undoButton.addTarget(self, action: #selector(undoButtonHandler), for: .touchUpInside)
        
        view.addSubview(controlView)
        
        NSLayoutConstraint.activate([
            controlView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            controlView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            controlViewBottomAnchor,
            controlView.heightAnchor.constraint(equalToConstant: kControlViewHeight)
        ])

        tree.batchInsert(iterations: 50, range: 500)
    }

    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func insertHandler(_ sender: UIButton) {
//        guard let text = controlView.valueField.text else { return }
//        if let tag = Int(text) {
//            tree.insert(tag: tag)
//        } else if text.hasPrefix("$") {
//            let index = text.firstIndex { $0 != "$" }!
//            let substring = text[index...]
//            guard let iterations = Int(substring) else { return }
//            for _ in 0..<iterations {
//                tree.insert(tag: Int.random(in: 0..<Int(controlView.valueSlider.value)))
//            }
//        }
//        resignFirstResponder()
//        controlView.valueField.endEditing(true)
//        controlView.valueField.text = ""
    }
    
// MARK: Not fully functional
    @objc func undoButtonHandler(_ sender: UIButton) {
        guard let delNode = tree.nodes.last else { return }
        tree.delete(node: delNode)
    }
    
    @objc func performButtonHandler() {
        switch controlView.picker.selectedRow(inComponent: 0) {
        case 0:
            guard let text = controlView.valueField.text, let value = Int(text) else { return }
            tree.insert(tag: value)
        case 2:
            guard let text = controlView.valueField.text, let value = Int(text) else { return }
            tree.delete(tag: value)
        default: exit(EXIT_FAILURE)
        }
        
        resignFirstResponder()
        controlView.endEditing(true)
    }

    @objc func searchHandler(_ sender: UIButton) {
//        guard let text = controlView.valueField.text,
//            let num = Int(text) else { return }
//        let iterations = Int(controlView.iterationSlider.value)
//        if iterations > 0 {
//            for _ in 0..<iterations { tree.query(tag: num) }
//            return
//        }
//        tree.query(tag: num)
    }
    
    @objc func paretoHandler(_ sender: UIButton) {
//        let num = Int(controlView.iterationSlider.value)
//        var count = 0
//        while count < num {
//            let index = Int.random(in: 0..<tree.nodes.count)
//            let p = Pareto.default.value(index)
//            if Probability.hit(p) {
//                count += 1
//                tree.query(tag: tree.nodes[index].tag)
//            }
//        }
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

fileprivate let options = ["Insert", "Search", "Delete", "Populate", "Pareto"]

extension AnimationController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        options.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        options[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        switch options[row] {
//        case "Insert":
////            controlView.iterationField.isHidden = true
////            controlView.valueField.isHidden = false
////            controlView.startField.isHidden = true
////            controlView.endField.isHidden = true
////            controlView.iterationFieldTopAnchorOne.isActive = true
////            controlView.iterationFieldTopAnchorTwo.isActive = false
//        case "Search":
////            controlView.iterationField.isHidden = false
////            controlView.valueField.isHidden = false
////            controlView.startField.isHidden = true
////            controlView.endField.isHidden = true
////            controlView.iterationFieldTopAnchorOne.isActive = true
////            controlView.iterationFieldTopAnchorTwo.isActive = false
//        case "Delete":
////            controlView.iterationField.isHidden = true
////            controlView.valueField.isHidden = false
////            controlView.startField.isHidden = true
////            controlView.endField.isHidden = true
////            controlView.iterationFieldTopAnchorOne.isActive = true
////            controlView.iterationFieldTopAnchorTwo.isActive = false
//        case "Populate":
////            controlView.iterationField.isHidden = false
////            controlView.valueField.isHidden = true
////            controlView.startField.isHidden = false
////            controlView.endField.isHidden = false
////            controlView.iterationFieldTopAnchorOne.isActive = false
////            controlView.iterationFieldTopAnchorTwo.isActive = true
//        case "Pareto":
////            controlView.iterationField.isHidden = false
////            controlView.valueField.isHidden = true
////            controlView.startField.isHidden = false
////            controlView.endField.isHidden = false
////            controlView.iterationFieldTopAnchorOne.isActive = false
////            controlView.iterationFieldTopAnchorTwo.isActive = true
//        default:
//            exit(EXIT_FAILURE)
//        }
    }
}



