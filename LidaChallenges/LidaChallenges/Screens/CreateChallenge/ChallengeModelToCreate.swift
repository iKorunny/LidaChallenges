//
//  ChallengeModelToCreate.swift
//  LidaChallenges
//
//  Created by Ihar Karunny on 7/25/24.
//

import Foundation
import UIKit

final class ChallengeModelToCreate {
    var name: String
    var daysCount: Int
    var selectedRegularity: Set<CreateChallengeRegularityType>
    
    var icon: UIImage?
    var description: String?
    
    init(name: String,
         daysCount: Int,
         selectedRegularity: Set<CreateChallengeRegularityType>) {
        self.name = name
        self.daysCount = daysCount
        self.selectedRegularity = selectedRegularity
    }
}
