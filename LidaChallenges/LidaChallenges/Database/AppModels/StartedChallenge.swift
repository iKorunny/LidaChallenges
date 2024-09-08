//
//  StartedChallenge.swift
//  LidaChallenges
//
//  Created by Ihar Karunny on 9/1/24.
//

import Foundation

final class StartedChallenge {
    let identifier: String
    let startDate: Date
    let isCustomChallenge: Bool
    let originalChallenge: Challenge
    let dayRecords: Set<ChallengeDayRecordResult>
    
    init(identifier: String, 
         startDate: Date,
         isCustomChallenge: Bool,
         originalChallenge: Challenge,
         dayRecords: Set<ChallengeDayRecordResult>) {
        self.identifier = identifier
        self.startDate = startDate
        self.isCustomChallenge = isCustomChallenge
        self.originalChallenge = originalChallenge
        self.dayRecords = dayRecords
    }
}

extension StartedChallenge {
    var isFinished: Bool { false }
}
