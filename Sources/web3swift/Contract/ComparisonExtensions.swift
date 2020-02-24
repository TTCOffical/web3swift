//
//  ComparisonExtensions.swift
//  web3swift
//
//  Created by Alexander Vlasov on 09.05.2018.
//  Copyright © 2018 Bankex Foundation. All rights reserved.
//

import BigInt
import Foundation

extension BigUInt: EventFilterComparable {
    public func isEqualTo(_ other: AnyObject) -> Bool {
        switch other {
        case let oth as BigUInt:
            return self == oth
        case let oth as BigInt:
            return magnitude == oth.magnitude && signum() == oth.signum()
        default:
            return false
        }
    }
}

extension BigInt: EventFilterComparable {
    public func isEqualTo(_ other: AnyObject) -> Bool {
        switch other {
        case let oth as BigInt:
            return self == oth
        case let oth as BigUInt:
            return magnitude == oth.magnitude && signum() == oth.signum()
        default:
            return false
        }
    }
}

extension String: EventFilterComparable {
    public func isEqualTo(_ other: AnyObject) -> Bool {
        switch other {
        case let oth as String:
//            return data.keccak256() == oth.data.keccak256()
            return TWTool.keccak256(data) == TWTool.keccak256(oth.data)
        case let oth as Data:
            return TWTool.keccak256(data) == TWTool.keccak256(oth)
        default:
            return false
        }
    }
}

extension Data: EventFilterComparable {
    public func isEqualTo(_ other: AnyObject) -> Bool {
        switch other {
        case let oth as String:
            guard let data = Data.fromHex(oth) else { return false }
            if self == data {
                return true
            }
//            let hash = data.keccak256()
            let hash = TWTool.keccak256(data)
            return self == hash
        case let oth as Data:
            if self == oth {
                return true
            }
//            let hash = oth.keccak256()
            let hash = TWTool.keccak256(oth)
            return self == hash
        default:
            return false
        }
    }
}

extension Address: EventFilterComparable {
    public func isEqualTo(_ other: AnyObject) -> Bool {
        switch other {
        case let oth as String:
            let addr = Address(oth)
            return self == addr
        case let oth as Data:
            let addr = Address(oth)
            return self == addr
        case let oth as Address:
            return self == oth
        default:
            return false
        }
    }
}
