//
//  CustomChallenge.swift
//  LidaChallenges
//
//  Created by Ihar Karunny on 8/24/24.
//

import Foundation
import UIKit

final class CustomChallenge {
    let identifier: String
    
    let name: String
    let daysCount: Int
    let regularity: Set<ChallengeRegularityType>
    
    let icon: UIImage?
    let description: String?
    
    init(identifier: String,
         name: String,
         daysCount: Int,
         regularity: Set<ChallengeRegularityType>,
         icon: UIImage? = nil,
         description: String? = nil) {
        self.identifier = identifier
        self.name = name
        self.daysCount = daysCount
        self.regularity = regularity
        self.icon = icon
        self.description = description
    }
}

extension CustomChallenge {
    static func create(from dbModel: DBCustomChallengeModel) -> CustomChallenge? {
        guard let id = dbModel.identifier,
              let name = dbModel.name,
              let regularityArra = dbModel.regularity as? Array<Int> else { return nil }
        
        var icon: UIImage?
        if let iconData = dbModel.icon {
            icon = UIImage(data: iconData)
        }
        
        return CustomChallenge(identifier: id,
                               name: name,
                               daysCount: Int(dbModel.daysCount),
                               regularity: Set(regularityArra.compactMap({ ChallengeRegularityType(rawValue: $0) })),
                               icon: icon,
                               description: dbModel.descriptionString)
    }
}

extension CustomChallenge: OpenedChallengeModel {
    var categoryID: Int {
        return -1
    }
    
    var isCustom: Bool {
        true
    }
    
    var fullDescription: String? {
        return "\(String(format: "ChallengeInfoRegularityTitle".localised(), CreateChallengeRegularityUtils.regularityToInfoString(regularity)))\n\(description ?? "")"
    }
}
