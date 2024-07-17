//
//  CreateChallengeMainVC.swift
//  LidaChallenges
//
//  Created by Ihar Karunny on 7/16/24.
//

import UIKit

final class CreateChallengeMainVC: UIViewController {
    
    deinit {
        scrollView.removeGestureRecognizer(hideInputsTapGesture)
    }
    
    private var keyboardService: KeyboardAppearService?
    
    private lazy var continueButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "CreateChallengeContinueButtonTitle".localised(),
                                     style: .plain,
                                     target: self,
                                     action: #selector(onContinue))
        button.isEnabled = false
        return button
    }()
    
    private lazy var daysCountField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.delegate = self
        field.borderStyle = .none
        field.backgroundColor = .clear
        field.textColor = ColorThemeProvider.shared.placeholder
        field.font = FontsProvider.regularAppFont(with: 14)
        field.keyboardType = .decimalPad
        return field
    }()
    
    private lazy var daysCountContainer: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = ColorThemeProvider.shared.itemBackground
        container.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textColor = ColorThemeProvider.shared.placeholder
        label.font = FontsProvider.regularAppFont(with: 14)
        label.text = "CreateChallengeDaysCountPlaceholder".localised()
        
        container.addSubview(label)
        label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 11).isActive = true
        label.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        label.widthAnchor.constraint(lessThanOrEqualTo: container.widthAnchor, multiplier: 0.6).isActive = true
        
        let actionBackground = UIView()
        actionBackground.translatesAutoresizingMaskIntoConstraints = false
        actionBackground.backgroundColor = ColorThemeProvider.shared.listActionBackground
        actionBackground.layer.masksToBounds = true
        actionBackground.layer.cornerRadius = 5
        
        container.addSubview(actionBackground)
        actionBackground.widthAnchor.constraint(equalToConstant: 51).isActive = true
        actionBackground.heightAnchor.constraint(equalToConstant: 28).isActive = true
        actionBackground.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        actionBackground.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -18).isActive = true
        
        let icon = UIImageView(image: .init(named: "CreateChallengeActionArrow"))
        icon.translatesAutoresizingMaskIntoConstraints = false
        actionBackground.addSubview(icon)
        icon.centerYAnchor.constraint(equalTo: actionBackground.centerYAnchor).isActive = true
        icon.trailingAnchor.constraint(equalTo: actionBackground.trailingAnchor, constant: -4).isActive = true
        
        actionBackground.addSubview(daysCountField)
        daysCountField.topAnchor.constraint(equalTo: actionBackground.topAnchor).isActive = true
        daysCountField.bottomAnchor.constraint(equalTo: actionBackground.bottomAnchor).isActive = true
        daysCountField.centerXAnchor.constraint(equalTo: actionBackground.centerXAnchor).isActive = true
        daysCountField.widthAnchor.constraint(lessThanOrEqualTo: actionBackground.widthAnchor, multiplier: 1.0).isActive = true
        
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(editDaysCount), for: .touchUpInside)
        
        actionBackground.addSubview(button)
        button.topAnchor.constraint(equalTo: actionBackground.topAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: actionBackground.bottomAnchor).isActive = true
        button.leadingAnchor.constraint(equalTo: actionBackground.leadingAnchor).isActive = true
        button.trailingAnchor.constraint(equalTo: actionBackground.trailingAnchor).isActive = true
        
        return container
    }()
    
    private lazy var nameTextFieldContainer: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = ColorThemeProvider.shared.itemBackground
        container.addSubview(nameTextField)
        nameTextField.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        nameTextField.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        nameTextField.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 11).isActive = true
        nameTextField.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -11).isActive = true
        return container
    }()
    
    private lazy var nameTextField: UITextField = {
        let field = UITextField()
        field.borderStyle = .none
        field.backgroundColor = .clear
        field.translatesAutoresizingMaskIntoConstraints = false
        field.attributedPlaceholder = NSAttributedString(string: "CreateChallengeNameFieldPlaceholder".localised(), attributes: [
            .foregroundColor: ColorThemeProvider.shared.placeholder,
            .font: FontsProvider.regularAppFont(with: 14)
        ])
        field.textColor = ColorThemeProvider.shared.placeholder
        field.font = FontsProvider.regularAppFont(with: 14)
        field.heightAnchor.constraint(equalToConstant: 40).isActive = true
        return field
    }()
    
    private lazy var buttonsContainer: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.layer.masksToBounds = true
        container.layer.cornerRadius = 10
        container.backgroundColor = .clear
        
        container.heightAnchor.constraint(equalToConstant: 122).isActive = true
        container.backgroundColor = .green // TODO: remove both lines and add button lines
        
        container.addSubview(nameTextFieldContainer)
        nameTextFieldContainer.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        nameTextFieldContainer.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
        nameTextFieldContainer.trailingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true
        
        container.addSubview(daysCountContainer)
        daysCountContainer.topAnchor.constraint(equalTo: nameTextFieldContainer.bottomAnchor, constant: 1).isActive = true
        daysCountContainer.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
        daysCountContainer.trailingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true
        
        
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
    
    private lazy var hideInputsTapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(hideInputViews))
        return gesture
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.addSubview(scrollContentContainer)
        scroll.delegate = self
        scroll.addGestureRecognizer(hideInputsTapGesture)
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
    
    @objc private func hideInputViews() {
        nameTextField.resignFirstResponder()
        daysCountField.resignFirstResponder()
    }
    
    @objc private func editDaysCount() {
        hideInputViews()
        daysCountField.becomeFirstResponder()
    }
}

extension CreateChallengeMainVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        hideInputViews()
    }
}

extension CreateChallengeMainVC: UITextFieldDelegate {
    
}
