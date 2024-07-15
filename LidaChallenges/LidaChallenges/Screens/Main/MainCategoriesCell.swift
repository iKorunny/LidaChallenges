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
        imgView.layer.masksToBounds = true
        imgView.layer.cornerRadius = 10
        imgView.backgroundColor = ColorThemeProvider.shared.itemBackground
        return imgView
    }()
    
    private(set) lazy var textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = FontsProvider.regularAppFont(with: 20)
        label.textColor = ColorThemeProvider.shared.itemTextTitle
        label.textAlignment = .center
        return label
    }()
    
    private(set) var settedUp = false
    
    func setupIfNeeded() {
        guard !settedUp else { return }
        
        contentView.backgroundColor = .clear
        
        contentView.addSubview(iconView)
        iconView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        iconView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        iconView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        iconView.heightAnchor.constraint(equalToConstant: 157.6).isActive = true
        iconView.widthAnchor.constraint(equalToConstant: 224.66).isActive = true
        
        contentView.addSubview(textLabel)
        textLabel.widthAnchor.constraint(equalTo: iconView.widthAnchor).isActive = true
        textLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        textLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2).isActive = true
        textLabel.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 8).isActive = true
        
        settedUp = true
    }
    
    func set(text: String, image: UIImage) {
        setupIfNeeded()
        
        textLabel.text = text
        iconView.image = image
    }
}
