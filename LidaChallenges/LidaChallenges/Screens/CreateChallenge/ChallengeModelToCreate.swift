//
//  ChallengeModelToCreate.swift
//  LidaChallenges
//
//  Created by Ihar Karunny on 7/25/24.
//

import Foundation

final class ChallengeModelToCreate {
    var name: String
    var daysCount: Int
    var selectedRegularity: Set<CreateChallengeRegularityType>
    
    init(name: String,
         daysCount: Int,
         selectedRegularity: Set<CreateChallengeRegularityType>) {
        self.name = name
        self.daysCount = daysCount
        self.selectedRegularity = selectedRegularity
    }
}
