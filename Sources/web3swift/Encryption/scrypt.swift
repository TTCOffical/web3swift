//
//  scrypt.swift
//  web3swift
//
//  Created by Dmitry on 05/12/2018.
//  Copyright © 2018 Bankex Foundation. All rights reserved.
//

import Foundation
import scrypt

public func scrypt(password: String, salt: Data, length: Int, N: Int, R: Int, P: Int) -> Data? {
    let passwd = password.data
    var derivedKey: Data = Data(count: length)
    var derivedKeyLength = derivedKey.count
    let passwdLength = passwd.count
    let saltLength = salt.count
    var status: Int = try! passwd.withUnsafeBytes({ passwdBytes in
        return try! salt.withUnsafeBytes({ saltBytes in
            return try! derivedKey.withUnsafeMutableBytes({ derivedKeyBytes in
                return Int(crypto_scrypt(passwdBytes, passwdLength, saltBytes, saltLength, UInt64(N), UInt32(R), UInt32(P), derivedKeyBytes, derivedKeyLength))
            })
        })
    })
    guard status == 0 else { return nil }
    return derivedKey
}
