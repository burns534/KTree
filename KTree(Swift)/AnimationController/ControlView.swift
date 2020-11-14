//
//  ControlView.swift
//  KTree(Swift)
//
//  Created by Kyle Burns on 11/12/20.
//  Copyright © 2020 Kyle Burns. All rights reserved.
//

import UIKit

fileprivate let buttonWidthMultiplier: CGFloat = 0.3
fileprivate let buttonHeightMultiplier: CGFloat = 0.4

class ControlView: UIView {
    
    let valueField = PaddedTextField()
    let iterationSliderLabel = UILabel()
    let iterationSlider = UISlider()
    let insertButton = UIButton()
    let searchButton = UIButton()
    let paretoButton = UIButton()
    let undoButton = UIButton()
    let valueSlider = UISlider()
    let infoButton = UIButton()
    let sliderValueLabel = UILabel()
    
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
        
        valueSlider.minimumTrackTintColor = .blue
        valueSlider.minimumValue = 0.0
        valueSlider.translatesAutoresizingMaskIntoConstraints = false
        
        sliderValueLabel.font = UIFont.systemFont(ofSize: 20, weight: .thin)
        sliderValueLabel.text = String(Int(valueSlider.value))
        sliderValueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        valueField.setPadding(.standard)
        valueField.backgroundColor = .darkWhite
        valueField.placeholder = "Enter Value"
        valueField.textAlignment = .center
        valueField.layer.cornerRadius = 5
        valueField.translatesAutoresizingMaskIntoConstraints = false

        iterationSliderLabel.font = UIFont.systemFont(ofSize: 20, weight: .thin)
        iterationSliderLabel.translatesAutoresizingMaskIntoConstraints = false
        
        iterationSlider.minimumTrackTintColor = .blue
        iterationSlider.minimumValue = 0
        iterationSlider.maximumValue = 2000
        iterationSlider.value = 1000
        iterationSlider.translatesAutoresizingMaskIntoConstraints = false
        
        undoButton.setTitle("Undo", for: .normal)
        undoButton.setTitleColor(.white, for: .normal)
        undoButton.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .light)
        undoButton.setShadow(radius: 5, color: .darkGray, opacity: 0.4, offset: CGSize(width: 0, height: 5))
        undoButton.layer.cornerRadius = 5
        undoButton.backgroundColor = .blue
        undoButton.translatesAutoresizingMaskIntoConstraints = false
        
        insertButton.setTitle("Insert", for: .normal)
        insertButton.setTitleColor(.white, for: .normal)
        insertButton.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .light)
        insertButton.layer.cornerRadius = 5
        insertButton.setShadow(radius: 5, color: .darkGray, opacity: 0.4, offset: CGSize(width: 0, height: 5))
        insertButton.backgroundColor = .blue
        insertButton.translatesAutoresizingMaskIntoConstraints = false
        
        searchButton.setTitle("Search", for: .normal)
        searchButton.setTitleColor(.white, for: .normal)
        searchButton.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .light)
        searchButton.layer.cornerRadius = 5
        searchButton.setShadow(radius: 5, color: .darkGray, opacity: 0.4, offset: CGSize(width: 0, height: 5))
        searchButton.backgroundColor = .blue
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        
        paretoButton.setTitle("Pareto", for: .normal)
        paretoButton.setTitleColor(.white, for: .normal)
        paretoButton.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .light)
        paretoButton.layer.cornerRadius = 5
        paretoButton.setShadow(radius: 5, color: .darkGray, opacity: 0.4, offset: CGSize(width: 0, height: 5))
        paretoButton.backgroundColor = .blue
        paretoButton.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(infoButton)
        addSubview(valueSlider)
        addSubview(sliderValueLabel)
        addSubview(valueField)
        addSubview(iterationSliderLabel)
        addSubview(iterationSlider)
        addSubview(undoButton)
        addSubview(insertButton)
        addSubview(searchButton)
        addSubview(paretoButton)
        
        
        NSLayoutConstraint.activate([
            sliderValueLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            sliderValueLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            
            infoButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            infoButton.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            
            valueSlider.topAnchor.constraint(equalTo: sliderValueLabel.bottomAnchor, constant: 10),
            valueSlider.centerXAnchor.constraint(equalTo: centerXAnchor),
            valueSlider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),
            valueSlider.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50),
            
            valueField.topAnchor.constraint(equalTo: valueSlider.bottomAnchor, constant: 10),
            valueField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            valueField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: buttonWidthMultiplier),
            valueField.heightAnchor.constraint(equalTo: valueField.widthAnchor, multiplier: buttonHeightMultiplier),
            
            insertButton.topAnchor.constraint(equalTo: valueField.bottomAnchor, constant: 10),
            insertButton.leadingAnchor.constraint(equalTo: valueField.leadingAnchor),
            insertButton.widthAnchor.constraint(equalTo: valueField.widthAnchor),
            insertButton.heightAnchor.constraint(equalTo: valueField.heightAnchor),

            undoButton.topAnchor.constraint(equalTo: insertButton.bottomAnchor, constant: 10),
            undoButton.leadingAnchor.constraint(equalTo: valueField.leadingAnchor),
            undoButton.widthAnchor.constraint(equalTo: valueField.widthAnchor),
            undoButton.heightAnchor.constraint(equalTo: valueField.heightAnchor),
            
            iterationSliderLabel.topAnchor.constraint(equalTo: valueField.topAnchor),
            iterationSliderLabel.centerXAnchor.constraint(equalTo: iterationSlider.centerXAnchor),

            iterationSlider.topAnchor.constraint(equalTo: iterationSliderLabel.bottomAnchor),
            iterationSlider.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            iterationSlider.widthAnchor.constraint(equalTo: valueField.widthAnchor),
            
            searchButton.topAnchor.constraint(equalTo: insertButton.topAnchor),
            searchButton.trailingAnchor.constraint(equalTo: iterationSlider.trailingAnchor),
            searchButton.widthAnchor.constraint(equalTo: valueField.widthAnchor),
            searchButton.heightAnchor.constraint(equalTo: valueField.heightAnchor),

            paretoButton.topAnchor.constraint(equalTo: undoButton.topAnchor),
            paretoButton.trailingAnchor.constraint(equalTo: iterationSlider.trailingAnchor),
            paretoButton.widthAnchor.constraint(equalTo: valueField.widthAnchor),
            paretoButton.heightAnchor.constraint(equalTo: valueField.heightAnchor)
        ])
    }
}
