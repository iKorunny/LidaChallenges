//
//  Date+Utils.swift
//  LidaChallenges
//
//  Created by Ihar Karunny on 10/12/24.
//

import Foundation

extension Date {
    private var gregorianCalendar: Calendar {
        return Calendar(identifier: .gregorian)
    }
    
    func dayNumberOfWeek() -> Int? {
        return gregorianCalendar.dateComponents([.weekday], from: self).weekday
    }
    
    func dayRegularity() -> ChallengeRegularityType? {
        guard let dayInt = dayNumberOfWeek() else { return nil }
        
        return ChallengeRegularityType.fromApple(value: dayInt)
    }
    
    static func nexteDate(of weekday: Int, from previousDate: Date) -> Date? {
        let cal = Calendar(identifier: .gregorian)
        var comps = DateComponents()
        comps.weekday = weekday
        let now = previousDate
        if let nextDay = cal.nextDate(after: now, matching: comps, matchingPolicy: .nextTimePreservingSmallerComponents) {
            return nextDay
        }
        
        return nil
    }
    
    func isLessOrEqualIgnoringTime(to date: Date) -> Bool {
        let startOfMe = gregorianCalendar.startOfDay(for: self)
        let startOfDate = gregorianCalendar.startOfDay(for: date)
        
        let order = Calendar.current.compare(startOfMe, to: startOfDate, toGranularity: .day)
        
        switch order {
        case .orderedDescending, .orderedSame:
            return true
        case .orderedAscending:
            return false
        }
    }
    
    var dayBefore: Date {
        return gregorianCalendar.date(byAdding: .day, value: -1, to: self)!
    }
}
