//
//  MyChallengesSection.swift
//  LidaChallenges
//
//  Created by Ihar Karunny on 9/8/24.
//

import Foundation

enum MyChallengesVCMode {
    case all
    case completed
    
    func activeSupported() -> Bool {
        switch self {
        case .all:
            return true
        case .completed:
            return false
        }
    }
    
    func completedSupported() -> Bool {
        switch self {
        case .all:
            return true
        case .completed:
            return true
        }
    }
}

enum MyChallengesVCState {
    case noData
    case hasData
}

final class MyChallengesSection {
    let title: String
    var challenges: [StartedChallenge]
    
    init(title: String, 
         challenges: [StartedChallenge]) {
        self.title = title
        self.challenges = challenges
    }
}
