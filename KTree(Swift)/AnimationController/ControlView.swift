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
fileprivate let singleFieldButtonWidthMultiplier: CGFloat = 0.4
fileprivate let doubleFieldButtonWidthMultiplier: CGFloat = 0.25

class ControlView: UIView {
    
    let searchValueField = PaddedTextField()
    let insertValueField = PaddedTextField()
    let deleteValueField = PaddedTextField()
    let searchIterationField = PaddedTextField()
    let populateRangeStartField = PaddedTextField()
    let populateRangeEndField = PaddedTextField()
    let populateIterationField = PaddedTextField()
//    let iterationSliderLabel = UILabel()
//    let iterationSlider = UISlider()
    let populateButton = UIButton()
    let insertButton = UIButton()
    let searchButton = UIButton()
    let deleteButton = UIButton()
    let paretoButton = UIButton()
    let undoButton = UIButton()
//    let valueSlider = UISlider()
    let infoButton = UIButton()
//    let sliderValueLabel = UILabel()
    
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
        
        searchValueField.setPadding(.standard)
        searchValueField.backgroundColor = .darkWhite
        searchValueField.placeholder = "Value"
        searchValueField.textAlignment = .center
        searchValueField.layer.cornerRadius = 5
        searchValueField.translatesAutoresizingMaskIntoConstraints = false
        
        insertValueField.setPadding(.standard)
        insertValueField.backgroundColor = .darkWhite
        insertValueField.placeholder = "Value"
        insertValueField.textAlignment = .center
        insertValueField.layer.cornerRadius = 5
        insertValueField.translatesAutoresizingMaskIntoConstraints = false
        
        deleteValueField.setPadding(.standard)
        deleteValueField.backgroundColor = .darkWhite
        deleteValueField.placeholder = "Value"
        deleteValueField.textAlignment = .center
        deleteValueField.layer.cornerRadius = 5
        deleteValueField.translatesAutoresizingMaskIntoConstraints = false
        
        searchIterationField.setPadding(.standard)
        searchIterationField.backgroundColor = .darkWhite
        searchIterationField.placeholder = "Iterations"
        searchIterationField.textAlignment = .center
        searchIterationField.layer.cornerRadius = 5
        searchIterationField.translatesAutoresizingMaskIntoConstraints = false
        
        populateRangeStartField.setPadding(.standard)
        populateRangeStartField.backgroundColor = .darkWhite
        populateRangeStartField.placeholder = "From"
        populateRangeStartField.textAlignment = .center
        populateRangeStartField.layer.cornerRadius = 5
        populateRangeStartField.translatesAutoresizingMaskIntoConstraints = false
        
        populateRangeEndField.setPadding(.standard)
        populateRangeEndField.backgroundColor = .darkWhite
        populateRangeEndField.placeholder = "To"
        populateRangeEndField.textAlignment = .center
        populateRangeEndField.layer.cornerRadius = 5
        populateRangeEndField.translatesAutoresizingMaskIntoConstraints = false
        
        populateIterationField.setPadding(.standard)
        populateIterationField.backgroundColor = .darkWhite
        populateIterationField.placeholder = "Value"
        populateIterationField.textAlignment = .center
        populateIterationField.layer.cornerRadius = 5
        populateIterationField.translatesAutoresizingMaskIntoConstraints = false
        
