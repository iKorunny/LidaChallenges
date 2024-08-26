//
//  ChallengesSearchResultSection.swift
//  LidaChallenges
//
//  Created by Ihar Karunny on 8/26/24.
//

import Foundation

final class ChallengesSearchResultSection {
    let title: String
    let rows: [ChallengesSearchResultRow]
    
    init(title: String, rows: [ChallengesSearchResultRow]) {
        self.title = title
        self.rows = rows
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
