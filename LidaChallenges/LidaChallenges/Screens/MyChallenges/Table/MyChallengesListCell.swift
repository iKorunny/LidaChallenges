//
//  MyChallengesListCell.swift
//  LidaChallenges
//
//  Created by Лидия on 4.04.25.
//

import UIKit

final class MyChallengesListCell: UITableViewCell {
    private var didSetup = false
    
    private lazy var indicatorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        return imageView
    }()
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 1
        label.textColor = ColorThemeProvider.shared.itemTextTitle
        label.font = FontsProvider.regularAppFont(with: 14)
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()
    
    private lazy var visibleContentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 10
        
        view.addSubview(iconImageView)
        iconImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 14).isActive = true
        iconImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 5).isActive = true
        iconImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -5).isActive = true
        iconImageView.widthAnchor.constraint(equalTo: iconImageView.heightAnchor).isActive = true
        
        view.addSubview(indicatorImageView)
        indicatorImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -14).isActive = true
        indicatorImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 14).isActive = true
        indicatorImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -14).isActive = true
        
        view.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 12).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 13).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: indicatorImageView.leadingAnchor, constant: -8).isActive = true
        
        return view
    }()
    
    func setupIfNeeded() {
        guard !didSetup else { return }
        didSetup = true
        
        backgroundView = nil
        selectedBackgroundView = nil
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(visibleContentView)
        visibleContentView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        visibleContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
        visibleContentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true
        visibleContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant:0).isActive = true
        
        visibleContentView.backgroundColor = isSelected ? ColorThemeProvider.shared.itemBackgroundHighlighted : ColorThemeProvider.shared.itemBackground
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = nil
        setupIfNeeded()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        visibleContentView.backgroundColor = selected ? ColorThemeProvider.shared.itemBackgroundHighlighted : ColorThemeProvider.shared.itemBackground
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        visibleContentView.backgroundColor = highlighted ? ColorThemeProvider.shared.itemBackgroundHighlighted : ColorThemeProvider.shared.itemBackground
    }
    
    func fill(with challenge: StartedChallenge) {
        setupIfNeeded()
        
        titleLabel.text = challenge.originalChallenge.title
        iconImageView.image = challenge.originalChallenge.icon
        indicatorImageView.image = challenge.isFinished ? UIImage(named: "MyChallengesComplete") : UIImage(named: "MyChallengesActive")
    }
}
