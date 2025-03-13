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
    
    static func nextDate(of weekday: Int, from previousDate: Date) -> Date? {
        let cal = Calendar(identifier: .gregorian)
        var comps = DateComponents()
        comps.weekday = weekday
        let now = previousDate
        if let nextDay = cal.nextDate(after: now, matching: comps, matchingPolicy: .nextTimePreservingSmallerComponents) {
            return nextDay
        }
        
        return nil
    }
    
    static func dates(for weekdays: [Int], from previousDate: Date) -> [Date] {
        let cal = Calendar(identifier: .gregorian)
        
        var result: [Date] = []
        var comps = DateComponents()
        
        weekdays.forEach { weekday in
            comps.weekday = weekday
            let now = previousDate
            guard let day = cal.nextDate(after: now, matching: comps, matchingPolicy: .nextTimePreservingSmallerComponents) else { return }
            guard !result.contains(day) else { return }
            result.append(day)
        }
        
        return result
    }
    
    func isLessIgnoringTime(to date: Date) -> Bool {
        let startOfMe = gregorianCalendar.startOfDay(for: self)
        let startOfDate = gregorianCalendar.startOfDay(for: date)
        
        let order = Calendar.current.compare(startOfMe, to: startOfDate, toGranularity: .day)
        
        switch order {
        case .orderedDescending, .orderedSame:
            return false
        case .orderedAscending:
            return true
        }
    }
    
    func isGreaterOrEqualIgnoringTime(to date: Date) -> Bool {
        let startOfMe = gregorianCalendar.startOfDay(for: self)
        let startOfDate = gregorianCalendar.startOfDay(for: date)
        
        let order = Calendar.current.compare(startOfMe, to: startOfDate, toGranularity: .day)
        
        switch order {
        case .orderedAscending:
            return false
        case .orderedDescending, .orderedSame:
            return true
        }
    }
    
    func isLessOrEqualIgnoringTime(to date: Date) -> Bool {
        let startOfMe = gregorianCalendar.startOfDay(for: self)
        let startOfDate = gregorianCalendar.startOfDay(for: date)
        
        let order = Calendar.current.compare(startOfMe, to: startOfDate, toGranularity: .day)
        
        switch order {
        case .orderedDescending:
            return false
        case .orderedAscending, .orderedSame:
            return true
        }
    }
    
    func adding(seconds: Int) -> Date {
        return gregorianCalendar.date(byAdding: .second, value: seconds, to: self)!
    }
    
    var dayBefore: Date {
        return gregorianCalendar.date(byAdding: .day, value: -1, to: self)!
    }
    
    var dayAfterWeek: Date {
        return gregorianCalendar.date(byAdding: .day, value: 7, to: self)!
    }
    
    var start: Date {
        return gregorianCalendar.startOfDay(for: self)
    }
    
    func convertToComponents(calendar: Calendar = Calendar(identifier: .gregorian), hours: Int? = nil) -> DateComponents {
        var components = calendar.dateComponents([.year, .month, .day], from: self)
        components.hour = hours
        return components
    }
    
    func convertToComponentsWithTime(calendar: Calendar = Calendar(identifier: .gregorian), hours: Int? = nil) -> DateComponents {
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
        components.hour = hours ?? components.hour
        return components
    }
}
