//
//  Tree.swift
//  KTree
//
//  Created by Kyle Burns on 8/26/21.
//  Copyright © 2021 Kyle Burns. All rights reserved.
//

import Foundation

public protocol BinaryEncodable {
    func encode(to: BinaryEncoder)
}

public protocol BinaryDecodable {
    init(from decoder: BinaryDecoder)
}

public typealias BinaryCodable = BinaryDecodable & BinaryEncodable

//public struct IndexNode<T: BinaryCodable>: Identifiable {
//    public var id: Int64
//    public var left: Int64
//    public var right: Int64
//    public var parent: Int64
//    public var weight: Double
//    public var timestamp: Double
//    public var data: T
//}




    
public struct User: Identifiable {
    public var id: String
    public var firstName: String
    public var lastName: String
}

extension User: BinaryCodable {
    public func encode(to encoder: BinaryEncoder) {
        encoder.encode(anyType: self)
    }
    
    public init(from decoder: BinaryDecoder) {
        decoder.read(into: &self)
    }
}

open class CollectionReference: Query {
    private var tree: UnsafeMutablePointer<CTree>
    public init(name: String) {
        let index_file = name + "_index.bin"
        let data_file = name + "_data.bin"
        var index_file_pointer: UnsafeRawPointer
        withUnsafeBytes(of: index_file.cString(using: .ascii)!) {
            index_file_pointer = $0.baseAddress!
        }
        
        var data_file_pointer: UnsafeRawPointer
        withUnsafeBytes(of: data_file.cString(using: .ascii)!) {
            data_file_pointer = $0.baseAddress!
        }
        
        tree = initialize_CTree(index_file_pointer, data_file_pointer)
    }
    
    open func addDocument<T: BinaryCodable & Identifiable>(from: T) -> Bool {
        let data = BinaryEncoder.encode(from)
//        var unsafePointer: UnsafeRawPointer
//        withUnsafeBytes(of: data) {
//            unsafePointer = $0.baseAddress!
//        }
        add_document(tree, from.id.hashValue, data, data.count)
        // maybe??
        return true
    }
    
    func getDocument<T: BinaryCodable>(_ path: String) -> T {
        let pointer = UnsafeMutablePointer<UInt8>.allocate(capacity: MemoryLayout<T>.size)
        get_document(tree, path.hashValue, pointer, MemoryLayout<T>.size)
        let bufferPointer = UnsafeMutableBufferPointer(start: pointer, count: MemoryLayout<T>.size)
        let data = Data(buffer: bufferPointer)
        
    }
    
    open func addDocument(data: [String: Any]) -> Bool {
        return false
    }
    
    open func removeDocument(_ key: String) -> Bool {
        return false
    }
    
    open func document(_ key: String) -> DocumentReference? {
        return nil
    }
    
    open func document() -> DocumentReference? {
        return nil
    }
}

open class DocumentReference {
    open var parent: CollectionReference?
    
    open func setData(data: [String: Any]) -> Bool {
        return false
    }
    
    open func setData<T: BinaryCodable>(from: T) -> Bool {
        return false
    }
    
    open func updateData(data: [String: Any]) -> Bool {
        return false
    }
    
    open func data<T: BinaryCodable>() -> T? {
        return nil
    }
}

open class Query {
    open func getDocuments() -> [DocumentReference]? {
        return nil
    }
    
    open func whereField(_ field: String, isEqualTo: Any) -> Query {
        return self
    }
    
    open func whereField(_ field: String, isNotEqualTo: Any) -> Query {
        return self
    }
    
    open func limit(to: Int) -> Query {
        return self
    }
    
    open func order(by field: String) -> Query {
        return self
    }
}


//open class Tree {
//    public static let tree: Tree = Tree()
//
//    open func collection(_ path: String) -> CollectionReference {
//        return CollectionReference()
//    }
//
//    open func addDocument<T: Encodable>(from value: T) -> Bool {
//        if let data = try? JSONEncoder().encode(value) {
//            var buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: data.count)
//            data.copyBytes(to: buffer, count: data.count)
//
//        }
//        return false
//    }
//
//    open func getDocuments() -> [DocumentReference] {
//        return [DocumentReference]()
//    }
//
//    open func setValue(_ value: Any, forKeyPath keyPath: String) -> Bool {
//        return false
//    }
//
//    open func deleteDocument(forKeyPath: String) -> Bool {
//        return false
//    }
//
//
//
//}
