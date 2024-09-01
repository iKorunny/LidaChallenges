//
//  Challenge.swift
//  LidaChallenges
//
//  Created by Ihar Karunny on 9/1/24.
//

import Foundation
import UIKit

final class Challenge: Codable {
    enum CodingKeys: String, CodingKey {
        case identifier
        case title
        case subtitle
        case description
        case daysCount
        case regularity
        case icon
        case isCustom
    }
    
    let identifier: String
    let title: String
    let subtitle: String?
    let description: String?
    let daysCount: Int
    let regularity: Set<ChallengeRegularityType>
    let icon: UIImage?
    
    let isCustom: Bool
    
    init(identifier: String, 
         title: String,
         subtitle: String?,
         description: String?,
         daysCount: Int,
         regularity: Set<ChallengeRegularityType>,
         icon: UIImage?,
         isCustom: Bool) {
        self.identifier = identifier
        self.title = title
        self.subtitle = subtitle
        self.description = description
        self.daysCount = daysCount
        self.regularity = regularity
        self.icon = icon
        self.isCustom = isCustom
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(identifier, forKey: .identifier)
        try container.encode(title, forKey: .title)
        try container.encode(subtitle, forKey: .subtitle)
        try container.encode(description, forKey: .description)
        try container.encode(daysCount, forKey: .daysCount)
        try container.encode(regularity, forKey: .regularity)
        try container.encode(icon?.pngData(), forKey: .icon)
        try container.encode(isCustom, forKey: .isCustom)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        identifier = try container.decode(String.self, forKey: .identifier)
        title = try container.decode(String.self, forKey: .title)
        subtitle = try? container.decode(String.self, forKey: .subtitle)
        description = try? container.decode(String.self, forKey: .description)
        daysCount = try container.decode(Int.self, forKey: .daysCount)
        regularity = try container.decode(Set<ChallengeRegularityType>.self, forKey: .regularity)
        
        if let iconData = (try? container.decode(Data.self, forKey: .icon)) {
            icon = UIImage(data: iconData)
        }
        else {
            icon = nil
        }
        
        isCustom = try container.decode(Bool.self, forKey: .isCustom)
    }
}
