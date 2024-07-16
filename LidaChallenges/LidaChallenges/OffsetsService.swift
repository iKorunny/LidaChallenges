//
//  OffsetsService.swift
//  LidaChallenges
//
//  Created by Ihar Karunny on 7/16/24.
//

import Foundation

final class OffsetsService {
    static let shared = OffsetsService()
    
    var myChallengesButtonHeight: CGFloat {
        85
    }
    
    var bottomOffset: CGFloat {
        myChallengesButtonHeight
    }
}
