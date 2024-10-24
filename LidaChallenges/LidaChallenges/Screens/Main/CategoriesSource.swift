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
    let challenges: [Challenge]
    
    init(id: Int, title: String, icon: UIImage, challenges: [Challenge]) {
        self.id = id
        self.title = title
        self.icon = icon
        self.challenges = challenges
    }
}

protocol CategoriesSource {
    var categoriesCount: Int { get }
    var categories: [Category] { get }
}

final class CategoriesSourceMock: CategoriesSource {
    var categories: [Category] {
        return [
            Category(id: 1,
                     title: "CategoriesHabbits".localised(),
                     icon: UIImage(named: "habbits")!,
                     challenges: []),
            Category(id: 2,
                     title: "CategoriesCare".localised(),
                     icon: UIImage(named: "care")!,
                     challenges: []),
            Category(id: 3,
                     title: "CategoriesSport".localised(),
                     icon: UIImage(named: "sport")!,
                     challenges: []),
            Category(id: 4,
                     title: "CategoriesHealth".localised(),
                     icon: UIImage(named: "health")!,
                     challenges: []),
            Category(id: 5,
                     title: "CategoriesEducation".localised(),
                     icon: UIImage(named: "education")!,
                     challenges: [])
        ]
    }
    
    var categoriesCount: Int {
        categories.count
    }
}
