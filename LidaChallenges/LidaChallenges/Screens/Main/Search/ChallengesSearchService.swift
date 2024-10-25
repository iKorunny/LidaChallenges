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
        
        var builtInChallenges: [BuiltInChallenge] = []
        group.enter()
        DatabaseService.shared.fetchAllBuiltInChallenges(with: text) { challenges in
            builtInChallenges = challenges ?? []
            group.leave()
        }
        
        group.notify(queue: .main) { [weak self] in
            guard self?.lastSearchText == text else { return }
            self?.lastSearchText = nil
            
            var sections: [ChallengesSearchResultSection] = []
            
            var categoryIds: Set<Int> = []
            
            builtInChallenges.forEach {
                categoryIds.insert($0.categoryID)
            }
            let categories = CategoriesSourceImpl().categories(with: Array(categoryIds))
            
            categories.forEach { category in
                sections.append(ChallengesSearchResultSection(title: category.title,
                                                              rows: builtInChallenges.filter({ $0.categoryID == category.id }).compactMap({ ChallengesSearchResultRow(model: $0) })))
            }
            
            
            
            if !customChallenges.isEmpty {
                sections.append(.init(title: "CustomChallengeSectionTitle".localised(),
                                      rows: customChallenges.compactMap({ ChallengesSearchResultRow(model: $0) })))
            }
            
            completion(sections)
        }
    }
}
