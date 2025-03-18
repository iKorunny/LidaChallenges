//
//  Formatters.swift
//  LidaChallenges
//
//  Created by Ihar Karunny on 10/8/24.
//

import Foundation

final class Formatters {
    static func formatePopupDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yy"
        return formatter.string(from: date)
    }
    
    static func formateDefaultReminder(_ dateComponents: DateComponents) -> String {
        guard let date = Calendar.current.date(from: dateComponents) else { return "" }
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yy"
        return formatter.string(from: date)
    }
    
    static func formateDateTimeLong(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .long
        return formatter.string(from: date)
    }
    
    static func formateDateShort(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}
