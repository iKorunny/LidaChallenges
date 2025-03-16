//
//  Ceasar.swift
//  LidaChallenges
//
//  Created by Лидия on 16.03.25.
//

import Foundation

extension String {
    var codePoint: UInt32? {
        guard self.unicodeScalars.count == 1 else { return nil }

        return self.unicodeScalars.first?.value
    }

    func mapCodePoints(fn: (UInt32) -> UInt32) -> String {
        return String(self.unicodeScalars.map { Character(UnicodeScalar(fn($0.value)) ?? "0") })
    }
}

final class Ceasar {
    static func rotate(code: UInt32, by offset: Int, withAdjustment adj: UInt32) -> UInt32 {
        let azLength = 26
        let normalizedOffset = UInt32((offset % azLength + azLength) % azLength)
        
        return adj + ((code - adj + normalizedOffset) % UInt32(azLength))
    }
    
    static func caesarize(str: String, withOffset offset: Int) -> String {
        let A = "A".codePoint!, Z = "Z".codePoint!,
            a = "a".codePoint!, z = "z".codePoint!

        return str.mapCodePoints { code -> UInt32 in
            switch code {
            case A...Z:
                return rotate(code: code, by: offset, withAdjustment: A)
            case a...z:
                return rotate(code: code, by: offset, withAdjustment: a)
            default:
                return code
            }
        }
    }
}
