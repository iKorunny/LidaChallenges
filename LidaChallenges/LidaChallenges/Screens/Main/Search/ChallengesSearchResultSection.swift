//
//  ChallengesSearchResultSection.swift
//  LidaChallenges
//
//  Created by Ihar Karunny on 8/26/24.
//

import Foundation

final class ChallengesSearchResultSection {
    let title: String
    var rows: [ChallengesSearchResultRow]
    
    init(title: String, rows: [ChallengesSearchResultRow]) {
        self.title = title
        self.rows = rows
    }
}

extension ChallengesSearchResultSection {
    var isCustom: Bool {
        return rows.contains(where: { $0.model.isCustom })
    }
}

final class ChallengesSearchResultRow {
    let model: OpenedChallengeModel
    
    var title: String {
        model.name
    }
    
    init(model: OpenedChallengeModel) {
        self.model = model
    }
}
