//
//  Sigmoid.swift
//  KTree(Swift)
//
//  Created by Kyle Burns on 8/21/20.
//  Copyright © 2020 Kyle Burns. All rights reserved.
//

import Foundation

final class Sigmoid {
    private var max: Double
    private var mid: Double
    private var k: Double
    private var offset: Double
    
    public static var `default`: Sigmoid = Sigmoid()
    
    init(max: Double = 1.0, mid: Double = 0, k: Double = 1.0) {
        self.max = max
        self.mid = mid
        self.k = k
        offset = max / (1 + exp(-k * (0 - mid)))
    }
    
    func value(_ value: Double) -> Double {
        return max / (1 + exp(-k * (value - mid))) - offset
    }
    
//    func dx(_ x: Double) -> Double {
//        return max * exp(-k * (x - mid)) * k / pow(1 + exp(-k * (x - mid)), 2)
//    }
}
