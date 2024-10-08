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
    
    static func markChallengeDayWillBeEnable(at date: Date) -> UIViewController {
        let content = UIView()
        content.translatesAutoresizingMaskIntoConstraints = false
        content.backgroundColor = ColorThemeProvider.shared.popupBackground
        content.layer.masksToBounds = true
        content.layer.cornerRadius = 10
        
        content.widthAnchor.constraint(lessThanOrEqualToConstant: 250).isActive = true
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        
        let dateString = Formatters.formatePopupDate(date)
        let string = String(format: "ChallengeNextDayAvailableText".localised(), dateString)
        var attrString = NSMutableAttributedString(string: string, attributes: [
            .foregroundColor: ColorThemeProvider.shared.popupInfoText,
            .font: FontsProvider.mediumAppFont(with: 14)
        ])
        let dateRange = (string as NSString).range(of: dateString)
        if dateRange.length > 0 {
            attrString.addAttribute(.font, value: FontsProvider.boldAppFont(with: 14), range: dateRange)
        }
        
        label.attributedText = attrString
        
        content.addSubview(label)
        label.topAnchor.constraint(equalTo: content.topAnchor, constant: 14).isActive = true
        label.bottomAnchor.constraint(equalTo: content.bottomAnchor, constant: -14).isActive = true
        label.leadingAnchor.constraint(equalTo: content.leadingAnchor, constant: 7).isActive = true
        label.trailingAnchor.constraint(equalTo: content.trailingAnchor, constant: -7).isActive = true
        
        let vc = PopupVC(with: content, config: .init(overlayBackground: false,
                                                          overlayColor: .clear,
                                                          autodismiss: true))
        return vc
    }
}
