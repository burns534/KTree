//
//  Pareto.swift
//  KTree(Swift)
//
//  Created by Kyle Burns on 8/24/20.
//  Copyright © 2020 Kyle Burns. All rights reserved.
//

import Foundation

final class Pareto {
    private var alpha: Double = 1.16
    private var min: Double = 1.0
    
    static let pareto = Pareto()
    
    init(alpha: Double = 1.16, min: Double = 1.0) {
        self.alpha = alpha
        self.min = min
    }
    
    func value(_ x: Double) -> Double {
        if x >= min {
            return pow(min / x, alpha)
        }
        return 1.0
    }
}

final class Probability {
    static func roll(_ value: Double) -> Bool {
        let i = Int.random(in: 0..<100)
        if value * 100 > Double(i) {
            return true
        }
        return false
    }
}
