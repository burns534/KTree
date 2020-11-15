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
    
    static let `default` = Pareto()
    
    init(alpha: Double = 1.16, min: Double = 1.0) {
        self.alpha = alpha
        self.min = min
    }
    
    func value(_ x: Double) -> Double {
        return x >= min ? pow(min / x, alpha) : 1.0
    }
    
    func value(_ x: Int) -> Double {
        let value = 50.0 * Double(UInt(bitPattern: x.hashValue)) / Double(UInt.max)
        return self.value(value)
    }
}

final class Probability {
    static func hit(_ value: Double) -> Bool {
        value > Double.random(in: 0...1.0)
    }
}
