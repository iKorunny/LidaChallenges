//
//  ChallengesSearchResultHeaderView.swift
//  LidaChallenges
//
//  Created by Ihar Karunny on 8/25/24.
//

import UIKit

final class ChallengesSearchResultHeaderView: UITableViewHeaderFooterView {
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
        contentView.backgroundColor = .clear
        contentView.addSubview(titleLabel)
        
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 19).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -19).isActive = true
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20).isActive = true
    }
    
    override func updateConfiguration(using state: UIViewConfigurationState) {
        super.updateConfiguration(using: state)
        
        backgroundConfiguration?.backgroundColor = state.isPinned ? ColorThemeProvider.shared.itemBackground : .clear
        backgroundConfiguration?.cornerRadius = state.isPinned ? 10 : 0
    }
}
