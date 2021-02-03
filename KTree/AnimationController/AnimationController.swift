//
//  AnimationController.swift
//  KTree(Swift)
//
//  Created by Kyle Burns on 8/14/20.
//  Copyright © 2020 Kyle Burns. All rights reserved.
//

import UIKit
import SpriteKit

class Command {
    static var accessQueue = [AnimationNode]()
    // only 3 fundamental types of commands
    enum CommandType {
        case insert, search, delete
    }
    let commandType: CommandType
    let value: Int?
    
    init(command: CommandType, value: Int? = nil, node: AnimationNode? = nil) {
        self.commandType = command
        self.value = value
        if let node = node {
            Command.accessQueue.append(node)
        }
    }
// queries need to be able to un-feed a node.
// deletions need to save the node in a queue in case undo happens
    func undo(tree: AnimationTree) {
        switch commandType {
        case .insert:
            guard let value = value else { return }
            tree.delete(tag: value)
        case .delete:
            guard let value = value else { return }
            // add insert function for direct insertion from accessQueue
        case .search:
            guard let value = value else { return }
            // Add un-feed mechanism. Basically save copies of the nodes that were most recently accessed...
        }
    }
}

let kControlViewHeightMultiplier: CGFloat = 0.35
let kControlViewHeight: CGFloat = kControlViewHeightMultiplier * UIScreen.main.bounds.height
fileprivate let options = ["Insert", "Search", "Delete", "Populate", "Pareto"]

class AnimationController: UIViewController {
    var tree: AnimationTree!
    let controlView = ControlView(frame: .zero)
    let commandQueue = [Command]()
    
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
        
        controlView.valueField.delegate = self
        controlView.iterationField.delegate = self
        controlView.startField.delegate = self
        controlView.endField.delegate = self
        
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
    
// TODO: Implement functionality with stack
    @objc func undoButtonHandler(_ sender: UIButton) {
        
    }
    
    @objc func performButtonHandler() {
        switch controlView.picker.selectedRow(inComponent: 0) {
        case 0:
            guard let text = controlView.valueField.text, let value = Int(text) else { return }
            tree.insert(tag: value)
        case 1: // search
            guard let text = controlView.valueField.text, let value = Int(text),
                  let iterationText = controlView.iterationField.text, let iterationValue = Int(iterationText) else { return }
            for _ in 0..<iterationValue {
                tree.search(tag: value) // handle success or failure with user error message
            }
        case 2: // delete
            guard let text = controlView.valueField.text, let value = Int(text) else { return }
            print("performing delete")
            tree.delete(tag: value)
        case 3: // populate
            guard let startText = controlView.startField.text, let start = Int(startText),
                  let endText = controlView.endField.text, let end = Int(endText),
                  let iterationText = controlView.iterationField.text, let iterationValue = Int(iterationText) else { return }
            for _ in 0..<iterationValue {
                tree.insert(tag: Int.random(in: start..<end))
            }
        case 4: // pareto
            guard let startText = controlView.startField.text, let start = Int(startText),
                  let endText = controlView.endField.text, let end = Int(endText),
                  let iterationText = controlView.iterationField.text, let iterationValue = Int(iterationText) else { return }
            var count = 0
            while count < iterationValue {
                let index = Int.random(in: 0..<Int(tree.count))
                let p = Pareto.default.value(Int(index))
                if Probability.hit(p) && tree.search(tag: index) {
                    count += 1
                }
            }
        default:
            exit(EXIT_FAILURE)
        }
        
        resignFirstResponder()
        controlView.endEditing(true)
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
}



