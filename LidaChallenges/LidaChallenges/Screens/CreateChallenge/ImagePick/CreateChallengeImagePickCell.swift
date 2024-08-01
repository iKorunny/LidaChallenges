//
//  CreateChallengeImagePickCell.swift
//  LidaChallenges
//
//  Created by Ihar Karunny on 8/1/24.
//

import UIKit

final class CreateChallengeImagePickCell: UICollectionViewCell {
    private lazy var iconImageView: UIImageView = {
        let iconView = UIImageView()
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.contentMode = .scaleAspectFill
        return iconView
    }()
    
    private lazy var backgroundContainer: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = ColorThemeProvider.shared.mainBackground.withAlphaComponent(0.3)
        container.layer.masksToBounds = true
        container.layer.cornerRadius = 10
        
        container.addSubview(iconImageView)
        iconImageView.topAnchor.constraint(equalTo: container.topAnchor, constant: 21).isActive = true
        iconImageView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 21).isActive = true
        iconImageView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -21).isActive = true
        iconImageView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -21).isActive = true
        
        return container
    }()
    
    private(set) var settedUp = false
    
    func setupIfNeeded() {
        guard !settedUp else { return }
        
        contentView.backgroundColor = .clear
        
        contentView.addSubview(backgroundContainer)
        backgroundContainer.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        backgroundContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        backgroundContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        backgroundContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        settedUp = true
    }
    
    func set(iconName: String) {
        setupIfNeeded()
        
        iconImageView.image = UIImage(named: iconName)
    }
}
