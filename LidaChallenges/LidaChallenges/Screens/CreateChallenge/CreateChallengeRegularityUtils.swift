//
//  CreateChallengeRegularityUtils.swift
//  LidaChallenges
//
//  Created by Ihar Karunny on 7/25/24.
//

import Foundation

final class CreateChallengeRegularityUtils {
    static func regularityToString(_ regularity: Set<CreateChallengeRegularityType>) -> String {
        let intersection = regularity.intersection(CreateChallengeRegularityType.allValues())
        if intersection.count == CreateChallengeRegularityType.allValues().count {
            return "CreateChallengeRegularityDaily".localised()
        }
        else {
            return regularity.sorted(by: { $0.rawValue < $1.rawValue }).map({ $0.stringValue() }).joined(separator: ", ")
        }
    }
    
    static func regularityToInfoString(_ regularity: Set<CreateChallengeRegularityType>) -> String {
        let intersection = regularity.intersection(CreateChallengeRegularityType.allValues())
        if intersection.count == CreateChallengeRegularityType.allValues().count {
            return "ChallengeInfoRegularityDaily".localised()
        }
        else {
            let result = regularity.sorted(by: { $0.rawValue < $1.rawValue }).map({ $0.stringValue() }).joined(separator: ", ")
            let first = String(result.prefix(1))
            let other = String(result.dropFirst())
            
            return (first + other.lowercased())
        }
    }
}
