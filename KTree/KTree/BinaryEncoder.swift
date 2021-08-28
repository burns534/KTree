//
//  BinaryEncoder.swift
//  KTree
//
//  Created by Kyle Burns on 8/28/21.
//  Copyright © 2021 Kyle Burns. All rights reserved.
//

import Foundation

open class BinaryEncoder {
    private var data: [UInt8] = []
    static func encode(_ value: BinaryCodable) -> [UInt8] {
        let encoder = BinaryEncoder()
        value.encode(to: encoder)
        return encoder.data
    }
    
    enum Error: Swift.Error {
            case typeNotConformingToBinaryEncodable(Encodable.Type)
            case typeNotConformingToEncodable(Any.Type)
        }
    
    func appendBytes<T>(of: T) {
            var target = of
            withUnsafeBytes(of: &target) {
                data.append(contentsOf: $0)
            }
        }
    
    func encode(_ value: Float) {
        appendBytes(of: CFConvertFloatHostToSwapped(value))
    }

    func encode(_ value: Double) {
        appendBytes(of: CFConvertDoubleHostToSwapped(value))
    }
    
    func encode(_ value: Bool) {
        appendBytes(of: value ? 1 as UInt8 : 0 as UInt8)
    }
    
    func encode(_ value: Int16) {
        appendBytes(of: value)
    }
    
    func encode(_ value: Int32) {
        appendBytes(of: value)
    }
    
    func encode(anyType value: Any) {
        appendBytes(of: value)
    }
    
//    func encode(_ encodable: Encodable) throws {
//        switch encodable {
//        case let v as Int:
//        default:
//            throw Error.typeNotConformingToBinaryEncodable(type(of: encodable))
//        }
//    }
}
