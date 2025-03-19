//
//  MainCategoriesCell.swift
//  LidaChallenges
//
//  Created by Ihar Karunny on 6/23/24.
//

import UIKit

final class MainCategoriesCell: UICollectionViewCell {
    
    private(set) lazy var iconView: UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .center
        return imgView
    }()
    
    private(set) lazy var gradientBackground: UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleToFill
        imgView.image = UIImage(named: "ChallengeCategoryBackground")
        return imgView
    }()
    
    private(set) lazy var textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = FontsProvider.regularAppFont(with: 24)
        label.textColor = ColorThemeProvider.shared.itemTextTitle
        label.textAlignment = .center
        return label
    }()
    
    private(set) var settedUp = false
    
    func setupIfNeeded() {
        guard !settedUp else { return }
        
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 10
        
        contentView.addSubview(gradientBackground)
        gradientBackground.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        gradientBackground.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        gradientBackground.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        gradientBackground.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        gradientBackground.widthAnchor.constraint(equalToConstant: 237).isActive = true
        gradientBackground.heightAnchor.constraint(equalToConstant: 169).isActive = true
        
        contentView.addSubview(iconView)
        iconView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        iconView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        iconView.heightAnchor.constraint(equalToConstant: 156).isActive = true
        iconView.widthAnchor.constraint(equalToConstant: 156).isActive = true
        
        contentView.addSubview(textLabel)
        textLabel.widthAnchor.constraint(equalTo: iconView.widthAnchor).isActive = true
        textLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        textLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -7).isActive = true
        
        settedUp = true
    }
    
    func set(text: String, image: UIImage) {
        setupIfNeeded()
        
        textLabel.text = text
        iconView.image = image
    }
}
