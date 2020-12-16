//
//  File.swift
//  web3swift
//
//  Created by Dmitry on 05/12/2018.
//  Copyright © 2018 Bankex Foundation. All rights reserved.
//

import Foundation
import keccak

extension Data {
    
    /// - Returns: kaccak256 hash of data
    public func keccak256() -> Data {
        
        let result = UnsafeMutablePointer<UInt8>.allocate(capacity: 32)
        result.initialize(repeating: 0, count: 32)
        defer {
            result.deinitialize(count: 32)
            result.deallocate()
        }
        var buffer = [UInt8](self)
        keccak_256(result, 32, buffer, self.count)
        
        return Data(bytes: result, count: 32)
    }
}
