//
//  Data+Extension.swift
//  web3swift
//
//  Created by Alexander Vlasov on 15.01.2018.
//  Copyright © 2018 Bankex Foundation. All rights reserved.
//

import Foundation
// import libsodium

public enum DataError: Error {
    case hexStringCorrupted(String)
    public var localizedDescription: String {
        switch self {
        case let .hexStringCorrupted(string):
            return "Cannot convert hex string \"\(string)\" to data"
        }
    }
}

public extension Data {
    init<T>(fromArray values: [T]) {
        var values = values
        self.init(buffer: UnsafeBufferPointer(start: &values, count: values.count))
    }

    func toArray<T>(type _: T.Type) -> [T] {
        return withUnsafeBytes {
            [T](UnsafeBufferPointer(start: $0, count: self.count / MemoryLayout<T>.stride))
        }
    }

    // Why do we need this?
    public func constantTimeComparisonTo(_ other: Data?) -> Bool {
        guard let rhs = other else { return false }
        guard count == rhs.count else { return false }
        var difference = UInt8(0x00)
        for i in 0 ..< count { // compare full length
            difference |= self[i] ^ rhs[i] // constant time
        }
        return difference == UInt8(0x00)
    }

    public static func zero(_ data: inout Data) {
        let count = data.count
        data.withUnsafeMutableBytes { (dataPtr: UnsafeMutablePointer<UInt8>) in
//            var rawPtr = UnsafeMutableRawPointer(dataPtr)
            //            sodium_memzero(rawPtr, count)
            dataPtr.initialize(repeating: 0, count: count)
        }
    }

    public static func random(length: Int) -> Data {
        var data = Data(repeating: 0, count: length)
        let result = data.withUnsafeMutableBytes {
            SecRandomCopyBytes(kSecRandomDefault, length, $0)
        }
        assert(result == errSecSuccess, "SecRandomCopyBytes crashed")
        return data
    }

    public static func fromHex(_ hex: String) -> Data? {
        let string = hex.lowercased().withoutHex
        let array = Array<UInt8>(hex: string)
        if array.count == 0 {
            if string == "" {
                return Data()
            } else {
                return nil
            }
        }
        return Data(array)
    }

    func bitsInRange(_ startingBit: Int, _ length: Int) -> UInt64? { // return max of 8 bytes for simplicity, non-public
        if startingBit + length / 8 > count, length > 64, startingBit > 0, length >= 1 { return nil }
        let bytes = self[(startingBit / 8) ..< (startingBit + length + 7) / 8]
        let padding = Data(repeating: 0, count: 8 - bytes.count)
        let padded = bytes + padding
        guard padded.count == 8 else { return nil }
        var uintRepresentation = UInt64(bigEndian: padded.withUnsafeBytes { $0.pointee })
        uintRepresentation = uintRepresentation << (startingBit % 8)
        uintRepresentation = uintRepresentation >> UInt64(64 - length)
        return uintRepresentation
    }
}