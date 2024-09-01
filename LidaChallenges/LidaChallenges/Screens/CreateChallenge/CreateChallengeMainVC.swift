//
//  CreateChallengeMainVC.swift
//  LidaChallenges
//
//  Created by Ihar Karunny on 7/16/24.
//

import UIKit

enum ChallengeRegularityType: Int, Codable {
    case monday = 1
    case tuesday = 2
    case wednesday = 3
    case thursday = 4
    case friday = 5
    case saturday = 6
    case sunday = 7
    
    static func allValues() -> [ChallengeRegularityType] {
        return [.monday, .tuesday, .wednesday, .thursday, .friday,. saturday, .sunday]
    }
    
    func stringValue() -> String {
        switch self {
        case .monday: return "CreateChallengeRegularityMonday".localised()
        case .tuesday: return "CreateChallengeRegularityTuesday".localised()
        case .wednesday: return "CreateChallengeRegularityWednesday".localised()
        case .thursday: return "CreateChallengeRegularityThursday".localised()
        case .friday: return "CreateChallengeRegularityFriday".localised()
        case .saturday: return "CreateChallengeRegularitySaturday".localised()
        case .sunday: return "CreateChallengeRegularitySunday".localised()
        }
    }
    
    func infoStringValue() -> String {
        switch self {
        case .monday: return "ChallengeInfoRegularityMonday".localised()
        case .tuesday: return "ChallengeInfoRegularityTuesday".localised()
        case .wednesday: return "ChallengeInfoRegularityWednesday".localised()
        case .thursday: return "ChallengeInfoRegularityThursday".localised()
        case .friday: return "ChallengeInfoRegularityFriday".localised()
        case .saturday: return "ChallengeInfoRegularitySaturday".localised()
        case .sunday: return "ChallengeInfoRegularitySunday".localised()
        }
    }
}

final class CreateChallengeMainVC: UIViewController {
    
    deinit {
        scrollView.removeGestureRecognizer(hideInputsTapGesture)
    }
    
    private var keyboardService: KeyboardAppearService?
    
    private var selectedRegularity: Set<ChallengeRegularityType> = Set<ChallengeRegularityType>(ChallengeRegularityType.allValues())
    private var daysCount: Int? {
        guard let daysString = daysCountField.text else { return nil }
        return Int(daysString)
    }
    private var name: String? {
        nameTextField.text
    }
    
    private var isDaysValid: Bool {
        guard let days = daysCount else { return false }
        return days > 0 && days <= 365
    }
    private var isNameValid: Bool {
        guard let name else { return false }
        return !name.isEmpty
    }
    
    private var daysPickerTopConstraint: NSLayoutConstraint?
    
    private var daysPickerButtons: [UIButton] = []
    
