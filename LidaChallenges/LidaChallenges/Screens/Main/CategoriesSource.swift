//
//  CategoriesSource.swift
//  LidaChallenges
//
//  Created by Ihar Karunny on 6/19/24.
//

import Foundation
import UIKit

final class Category {
    let id: Int
    let title: String
    let icon: UIImage
    
    init(id: Int, title: String, icon: UIImage) {
        self.id = id
        self.title = title
        self.icon = icon
    }
}

protocol CategoriesSource {
    var categoriesCount: Int { get }
    var categories: [Category] { get }
    
    func categories(with ids: [Int]) -> [Category]
}

final class CategoriesSourceImpl: CategoriesSource {
    var categories: [Category] {
        return [
            Category(id: 1,
                     title: "CategoriesHabbits".localised(),
                     icon: UIImage(named: "habbits")!),
            Category(id: 2,
                     title: "CategoriesCare".localised(),
                     icon: UIImage(named: "care")!),
            Category(id: 3,
                     title: "CategoriesSport".localised(),
                     icon: UIImage(named: "sport")!),
            Category(id: 4,
                     title: "CategoriesHealth".localised(),
                     icon: UIImage(named: "health")!),
            Category(id: 5,
                     title: "CategoriesEducation".localised(),
                     icon: UIImage(named: "education")!)
        ]
    }
    
    var categoriesCount: Int {
        categories.count
    }
    
    func categories(with ids: [Int]) -> [Category] {
        guard !ids.isEmpty else { return [] }
        return categories.filter({ ids.contains($0.id) })
    }
}
