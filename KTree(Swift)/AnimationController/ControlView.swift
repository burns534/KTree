//
//  ControlView.swift
//  KTree(Swift)
//
//  Created by Kyle Burns on 11/12/20.
//  Copyright © 2020 Kyle Burns. All rights reserved.
//

import UIKit

fileprivate let buttonHeightMultiplier: CGFloat = 0.1
fileprivate let buttonLineSpacing: CGFloat = 8.0
fileprivate let buttonWidthMultiplier: CGFloat = 0.38

class ControlView: UIView {
    
    let picker = UIPickerView()
    
    let valueField = PaddedTextField()
    let iterationField = PaddedTextField()
    let startField = PaddedTextField()
    let endField = PaddedTextField()
    let undoButton = UIButton()
    let infoButton = UIButton()
    let performButton = UIButton()
    
    var iterationFieldTopAnchorOne: NSLayoutConstraint!
    var iterationFieldTopAnchorTwo: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createSubviews() {
        backgroundColor = UIColor.white.withAlphaComponent(0.7)
        setShadow(radius: 10)
        layer.cornerRadius = 10
        layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        let config = UIImage.SymbolConfiguration(pointSize: 25, weight: .thin)
        let image = UIImage(systemName: "info.circle", withConfiguration: config)?.withRenderingMode(.alwaysTemplate)
        infoButton.setImage(image, for: .normal)
        infoButton.imageView?.tintColor = .blue
        infoButton.translatesAutoresizingMaskIntoConstraints = false
        
        picker.translatesAutoresizingMaskIntoConstraints = false
        
        valueField.setPadding(.standard)
        valueField.backgroundColor = .darkWhite
        valueField.placeholder = "Value"
        valueField.textAlignment = .center
        valueField.layer.cornerRadius = 5
        valueField.translatesAutoresizingMaskIntoConstraints = false
        
        iterationField.setPadding(.standard)
        iterationField.backgroundColor = .darkWhite
        iterationField.placeholder = "Iterations"
        iterationField.textAlignment = .center
        iterationField.layer.cornerRadius = 5
        iterationField.translatesAutoresizingMaskIntoConstraints = false
        
//        iterationFieldTopAnchorOne = NSLayoutConstraint(item: iterationField, attribute: .top, relatedBy: .equal, toItem: valueField, attribute: .bottom, multiplier: 1.0, constant: 0.0)
//        iterationFieldTopAnchorTwo = NSLayoutConstraint(item: iterationField, attribute: .top, relatedBy: .equal, toItem: picker, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        
        startField.setPadding(.standard)
        startField.backgroundColor = .darkWhite
        startField.placeholder = "From"
        startField.textAlignment = .center
        startField.layer.cornerRadius = 5
        startField.translatesAutoresizingMaskIntoConstraints = false
        
        endField.setPadding(.standard)
        endField.backgroundColor = .darkWhite
        endField.placeholder = "To"
        endField.textAlignment = .center
        endField.layer.cornerRadius = 5
        endField.translatesAutoresizingMaskIntoConstraints = false
    
        undoButton.setTitle("Undo", for: .normal)
        undoButton.setTitleColor(.white, for: .normal)
        undoButton.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .light)
        undoButton.setShadow(radius: 5, color: .darkGray, opacity: 0.4, offset: CGSize(width: 0, height: 5))
        undoButton.layer.cornerRadius = 5
        undoButton.backgroundColor = .blue
        undoButton.translatesAutoresizingMaskIntoConstraints = false
        
        performButton.setTitle("Perform", for: .normal)
        performButton.setTitleColor(.white, for: .normal)
        performButton.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .light)
        performButton.setShadow(radius: 5, color: .darkGray, opacity: 0.4, offset: CGSize(width: 0, height: 5))
        performButton.layer.cornerRadius = 5
        performButton.backgroundColor = .blue
        performButton.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(infoButton)
        addSubview(valueField)
        addSubview(iterationField)
        addSubview(startField)
        addSubview(endField)
        addSubview(picker)
        addSubview(undoButton)
        addSubview(performButton)
        
        NSLayoutConstraint.activate([
            infoButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            infoButton.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            
            picker.topAnchor.constraint(equalTo: topAnchor, constant: buttonLineSpacing),
            picker.centerXAnchor.constraint(equalTo: centerXAnchor),
            picker.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
            picker.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.4),
            
            valueField.topAnchor.constraint(equalTo: picker.bottomAnchor, constant: buttonLineSpacing),
            valueField.leadingAnchor.constraint(equalTo: picker.leadingAnchor),
            valueField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: buttonWidthMultiplier),
            valueField.heightAnchor.constraint(equalTo: heightAnchor, multiplier: buttonHeightMultiplier),
            
            iterationField.topAnchor.constraint(equalTo: valueField.topAnchor),
            iterationField.trailingAnchor.constraint(equalTo: picker.trailingAnchor),
            iterationField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: buttonWidthMultiplier),
            iterationField.heightAnchor.constraint(equalTo: heightAnchor, multiplier: buttonHeightMultiplier),
            
            startField.topAnchor.constraint(equalTo: iterationField.bottomAnchor, constant: buttonLineSpacing),
            startField.leadingAnchor.constraint(equalTo: valueField.leadingAnchor),
            startField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: buttonWidthMultiplier),
            startField.heightAnchor.constraint(equalTo: heightAnchor, multiplier: buttonHeightMultiplier),
            
            endField.topAnchor.constraint(equalTo: iterationField.bottomAnchor, constant: buttonLineSpacing),
            endField.trailingAnchor.constraint(equalTo: iterationField.trailingAnchor),
            endField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: buttonWidthMultiplier),
            endField.heightAnchor.constraint(equalTo: heightAnchor, multiplier: buttonHeightMultiplier),
            
            performButton.topAnchor.constraint(equalTo: endField.bottomAnchor, constant: buttonLineSpacing),
            performButton.leadingAnchor.constraint(equalTo: valueField.leadingAnchor),
            performButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: buttonWidthMultiplier),
            performButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: buttonHeightMultiplier),
            
            undoButton.topAnchor.constraint(equalTo: performButton.topAnchor),
            undoButton.trailingAnchor.constraint(equalTo: iterationField.trailingAnchor),
            undoButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: buttonWidthMultiplier),
            undoButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: buttonHeightMultiplier)
        ])
    }
}
