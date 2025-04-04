//
//  AppRootVC.swift
//  LidaChallenges
//
//  Created by Ihar Karunny on 6/17/24.
//

import UIKit

final class AppRootVC: BaseBackgroundedViewController {
    private lazy var window: UIWindow? = {
        return (UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene)?.windows.last
    }()
    
    private lazy var safeAreaBackgroundView: UIView = {
        let newView = UIView()
        newView.backgroundColor = ColorThemeProvider.shared.mainBackground
        newView.translatesAutoresizingMaskIntoConstraints = false
        return newView
    }()
    
    private lazy var containerView: UIView = {
        let newView = UIView()
        newView.backgroundColor = .clear
        newView.translatesAutoresizingMaskIntoConstraints = false
        return newView
    }()
    
    private lazy var myChallengesButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(.init(named: "MyChallengesLargeButton"), for: .normal)
        button.addTarget(self, action: #selector(toMyChallenges), for: .touchUpInside)
        return button
    }()
    
    private lazy var bannerView: UIView = {
        return ADSGodContainer.shared.adsManager.createBannerView(with: view.frame.inset(by: view.safeAreaInsets).width, useCache: true)
    }()
    
    private lazy var myChallengesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = FontsProvider.lightAppFont(with: 14)
        label.textColor = ColorThemeProvider.shared.ligthItem
        label.text = "MyChallengesLargeButtonTitle".localised()
        return label
    }()
    
    private lazy var buttonContainer: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = ColorThemeProvider.shared.mainBackground
        let separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = ColorThemeProvider.shared.separator
        
        container.addSubview(separator)
        separator.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        separator.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
        separator.trailingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        container.addSubview(myChallengesButton)
        myChallengesButton.topAnchor.constraint(equalTo: separator.bottomAnchor).isActive = true
        myChallengesButton.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        
        container.addSubview(myChallengesLabel)
        myChallengesLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -5).isActive = true
        myChallengesLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        
        return container
    }()
    
    private var adsBannerHeightConstraint: NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(containerView)
        containerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        view.addSubview(safeAreaBackgroundView)
        safeAreaBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        safeAreaBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        safeAreaBackgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        safeAreaBackgroundView.heightAnchor.constraint(equalToConstant: window?.safeAreaInsets.bottom ?? 0).isActive = true
        
        OffsetsService.shared.bannerView = bannerView
        view.addSubview(bannerView)
        bannerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        bannerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        adsBannerHeightConstraint = bannerView.heightAnchor.constraint(equalToConstant: 0)
        
        ADSGodContainer.shared.adsManager.onAdAvailable = { [weak self] available in
            self?.adsBannerHeightConstraint?.isActive = !available
        }
        
        if !ADSGodContainer.shared.adsManager.adAvailable {
            adsBannerHeightConstraint?.isActive = true
        }
        
        view.addSubview(buttonContainer)
        buttonContainer.heightAnchor.constraint(equalToConstant: OffsetsService.shared.myChallengesButtonHeight).isActive = true
        buttonContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        buttonContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        buttonContainer.bottomAnchor.constraint(equalTo: bannerView.topAnchor).isActive = true
        
        containerView.bottomAnchor.constraint(equalTo: buttonContainer.topAnchor).isActive = true
        
        toMainVC()
        
        ADSGodContainer.shared.adsManager.setupBannerView(from: self)
    }
    
    private func toMainVC() {
        let nextVC = UINavigationController(rootViewController: MainVC())
        smartAddChild(vc: nextVC, to: containerView)
        AppRouter.shared.navigationController = nextVC
    }
    
    @objc private func toMyChallenges() {
        AppRouter.shared.toMyChallenges(with: .all, screenTitle: nil)
    }
}
