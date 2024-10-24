//
//  AfterLaunchViewController.swift
//  LidaChallenges
//
//  Created by Ihar Karunny on 6/16/24.
//

import UIKit

final class AfterLaunchViewController: UIViewController {
    private enum Constants {
        static let toAppDelay: TimeInterval = 0.5
    }
    
    private lazy var imageView: UIImageView = {
        let iconView = UIImageView(image: .init(named: "MainIcon"))
        iconView.translatesAutoresizingMaskIntoConstraints = false
        return iconView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = ColorThemeProvider.shared.mainBackground
        view.addSubview(imageView)
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        if BuiltInChallengesManager().shouldSync {
            BuiltInChallengesManager().syncIfNeeded { [weak self] in
                self?.toAppAfterDelay()
            }
        }
        else {
            toAppAfterDelay()
        }
    }
    
    private func toAppAfterDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.toAppDelay) { [weak self] in
            self?.toApp()
        }
    }
    
    private func toApp() {
        let nextVC = AppRootVC()
        smartAddChild(vc: nextVC, to: view)
    }
}

