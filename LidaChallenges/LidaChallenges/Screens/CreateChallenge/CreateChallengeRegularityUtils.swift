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
}
