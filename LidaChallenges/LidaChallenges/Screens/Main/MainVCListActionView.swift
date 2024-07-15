//
//  MainVCListActionView.swift
//  LidaChallenges
//
//  Created by Ihar Karunny on 6/24/24.
//

import UIKit

final class MainVCListActionView: UIView {
    private var settedUp = false
    
    private(set) lazy var iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = FontsProvider.regularAppFont(with: 14)
        label.textColor = ColorThemeProvider.shared.itemTextTitle
        return label
    }()
    
    private lazy var actionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(performAction), for: .touchUpInside)
        button.addTarget(self, action: #selector(makeTouched), for: .touchDown)
        button.addTarget(self, action: #selector(makeTouched), for: .touchDragInside)
        button.addTarget(self, action: #selector(makeUntouched), for: .touchDragOutside)
        button.addTarget(self, action: #selector(makeUntouched), for: .touchCancel)
        button.addTarget(self, action: #selector(makeUntouched), for: .touchUpOutside)
        
        return button
    }()
    
    private var model: MainVCListActionItem?

    func setupIfNeeded() {
        guard !settedUp else { return }
        settedUp = true
        
        addSubview(iconView)
        iconView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive = true
        iconView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        addSubview(titleLabel)
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 59).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        addSubview(actionButton)
        actionButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
        actionButton.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        actionButton.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        actionButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }

    func fill(with model: MainVCListActionItem) {
        setupIfNeeded()
        
        iconView.image = model.image
        titleLabel.text = model.title
        self.model = model
    }
    
    @objc private func makeTouched() {
        backgroundColor = ColorThemeProvider.shared.itemBackgroundHighlighted
    }
    
    @objc private func makeUntouched() {
        backgroundColor = ColorThemeProvider.shared.itemBackground
    }
    
    @objc private func performAction() {
        makeUntouched()
        
        model?.action(model!)
    }
}
