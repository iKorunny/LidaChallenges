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
        case categoryID
    }
    
    let identifier: String
    let title: String
    let subtitle: String?
    let description: String?
    let daysCount: Int
    let regularity: Set<ChallengeRegularityType>
    let icon: UIImage?
    
    let isCustom: Bool
    
    let categoryID: Int
    
    static func create(from custom: DBCustomChallengeModel) -> Challenge? {
        guard let model = CustomChallenge.create(from: custom) else { return nil }
        
        return Challenge(identifier: model.identifier,
                         title: model.name,
                         subtitle: nil,
                         description: model.description,
                         daysCount: model.daysCount,
                         regularity: model.regularity,
                         icon: model.icon,
                         isCustom: true,
                         categoryID: 0)
    }
    
    static func create(from builtIn: DBBuiltInChallenge) -> Challenge? {
        guard let model = BuiltInChallenge.create(from: builtIn) else { return nil }
        
        return Challenge(identifier: model.identifier,
                         title: model.name,
                         subtitle: model.subtitleKey?.localised(),
                         description: model.descriptionKey?.localised(),
                         daysCount: model.daysCount,
                         regularity: model.regularity,
                         icon: model.icon,
                         isCustom: false,
                         categoryID: model.categoryID)
    }
    
    init(identifier: String, 
         title: String,
         subtitle: String?,
         description: String?,
         daysCount: Int,
         regularity: Set<ChallengeRegularityType>,
         icon: UIImage?,
         isCustom: Bool,
         categoryID: Int) {
        self.identifier = identifier
        self.title = title
        self.subtitle = subtitle
        self.description = description
        self.daysCount = daysCount
        self.regularity = regularity
        self.icon = icon ?? UIImage(named: "challengeIconDefault")
        self.isCustom = isCustom
        self.categoryID = categoryID
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
        try container.encode(categoryID, forKey: .categoryID)
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
        categoryID = try container.decode(Int.self, forKey: .categoryID)
    }
}

extension Challenge: OpenedChallengeModel {
    var name: String {
        title
    }
    
    var fullDescription: String? {
        guard let subtitle else {
            return "\(String(format: "ChallengeInfoRegularityTitle".localised(), CreateChallengeRegularityUtils.regularityToInfoString(regularity)))\n\(description ?? "")"
        }
        
        return "\(String(format: "ChallengeInfoRegularityTitle".localised(), CreateChallengeRegularityUtils.regularityToInfoString(regularity)))\n\(subtitle)\n\(description ?? "")"
    }
}
