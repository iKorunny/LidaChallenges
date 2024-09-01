//
//  CategoriesSource.swift
//  LidaChallenges
//
//  Created by Ihar Karunny on 6/19/24.
//

import Foundation
import UIKit

final class Category {
    let title: String
    let icon: UIImage
    let challenges: [Challenge]
    
    init(title: String, icon: UIImage, challenges: [Challenge]) {
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
            Category(title: "CategoriesHabbits".localised(),
                     icon: UIImage(named: "habbits")!,
                     challenges: []),
            Category(title: "CategoriesCare".localised(),
                     icon: UIImage(named: "care")!,
                     challenges: []),
            Category(title: "CategoriesSport".localised(),
                     icon: UIImage(named: "sport")!,
                     challenges: []),
            Category(title: "CategoriesHealth".localised(),
                     icon: UIImage(named: "health")!,
                     challenges: []),
            Category(title: "CategoriesEducation".localised(),
                     icon: UIImage(named: "education")!,
                     challenges: [])
        ]
    }
    
    var categoriesCount: Int {
        categories.count
    }
}
