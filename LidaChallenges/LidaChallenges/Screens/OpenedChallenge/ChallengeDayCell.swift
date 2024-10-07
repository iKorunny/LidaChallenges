//
//  ChallengeDayCell.swift
//  LidaChallenges
//
//  Created by Ihar Karunny on 10/7/24.
//

import UIKit

enum ChallengeDayCellState: Int {
    case enabled
    case disabled
    case completed
    case failed
}

final class ChallengeDayCell: UICollectionViewCell {
    private(set) var settedUp = false
    
    private lazy var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        view.backgroundColor = color(for: .enabled)
        
        view.addSubview(indicationImageView)
        indicationImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        indicationImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        indicationImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        indicationImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true
        
        return view
    }()
    
    private lazy var indicationImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = hideIndication(for: .enabled)
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard settedUp else { return }
        container.layer.cornerRadius = bounds.width * 0.5
    }
    
    func setupIfNeeded() {
        guard !settedUp else { return }
        
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        settedUp = true
        
        contentView.addSubview(container)
        container.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        container.layer.cornerRadius = bounds.width * 0.5
    }
    
    func set(state: ChallengeDayCellState) {
        setupIfNeeded()
        
        container.backgroundColor = color(for: state)
        indicationImageView.isHidden = hideIndication(for: state)
        indicationImageView.image = indicationImage(for: state)
    }
    
    private func color(for state: ChallengeDayCellState) -> UIColor {
        switch state {
        case .disabled:
            return ColorThemeProvider.shared.itemBackgroundDisabled
        case .completed, .enabled, .failed:
            return ColorThemeProvider.shared.itemBackground
        }
    }
    
    private func hideIndication(for state: ChallengeDayCellState) -> Bool {
        switch state {
        case .disabled, .enabled:
            return true
        case .completed, .failed:
            return false
        }
    }
    
    private func indicationImage(for state: ChallengeDayCellState) -> UIImage? {
        switch state {
        case .enabled, .disabled:
            return nil
        case .completed:
            return UIImage(named: "challenge_day_complete")
        case .failed:
            return UIImage(named: "challenge_day_failed")
        }
    }
}
