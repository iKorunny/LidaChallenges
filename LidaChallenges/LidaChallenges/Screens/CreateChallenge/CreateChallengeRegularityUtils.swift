//
//  CreateChallengeRegularityUtils.swift
//  LidaChallenges
//
//  Created by Ihar Karunny on 7/25/24.
//

import Foundation

final class CreateChallengeRegularityUtils {
    static func regularityToString(_ regularity: Set<ChallengeRegularityType>) -> String {
        let intersection = regularity.intersection(ChallengeRegularityType.allValues())
        if intersection.count == ChallengeRegularityType.allValues().count {
            return "CreateChallengeRegularityDaily".localised()
        }
        else {
            return regularity.sorted(by: { $0.rawValue < $1.rawValue }).map({ $0.stringValue() }).joined(separator: ", ")
        }
    }
    
    static func regularityToInfoString(_ regularity: Set<ChallengeRegularityType>) -> String {
        let intersection = regularity.intersection(ChallengeRegularityType.allValues())
        if intersection.count == ChallengeRegularityType.allValues().count {
            return "ChallengeInfoRegularityDaily".localised()
        }
        else {
            let result = regularity.sorted(by: { $0.rawValue < $1.rawValue }).map({ $0.infoStringValue() }).joined(separator: ", ")
            let first = String(result.prefix(1))
            let other = String(result.dropFirst())
            
            return (first + other.lowercased())
        }
    }
}
