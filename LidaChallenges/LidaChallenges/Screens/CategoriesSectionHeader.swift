//
//  CategoriesSectionHeader.swift
//  LidaChallenges
//
//  Created by Ihar Karunny on 6/19/24.
//

import UIKit

final class CategoriesSectionHeader: UICollectionReusableView {
    private(set) var titleLabel: UILabel?
    
    func setup() {
        if titleLabel == nil {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            addSubview(label)
            label.topAnchor.constraint(equalTo: topAnchor, constant: 15).isActive = true
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 19).isActive = true
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15).isActive = true
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -19).isActive = true
            titleLabel = label
        }
    }
}
