//
//  Tree.swift
//  KTree
//
//  Created by Kyle Burns on 8/26/21.
//  Copyright © 2021 Kyle Burns. All rights reserved.
//

import Foundation

//public protocol BinaryEncodable {
//    func encode(to: BinaryEncoder)
//}
//
//public protocol BinaryDecodable {
//    init(from decoder: BinaryDecoder)
//}
//
//public typealias BinaryCodable = BinaryDecodable & BinaryEncodable

//public struct IndexNode<T: BinaryCodable>: Identifiable {
//    public var id: Int64
//    public var left: Int64
//    public var right: Int64
//    public var parent: Int64
//    public var weight: Double
//    public var timestamp: Double
//    public var data: T
//}




    
public struct User: Identifiable, Codable {
    public var id: String = ""
    public var firstName: String = ""
    public var lastName: String = ""
}



//extension User: BinaryCodable {
//    public func encode(to encoder: BinaryEncoder) {
//        encoder.encode(anyType: self)
//    }
//
//    public init(from decoder: BinaryDecoder) {
//        decoder.read(into: &self)
//    }
//}


open class CollectionReference: Query {
    private var tree: Tree
    public override init() {
        tree = Tree()
        super.init()
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(String(hashValue))
        tree.setStoragePathWith(url)
    }
    
    public init(_ path: String) {
        tree = Tree()
        super.init()
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(path)
        print(url)
        tree.setStoragePathWith(url)
    }
    
    open func addDocument<T: Codable & Identifiable>(from: T, forKeyPath keyPath: String) throws {
        let data = try JSONEncoder().encode(from)
        tree.addDocument(from: data, forKeyPath: keyPath)
    }
    
    open func addDocument<T: Codable & Identifiable>(from: T) throws {
        try addDocument(from: from, forKeyPath: UUID().uuidString)
    }
 
    open func getDocument<T: Codable & Identifiable>(forKeyPath keyPath: String) -> T? {
        try? JSONDecoder().decode(T.self, from: tree.getDocumentAtKeyPath(keyPath))
    }
    
//    func getDocument<T: BinaryCodable>(_ path: String) -> T {
//        let pointer = UnsafeMutablePointer<UInt8>.allocate(capacity: MemoryLayout<T>.size)
//        get_document(tree, path.hashValue, pointer, MemoryLayout<T>.size)
//        let bufferPointer = UnsafeMutableBufferPointer(start: pointer, count: MemoryLayout<T>.size)
//        let data = Data(buffer: bufferPointer)
//        let result = T(from: BinaryDecoder(data: data))
//        return result
//    }
    
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
    
    open func setData<T: Codable>(from: T) -> Bool {
        return false
    }
    
    open func updateData(data: [String: Any]) -> Bool {
        return false
    }
    
    open func data<T: Codable>() -> T? {
        return nil
    }
}

open class Query: NSObject {
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
