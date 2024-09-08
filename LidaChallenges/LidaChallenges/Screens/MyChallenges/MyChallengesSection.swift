//
//  MyChallengesSection.swift
//  LidaChallenges
//
//  Created by Ihar Karunny on 9/8/24.
//

import Foundation

final class MyChallengesSection {
    let title: String
    let challenges: [StartedChallenge]
    
    init(title: String, 
         challenges: [StartedChallenge]) {
        self.title = title
        self.challenges = challenges
    }
}