        populateButton.setTitle("Populate", for: .normal)
        populateButton.setTitleColor(.white, for: .normal)
        populateButton.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .light)
        populateButton.layer.cornerRadius = 5
        populateButton.setShadow(radius: 5, color: .darkGray, opacity: 0.4, offset: CGSize(width: 0, height: 5))
        populateButton.backgroundColor = .blue
        populateButton.translatesAutoresizingMaskIntoConstraints = false
        
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
        
        deleteButton.setTitle("Delete", for: .normal)
        deleteButton.setTitleColor(.white, for: .normal)
        deleteButton.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .light)
        deleteButton.layer.cornerRadius = 5
        deleteButton.setShadow(radius: 5, color: .darkGray, opacity: 0.4, offset: CGSize(width: 0, height: 5))
        deleteButton.backgroundColor = .blue
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        
        paretoButton.setTitle("Pareto", for: .normal)
        paretoButton.setTitleColor(.white, for: .normal)
        paretoButton.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .light)
        paretoButton.layer.cornerRadius = 5
        paretoButton.setShadow(radius: 5, color: .darkGray, opacity: 0.4, offset: CGSize(width: 0, height: 5))
        paretoButton.backgroundColor = .blue
        paretoButton.translatesAutoresizingMaskIntoConstraints = false
        
        undoButton.setTitle("Undo", for: .normal)
        undoButton.setTitleColor(.white, for: .normal)
        undoButton.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .light)
        undoButton.setShadow(radius: 5, color: .darkGray, opacity: 0.4, offset: CGSize(width: 0, height: 5))
        undoButton.layer.cornerRadius = 5
        undoButton.backgroundColor = .blue
        undoButton.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(infoButton)
        addSubview(insertValueField)
        addSubview(searchValueField)
        addSubview(deleteValueField)
        addSubview(searchIterationField)
        addSubview(populateIterationField)
        addSubview(populateRangeStartField)
        addSubview(populateRangeEndField)
        
        addSubview(populateButton)
        addSubview(insertButton)
        addSubview(searchButton)
        addSubview(deleteButton)
        addSubview(paretoButton)
        addSubview(undoButton)
        
        
        NSLayoutConstraint.activate([
            undoButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            undoButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            undoButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            undoButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: buttonHeightMultiplier),
            
            paretoButton.bottomAnchor.constraint(equalTo: undoButton.topAnchor, constant: -buttonLineSpacing),
            paretoButton.leadingAnchor.constraint(equalTo: undoButton.leadingAnchor),
            paretoButton.trailingAnchor.constraint(equalTo: undoButton.trailingAnchor),
            paretoButton.heightAnchor.constraint(equalTo: undoButton.heightAnchor),
            
            deleteButton.bottomAnchor.constraint(equalTo: paretoButton.topAnchor, constant: -buttonLineSpacing),
            deleteButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            deleteButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: singleFieldButtonWidthMultiplier),
            deleteButton.heightAnchor.constraint(equalTo: undoButton.heightAnchor),
            
            deleteValueField.bottomAnchor.constraint(equalTo: deleteButton.bottomAnchor),
            deleteValueField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            deleteValueField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: singleFieldButtonWidthMultiplier),
            deleteValueField.heightAnchor.constraint(equalTo: deleteButton.heightAnchor),
            
            insertButton.bottomAnchor.constraint(equalTo: deleteButton.topAnchor, constant: -buttonLineSpacing),
            insertButton.leadingAnchor.constraint(equalTo: deleteButton.leadingAnchor),
            insertButton.widthAnchor.constraint(equalTo: deleteButton.widthAnchor),
            insertButton.heightAnchor.constraint(equalTo: deleteButton.heightAnchor),
            
            insertValueField.bottomAnchor.constraint(equalTo: insertButton.bottomAnchor),
            insertValueField.trailingAnchor.constraint(equalTo: deleteValueField.trailingAnchor),
            insertValueField.widthAnchor.constraint(equalTo: deleteValueField.widthAnchor),
            insertValueField.heightAnchor.constraint(equalTo: deleteValueField.heightAnchor),
            
            searchButton.bottomAnchor.constraint(equalTo: insertButton.topAnchor, constant: -buttonLineSpacing),
            searchButton.leadingAnchor.constraint(equalTo: insertButton.leadingAnchor),
            searchButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: doubleFieldButtonWidthMultiplier),
            searchButton.heightAnchor.constraint(equalTo: insertButton.heightAnchor),
            
            searchValueField.bottomAnchor.constraint(equalTo: searchButton.bottomAnchor),
            searchValueField.centerXAnchor.constraint(equalTo: centerXAnchor),
            searchValueField.widthAnchor.constraint(equalTo: searchButton.widthAnchor),
            searchValueField.heightAnchor.constraint(equalTo: searchButton.heightAnchor),
            
            searchIterationField.bottomAnchor.constraint(equalTo: searchButton.bottomAnchor),
            searchIterationField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            searchIterationField.widthAnchor.constraint(equalTo: searchValueField.widthAnchor),
            searchIterationField.heightAnchor.constraint(equalTo: searchValueField.heightAnchor)
        ])
    }
}
