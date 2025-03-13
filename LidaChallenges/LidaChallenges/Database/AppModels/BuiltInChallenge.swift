//
//  BuiltInChallenge.swift
//  LidaChallenges
//
//  Created by Ihar Karunny on 10/24/24.
//

import Foundation
import UIKit

final class BuiltInChallenge {
    let identifier: String
    let categoryID: Int
    
    let nameKey: String
    let subtitleKey: String?
    let descriptionKey: String?
    
    let iconName: String?
    
    let daysCount: Int
    let regularity: Set<ChallengeRegularityType>
    
    init(identifier: String,
         categoryID: Int,
         nameKey: String,
         subtitleKey: String?,
         descriptionKey: String?,
         iconName: String?,
         daysCount: Int,
         regularity: Set<ChallengeRegularityType>) {
        self.identifier = identifier
        self.categoryID = categoryID
        self.nameKey = nameKey
        self.subtitleKey = subtitleKey
        self.descriptionKey = descriptionKey
        self.iconName = iconName
        self.daysCount = daysCount
        self.regularity = regularity
    }
}

extension BuiltInChallenge {
    static func create(from dbModel: DBBuiltInChallenge) -> BuiltInChallenge? {
        guard let id = dbModel.identifier,
              let nameKey = dbModel.nameKey,
              let regularityArra = dbModel.regularity as? Array<Int> else { return nil }
        
        return BuiltInChallenge(identifier: id,
                                categoryID: Int(dbModel.categoryID),
                                nameKey: nameKey,
                                subtitleKey: dbModel.subtitleKey,
                                descriptionKey: dbModel.descriptionKey,
                                iconName: dbModel.iconName,
                                daysCount: Int(dbModel.daysCount),
                                regularity: Set(regularityArra.compactMap({ ChallengeRegularityType(rawValue: $0) })))
    }
}

extension BuiltInChallenge: OpenedChallengeModel {
    var name: String {
        nameKey.localised()
    }
    
    var icon: UIImage? {
        if let iconName, !iconName.isEmpty {
            return UIImage(named: iconName)
        }
        
        if let category = CategoriesSourceImpl().categories(with: [categoryID]).first {
            return category.icon
        }
        
        return UIImage(named: "challengeIconDefault")
    }
    
    var isCustom: Bool {
        false
    }
    
    var fullDescription: String? {
        var subtitleLine = subtitleKey?.localised() ?? ""
        if !subtitleLine.isEmpty {
            subtitleLine += "\n"
        }
        return "\(subtitleLine)\(String(format: "ChallengeInfoRegularityTitle".localised(), CreateChallengeRegularityUtils.regularityToInfoString(regularity)))\n\(descriptionKey?.localised() ?? "")"
    }
}
