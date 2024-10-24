//
//  BuiltInConfig.swift
//  LidaChallenges
//
//  Created by Ihar Karunny on 10/24/24.
//

import Foundation

struct BuiltInConfig: Decodable {
    private enum CodingKeys: String, CodingKey {
        case version
        case challenges
    }
    
    let version: Double
    let challenges: [BuiltInChallengeConfig]
}

struct BuiltInChallengeConfig: Decodable {
    private enum CodingKeys: String, CodingKey {
        case subtitleKey
        case regularity
        case nameKey
        case identifier
        case iconName
        case descriptionKey
        case categoryID
        case daysCount
    }
    
    let subtitleKey: String?
    let regularity: [Int]
    let nameKey: String
    let identifier: String
    let iconName: String?
    let descriptionKey: String?
    let categoryID: Int
    let daysCount: Int
}
