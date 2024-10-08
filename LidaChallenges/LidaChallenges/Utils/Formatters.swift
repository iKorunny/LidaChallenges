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
}
