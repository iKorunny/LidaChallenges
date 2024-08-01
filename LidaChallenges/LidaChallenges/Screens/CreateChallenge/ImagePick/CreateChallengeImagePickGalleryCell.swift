//
//  CreateChallengeImagePickGalleryCell.swift
//  LidaChallenges
//
//  Created by Ihar Karunny on 8/1/24.
//

import UIKit

final class CreateChallengeImagePickGalleryCell: UICollectionViewCell {
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = ColorThemeProvider.shared.pickerButtonText
        label.font = FontsProvider.regularAppFont(with: 16)
        return label
    }()
    
    private lazy var backgroundContainer: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = ColorThemeProvider.shared.mainBackground.withAlphaComponent(0.3)
        container.layer.masksToBounds = true
        container.layer.cornerRadius = 10
        
        container.addSubview(textLabel)
        textLabel.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        textLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
        textLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true
        textLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        
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
    
    func set(text: String) {
        setupIfNeeded()
        
        textLabel.text = text
    }
}
