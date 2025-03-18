//
//  MyChallengesCell.swift
//  LidaChallenges
//
//  Created by Ihar Karunny on 9/8/24.
//

import UIKit

final class MyChallengesCell: UICollectionViewCell {
    private var setupComplete = false
    
    private lazy var indicatorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        return imageView
    }()
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = FontsProvider.regularAppFont(with: 14)
        label.textColor = ColorThemeProvider.shared.itemSecondaryTextTitle
        label.textAlignment = .center
        return label
    }()
    
    private lazy var intervalLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = FontsProvider.regularAppFont(with: 10)
        label.textColor = ColorThemeProvider.shared.subtitle
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.6
        label.textAlignment = .left
        return label
    }()
    
    override var isHighlighted: Bool {
        didSet {
            contentView.backgroundColor = isHighlighted ? ColorThemeProvider.shared.itemBackgroundHighlighted : ColorThemeProvider.shared.itemBackground
        }
    }
    
    func setupIfNeeded() {
        guard !setupComplete else { return }
        setupComplete = true
        
        contentView.backgroundColor = ColorThemeProvider.shared.itemBackground
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 10
        
        contentView.addSubview(indicatorImageView)
        indicatorImageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        indicatorImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        contentView.addSubview(iconImageView)
        iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30).isActive = true
        iconImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30).isActive = true
        iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30).isActive = true
        iconImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30).isActive = true
        
        contentView.addSubview(intervalLabel)
        intervalLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 1).isActive = true
        intervalLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 3).isActive = true
        intervalLabel.trailingAnchor.constraint(lessThanOrEqualTo: indicatorImageView.leadingAnchor, constant: -3).isActive = true
        
        contentView.addSubview(titleLabel)
        titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
    }
    
    func fill(with challenge: StartedChallenge) {
        setupIfNeeded()
        
        titleLabel.text = challenge.originalChallenge.title
        iconImageView.image = challenge.originalChallenge.icon
        indicatorImageView.image = challenge.isFinished ? UIImage(named: "MyChallengesComplete") : UIImage(named: "MyChallengesActive")
        
        if let endDate = challenge.endDate {
            intervalLabel.text = "\(Formatters.formateDateShort(challenge.startDate)) - \(Formatters.formateDateShort(endDate))"
        }
        else {
            intervalLabel.text = Formatters.formateDateShort(challenge.startDate)
        }
    }
}
