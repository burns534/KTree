//
//  BinaryDecoder.swift
//  KTree
//
//  Created by Kyle Burns on 8/28/21.
//  Copyright © 2021 Kyle Burns. All rights reserved.
//

import Foundation

open class BinaryDecoder {
    private var data: [UInt8]
    private var cursor = 0
    
    public init(data: [UInt8]) {
        self.data = data
    }
    
    func read<T>(into: inout T) {
        let byteCount = MemoryLayout<T>.size
        data.withUnsafeBytes { pointer in
            if let start = pointer.baseAddress,
               cursor + byteCount < data.count {
                memcpy(&into, start + cursor, byteCount)
                cursor += byteCount
        }
    }
    
    func decode(_ type: Float.Type) -> Float {
        var swapped = CFSwappedFloat32()
        read(into: &swapped)
        return CFConvertFloatSwappedToHost(swapped)
    }

    func decode(_ type: Double.Type) -> Double {
        var swapped = CFSwappedFloat64()
        read(into: &swapped)
        return CFConvertDoubleSwappedToHost(swapped)
    }
}
