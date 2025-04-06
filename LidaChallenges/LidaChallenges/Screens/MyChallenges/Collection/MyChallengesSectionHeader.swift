//
//  MyChallengesSectionHeader.swift
//  LidaChallenges
//
//  Created by Ihar Karunny on 9/8/24.
//

import UIKit

final class MyChallengesSectionHeader: UICollectionReusableView {
    private var setupComplete = false
    
    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = ColorThemeProvider.shared.itemTextTitle
        label.font = FontsProvider.regularAppFont(with: 20)
        return label
    }()
    
    func setupIfNeeded() {
        guard !setupComplete else { return }
        setupComplete = true
        
        backgroundColor = .clear
        addSubview(titleLabel)
        
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 36).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -36).isActive = true
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 22).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
    }
}
