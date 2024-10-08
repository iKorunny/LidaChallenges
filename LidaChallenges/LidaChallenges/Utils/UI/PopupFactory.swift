//
//  PopupFactory.swift
//  LidaChallenges
//
//  Created by Ihar Karunny on 10/8/24.
//

import Foundation
import UIKit

final class PopupFactory {
    static func markChallengeDayPopup(target: Any, completeAction: Selector, failedAction: Selector) -> UIViewController {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = ColorThemeProvider.shared.popupBackground
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 10
        contentView.widthAnchor.constraint(equalToConstant: 195).isActive = true
        contentView.heightAnchor.constraint(equalToConstant: 79).isActive = true
        
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(line)
        line.widthAnchor.constraint(equalToConstant: 1).isActive = true
        line.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        line.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        line.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        line.backgroundColor = ColorThemeProvider.shared.popupSeparator
        
        let completeButton = UIButton()
        completeButton.translatesAutoresizingMaskIntoConstraints = false
        completeButton.setImage(.init(named: "challenge_day_set_complete"), for: .normal)
        completeButton.imageView?.contentMode = .scaleAspectFit
        completeButton.addTarget(target, action: completeAction, for: .touchUpInside)
        
        contentView.addSubview(completeButton)
        completeButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        completeButton.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        completeButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        completeButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5).isActive = true
        
        let failedButton = UIButton()
        failedButton.translatesAutoresizingMaskIntoConstraints = false
        failedButton.setImage(.init(named: "challenge_day_set_failed"), for: .normal)
        failedButton.addTarget(target, action: failedAction, for: .touchUpInside)
        
        contentView.addSubview(failedButton)
        failedButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        failedButton.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        failedButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        failedButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5).isActive = true
        
        let vc = PopupVC(with: contentView, config: .init(overlayBackground: true,
                                                          overlayColor: ColorThemeProvider.shared.defaultOverlay,
                                                          autodismiss: false))
        return vc
    }
}
