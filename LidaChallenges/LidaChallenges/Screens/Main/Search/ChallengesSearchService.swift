//
//  ChallengesSearchService.swift
//  LidaChallenges
//
//  Created by Ihar Karunny on 8/26/24.
//

import Foundation

final class ChallengesSearchService {
    private var lastSearchText: String?
    
    func search(with text: String, completion: @escaping (([ChallengesSearchResultSection]) -> Void)) {
        lastSearchText = text
        
        guard !text.isEmpty else { return }
        let group = DispatchGroup()
        
        var customChallenges: [CustomChallenge] = []
        group.enter()
        DatabaseService.shared.fetchCustomChallenges(with: text) { challenges in
            customChallenges = challenges ?? []
            group.leave()
        }
        
        group.notify(queue: .main) { [weak self] in
            guard self?.lastSearchText == text else { return }
            self?.lastSearchText = nil
            
            var sections: [ChallengesSearchResultSection] = []
            
            if !customChallenges.isEmpty {
                sections.append(.init(title: "CustomChallengeSectionTitle".localised(),
                                      rows: customChallenges.compactMap({ ChallengesSearchResultRow(model: $0) })))
            }
            
            completion(sections)
        }
    }
}