    private lazy var daysPickerButtonsStack: UIStackView = {
        var arrangedSubviews: [UIView] = []
        
        for i in 0..<ChallengeRegularityType.allValues().count {
            let buttonContainer = UIView()
            buttonContainer.backgroundColor = .clear
            buttonContainer.isUserInteractionEnabled = true
            let button = UIButton()
            button.titleLabel?.font = FontsProvider.regularAppFont(with: 14)
            button.tag = i
            button.setTitle(ChallengeRegularityType.allValues()[i].stringValue(), for: .normal)
            button.setTitleColor(ColorThemeProvider.shared.itemBackground, for: .normal)
            button.addTarget(self, action: #selector(onDayPick(_:)), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
            if i < (ChallengeRegularityType.allValues().count - 1) {
                let line = UIView()
                line.translatesAutoresizingMaskIntoConstraints = false
                line.backgroundColor = ColorThemeProvider.shared.pickerBorder
                line.widthAnchor.constraint(equalToConstant: 0.75).isActive = true
                line.heightAnchor.constraint(equalToConstant: 17).isActive = true
                buttonContainer.addSubview(line)
                line.centerYAnchor.constraint(equalTo: buttonContainer.centerYAnchor).isActive = true
                line.trailingAnchor.constraint(equalTo: buttonContainer.trailingAnchor).isActive = true
            }
            buttonContainer.addSubview(button)
            button.topAnchor.constraint(equalTo: buttonContainer.topAnchor).isActive = true
            button.bottomAnchor.constraint(equalTo: buttonContainer.bottomAnchor).isActive = true
            button.leadingAnchor.constraint(equalTo: buttonContainer.leadingAnchor).isActive = true
            button.trailingAnchor.constraint(equalTo: buttonContainer.trailingAnchor).isActive = true
            
            daysPickerButtons.append(button)
            arrangedSubviews.append(buttonContainer)
        }
        
        let stack = UIStackView(arrangedSubviews: arrangedSubviews)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.backgroundColor = .clear
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        stack.isUserInteractionEnabled = true
        return stack
    }()
    
    private lazy var daysPickerContainer: UIView = {
        let container = UIView()
        container.isUserInteractionEnabled = true
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = ColorThemeProvider.shared.pickerBackground.withAlphaComponent(0.5)
        container.layer.masksToBounds = true
        container.layer.cornerRadius = 10
        container.alpha = 0
        
        container.addSubview(daysPickerButtonsStack)
        daysPickerButtonsStack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 9).isActive = true
        daysPickerButtonsStack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -9).isActive = true
        daysPickerButtonsStack.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        daysPickerButtonsStack.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        
        return container
    }()
    
    private lazy var continueButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "CreateChallengeContinueButtonTitle".localised(),
                                     style: .plain,
                                     target: self,
                                     action: #selector(onContinue))
        button.isEnabled = false
        return button
    }()
    
    private lazy var regularityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = FontsProvider.regularAppFont(with: 14)
        label.textColor = ColorThemeProvider.shared.placeholder
        return label
    }()
    
    private lazy var daysSelectionFieldContainer: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = ColorThemeProvider.shared.itemBackground
        container.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textColor = ColorThemeProvider.shared.placeholder
        label.font = FontsProvider.regularAppFont(with: 14)
        label.text = "CreateChallengeRegularityPlaceholder".localised()
        
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
        actionBackground.widthAnchor.constraint(greaterThanOrEqualToConstant: 58).isActive = true
        actionBackground.heightAnchor.constraint(equalToConstant: 28).isActive = true
        actionBackground.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        actionBackground.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -18).isActive = true
        
        let icon = UIImageView(image: .init(named: "CreateChallengeActionArrow"))
        icon.translatesAutoresizingMaskIntoConstraints = false
        actionBackground.addSubview(icon)
        icon.centerYAnchor.constraint(equalTo: actionBackground.centerYAnchor).isActive = true
        icon.trailingAnchor.constraint(equalTo: actionBackground.trailingAnchor, constant: -9).isActive = true
        
        actionBackground.addSubview(regularityLabel)
        regularityLabel.centerYAnchor.constraint(equalTo: actionBackground.centerYAnchor).isActive = true
        regularityLabel.leadingAnchor.constraint(equalTo: actionBackground.leadingAnchor, constant: 9).isActive = true
        regularityLabel.trailingAnchor.constraint(equalTo: icon.leadingAnchor, constant: -5).isActive = true
        
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(selectRegularity), for: .touchUpInside)
        
        actionBackground.addSubview(button)
        button.topAnchor.constraint(equalTo: actionBackground.topAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: actionBackground.bottomAnchor).isActive = true
        button.leadingAnchor.constraint(equalTo: actionBackground.leadingAnchor).isActive = true
        button.trailingAnchor.constraint(equalTo: actionBackground.trailingAnchor).isActive = true
        
        return container
    }()
    
    private lazy var daysCountHint: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textColor = ColorThemeProvider.shared.hint
        label.font = FontsProvider.regularAppFont(with: 10)
        label.text = "CreateChallengeDaysCountHint".localised()
        label.isHidden = true
        return label
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
        actionBackground.widthAnchor.constraint(equalToConstant: 58).isActive = true
        actionBackground.heightAnchor.constraint(equalToConstant: 28).isActive = true
        actionBackground.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        actionBackground.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -18).isActive = true
        
        let icon = UIImageView(image: .init(named: "CreateChallengeActionArrow"))
        icon.translatesAutoresizingMaskIntoConstraints = false
        actionBackground.addSubview(icon)
        icon.centerYAnchor.constraint(equalTo: actionBackground.centerYAnchor).isActive = true
        icon.trailingAnchor.constraint(equalTo: actionBackground.trailingAnchor, constant: -9).isActive = true
        
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
        
        container.addSubview(daysCountHint)
        daysCountHint.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -3).isActive = true
        daysCountHint.trailingAnchor.constraint(equalTo: actionBackground.leadingAnchor, constant: -8).isActive = true
        
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

        container.backgroundColor = .clear
        
        container.addSubview(nameTextFieldContainer)
        nameTextFieldContainer.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        nameTextFieldContainer.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
        nameTextFieldContainer.trailingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true
        
        container.addSubview(daysCountContainer)
        daysCountContainer.topAnchor.constraint(equalTo: nameTextFieldContainer.bottomAnchor, constant: 1).isActive = true
        daysCountContainer.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
        daysCountContainer.trailingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true
        
        container.addSubview(daysSelectionFieldContainer)
        daysSelectionFieldContainer.topAnchor.constraint(equalTo: daysCountContainer.bottomAnchor, constant: 1).isActive = true
        daysSelectionFieldContainer.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
        daysSelectionFieldContainer.trailingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true
        daysSelectionFieldContainer.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        
        updateRegularityText(with: selectedRegularity)
        
        return container
    }()
    
    private lazy var scrollContent: UIView = {
        let content = UIView()
        content.translatesAutoresizingMaskIntoConstraints = false
        content.backgroundColor = .clear
        
        content.addSubview(daysPickerContainer)
        daysPickerContainer.heightAnchor.constraint(equalToConstant: 36).isActive = true
        daysPickerContainer.leadingAnchor.constraint(equalTo: content.leadingAnchor, constant: 18).isActive = true
        daysPickerContainer.trailingAnchor.constraint(equalTo: content.trailingAnchor, constant: -18).isActive = true
        
        content.addSubview(buttonsContainer)
        buttonsContainer.topAnchor.constraint(equalTo: content.topAnchor, constant: 18).isActive = true
        buttonsContainer.bottomAnchor.constraint(equalTo: content.bottomAnchor, constant: -51).isActive = true
        buttonsContainer.leadingAnchor.constraint(equalTo: content.leadingAnchor, constant: 18).isActive = true
        buttonsContainer.trailingAnchor.constraint(equalTo: content.trailingAnchor, constant: -18).isActive = true
        
        daysPickerTopConstraint = daysPickerContainer.topAnchor.constraint(equalTo: buttonsContainer.topAnchor, constant: 82)
        daysPickerTopConstraint?.isActive = true
        
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
        let scrollBottom = scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -OffsetsService.shared.bottomOffset)
        scrollBottom.isActive = true
        keyboardService = KeyboardAppearService(mainView: view, bottomConstraint: scrollBottom)
    }
    
    @objc private func onContinue() {
        hideInputViews()
        AppRouter.shared.toCreateChallengeInfo(with: ChallengeModelToCreate(name: name ?? "",
                                                                            daysCount: daysCount ?? 0,
                                                                            selectedRegularity: selectedRegularity))
    }
    
    @objc private func hideInputViews() {
        nameTextField.resignFirstResponder()
        daysCountField.resignFirstResponder()
        updateDaysPicker(enabled: false)
        updateContinueButtonEnability()
    }
    
    @objc private func selectRegularity() {
        updateDaysPicker(enabled: true)
    }
    
    private func updateDaysPicker(enabled: Bool) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.daysPickerContainer.alpha = enabled ? 1.0 : 0.0
            self?.daysPickerTopConstraint?.constant = enabled ? 137 : 82
            self?.scrollContent.layoutIfNeeded()
        }
    }
    
    @objc private func onDayPick(_ sender: UIButton) {
        guard let day = ChallengeRegularityType(rawValue: sender.tag + 1) else { return }
        let button = daysPickerButtons[sender.tag]
        if selectedRegularity.contains(day) {
            selectedRegularity.remove(day)
            button.setTitleColor(ColorThemeProvider.shared.itemTextTitle, for: .normal)
        }
        else {
            selectedRegularity.insert(day)
            button.setTitleColor(ColorThemeProvider.shared.itemBackground, for: .normal)
        }
        
        updateRegularityText(with: selectedRegularity)
    }
    
    @objc private func editDaysCount() {
        hideInputViews()
        daysCountField.becomeFirstResponder()
    }
    
    private func handleDaysCountBadInput() {
        daysCountHint.isHidden = false
    }
    
    private func updateRegularityText(with types: Set<ChallengeRegularityType>) {
        regularityLabel.text = CreateChallengeRegularityUtils.regularityToString(types)
    }
    
    private func updateContinueButtonEnability() {
        let insEnabled = !selectedRegularity.isEmpty && isDaysValid && isNameValid
        continueButton.isEnabled = insEnabled
    }
}

extension CreateChallengeMainVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.isTracking else { return }
        hideInputViews()
    }
}

extension CreateChallengeMainVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField === daysCountField {
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            let isDigitsOnly = allowedCharacters.isSuperset(of: characterSet)
            let currentText = textField.text ?? ""
            guard isDigitsOnly, let swiftRange = Range(range, in: currentText) else {
                handleDaysCountBadInput()
                return false
            }
            
            let newString = currentText.replacingCharacters(in: swiftRange, with: string)
            
            if newString.isEmpty {
                handleDaysCountBadInput()
                return true
            }
            
            let intValue = Int(newString) ?? -1
            let result = intValue > 0 && intValue < 366
            if !result {
                handleDaysCountBadInput()
            }
            return result
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        updateContinueButtonEnability()
    }
}
