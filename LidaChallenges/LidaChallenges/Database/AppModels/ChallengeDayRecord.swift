//
//  ChallengeDayRecord.swift
//  LidaChallenges
//
//  Created by Ihar Karunny on 9/1/24.
//

import Foundation
enum ChallengeDayRecordResult: Int, Codable {
    case pending
    case success
    case fail
}

final class ChallengeDayRecord: Codable {
    let dayIndex: Int
    let result: ChallengeDayRecordResult
    
    init(dayIndex: Int, 
         result: ChallengeDayRecordResult) {
        self.dayIndex = dayIndex
        self.result = result
    }
}
