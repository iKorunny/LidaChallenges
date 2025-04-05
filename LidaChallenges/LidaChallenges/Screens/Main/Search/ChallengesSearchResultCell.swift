//
//  ChallengesSearchResultCell.swift
//  LidaChallenges
//
//  Created by Ihar Karunny on 8/25/24.
//

import UIKit

final class ChallengesSearchResultCell: UITableViewCell {
    private var didSetup = false
    
    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 1
        label.textColor = ColorThemeProvider.shared.itemTextTitle
        label.font = FontsProvider.regularAppFont(with: 14)
        return label
    }()
    
    private lazy var visibleContentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 10
        
        view.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 12).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18).isActive = true
        
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
        visibleContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16).isActive = true
        
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
}
