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
    let dayRecords: Array<ChallengeDayRecord>
    let note: String?
    
    init(identifier: String, 
         startDate: Date,
         isCustomChallenge: Bool,
         originalChallenge: Challenge,
         dayRecords: Array<ChallengeDayRecord>,
         note: String?) {
        self.identifier = identifier
        self.startDate = startDate
        self.isCustomChallenge = isCustomChallenge
        self.originalChallenge = originalChallenge
        self.dayRecords = dayRecords
        self.note = note
    }
}

extension StartedChallenge {
    var isFinished: Bool {
        guard let lastDay = StartedChallengeUtils.lastDate(for: self) else { return false }
                
        return !Date().isLessOrEqualIgnoringTime(to: lastDay)
    }
}

final class StartedChallengeUtils {
    static func closestNotAvailableDate(for challenge: StartedChallenge, currentDate: Date) -> Date? {
        let dates = dates(for: challenge)
        return dates.first(where: { !currentDate.isLessOrEqualIgnoringTime(to: $0) })
    }
    
    static func state(for challenge: StartedChallenge, index: Int, currentDate: Date) -> ChallengeDayCellState {
        if let savedState = challenge.dayRecords.first(where: { $0.dayIndex == index })?.result {
            switch savedState {
            case .fail:
                return .failed
            case .success:
                return .completed
            case .pending:
                return .enabled
            }
        }
        
        return isAvailableDay(for: challenge, with: index, currentDate: currentDate) ? .enabled : .disabled
    }
    
    static func dateOfDay(for challenge: StartedChallenge, with index: Int) -> Date {
        return dates(for: challenge)[index]
    }
    
    static func lastDate(for challenge: StartedChallenge) -> Date? {
        return dates(for: challenge).last
    }
    
    private static func isAvailableDay(for challenge: StartedChallenge, with index: Int, currentDate: Date) -> Bool {
        return !currentDate.isLessIgnoringTime(to: dateOfDay(for: challenge, with: index))
    }
    
    private static func dates(for challenge: StartedChallenge) -> [Date] {
        var dates: [Date] = []
        
        let startingDate = challenge.startDate
        
        var regularityToCheck = startingDate.dayRegularity()!
        var previousDate = startingDate.dayBefore
        var dateToCheck = Date.nexteDate(of: regularityToCheck.toAppleValue(), from: previousDate)!
        
        while dates.count < challenge.originalChallenge.daysCount {
            if challenge.originalChallenge.regularity.contains(regularityToCheck) {
                dates.append(dateToCheck)
            }
            
            regularityToCheck = regularityToCheck.next()
            let oldDate = dateToCheck
            dateToCheck = Date.nexteDate(of: regularityToCheck.toAppleValue(), from: previousDate)!
            previousDate = oldDate
        }
        
        return dates
    }
}
