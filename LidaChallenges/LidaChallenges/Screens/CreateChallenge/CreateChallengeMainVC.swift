//
//  CreateChallengeMainVC.swift
//  LidaChallenges
//
//  Created by Ihar Karunny on 7/16/24.
//

import UIKit

final class CreateChallengeMainVC: UIViewController {
    
    private var keyboardService: KeyboardAppearService?
    
    private lazy var continueButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "CreateChallengeContinueButtonTitle".localised(),
                                     style: .plain,
                                     target: self,
                                     action: #selector(onContinue))
        button.isEnabled = false
        return button
    }()
    
    private lazy var buttonsContainer: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.layer.masksToBounds = true
        container.layer.cornerRadius = 10
        container.backgroundColor = .clear
        
        container.heightAnchor.constraint(equalToConstant: 122).isActive = true
        container.backgroundColor = .white // TODO: remove both lines and add button lines
        
        return container
    }()
    
    private lazy var scrollContent: UIView = {
        let content = UIView()
        content.translatesAutoresizingMaskIntoConstraints = false
        content.backgroundColor = .clear
        content.addSubview(buttonsContainer)
        buttonsContainer.topAnchor.constraint(equalTo: content.topAnchor, constant: 18).isActive = true
        buttonsContainer.bottomAnchor.constraint(equalTo: content.bottomAnchor).isActive = true
        buttonsContainer.leadingAnchor.constraint(equalTo: content.leadingAnchor, constant: 18).isActive = true
        buttonsContainer.trailingAnchor.constraint(equalTo: content.trailingAnchor, constant: -18).isActive = true
        return content
    }()
    
    private lazy var scrollContentContainer: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = .clear
        
        container.addSubview(scrollContent)
        scrollContent.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        scrollContent.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        scrollContent.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
        scrollContent.trailingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true
        
        return container
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.addSubview(scrollContentContainer)
        scrollContentContainer.topAnchor.constraint(equalTo: scroll.topAnchor).isActive = true
        scrollContentContainer.bottomAnchor.constraint(equalTo: scroll.bottomAnchor).isActive = true
        scrollContentContainer.leadingAnchor.constraint(equalTo: scroll.leadingAnchor).isActive = true
        scrollContentContainer.trailingAnchor.constraint(equalTo: scroll.trailingAnchor).isActive = true
        scrollContentContainer.widthAnchor.constraint(equalTo: scroll.widthAnchor).isActive = true
        let heighAnchor = scrollContentContainer.heightAnchor.constraint(equalTo: scroll.heightAnchor)
        heighAnchor.priority = .defaultLow
        heighAnchor.isActive = true
        
        return scroll
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .clear
        navigationItem.title = "CreateChallengeTitle".localised()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: FontsProvider.regularAppFont(with: 20),
                                                                   .foregroundColor: ColorThemeProvider.shared.itemTextTitle]
        
        navigationItem.rightBarButtonItem = continueButton
        
        view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        let scrollBottom = scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: OffsetsService.shared.bottomOffset)
        scrollBottom.isActive = true
        keyboardService = KeyboardAppearService(mainView: view, bottomConstraint: scrollBottom)
    }
    
    @objc private func onContinue() {
        
    }
}
