//
//  CreateChallengeInfoVC.swift
//  LidaChallenges
//
//  Created by Ihar Karunny on 7/25/24.
//

import UIKit

final class CreateChallengeInfoVC: UIViewController {
    
    var model: ChallengeModelToCreate?
    
    private let infoPlaceholder = "CreateChallengeInfoPlaceholder".localised()
    
    private lazy var startButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "CreateChallengeInfoContinue".localised(),
                                     style: .plain,
                                     target: self,
                                     action: #selector(onStart))
        button.isEnabled = false
        return button
    }()
    
    private lazy var textView: UITextView = {
        let inputView = UITextView()
        inputView.translatesAutoresizingMaskIntoConstraints = false
        inputView.textColor = ColorThemeProvider.shared.itemTextTitle
        inputView.font = FontsProvider.regularAppFont(with: 14)
        inputView.delegate = self
        inputView.backgroundColor = .clear
        return inputView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textColor = ColorThemeProvider.shared.itemTextTitle
        label.font = FontsProvider.regularAppFont(with: 20)
        return label
    }()
    
    private lazy var pickImageView: UIView = {
        let background = UIView()
        background.translatesAutoresizingMaskIntoConstraints = false
        background.backgroundColor = .clear
        background.heightAnchor.constraint(equalTo: background.widthAnchor, multiplier: 160 / 430).isActive = true
        
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = ColorThemeProvider.shared.mainBackground
        button.setImage(.init(named: "CreateChallengePickImage"), for: .normal)
        background.addSubview(button)
        button.topAnchor.constraint(equalTo: background.topAnchor).isActive = true
        button.leadingAnchor.constraint(equalTo: background.leadingAnchor).isActive = true
        button.trailingAnchor.constraint(equalTo: background.trailingAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: background.bottomAnchor).isActive = true
        button.addTarget(self, action: #selector(onPickImage), for: .touchUpInside)
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorThemeProvider.shared.buttonText
        label.numberOfLines = 1
        label.font = FontsProvider.regularAppFont(with: 36)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.4
        label.textAlignment = .center
        label.isUserInteractionEnabled = false
        label.text = "CreateChallengeInfoPickImage".localised()
        
        background.addSubview(label)
        label.centerYAnchor.constraint(equalTo: background.centerYAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 10).isActive = true
        label.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -10).isActive = true
        
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.isUserInteractionEnabled = false
        line.backgroundColor = ColorThemeProvider.shared.separator
        line.heightAnchor.constraint(equalToConstant: 1).isActive = true
        background.addSubview(line)
        line.leadingAnchor.constraint(equalTo: background.leadingAnchor).isActive = true
        line.trailingAnchor.constraint(equalTo: background.trailingAnchor).isActive = true
        line.bottomAnchor.constraint(equalTo: background.bottomAnchor).isActive = true
        
        return background
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = ColorThemeProvider.shared.mainBackground
        navigationItem.title = "CreateChallengeInfoTitle".localised()
        navigationItem.rightBarButtonItem = startButton
        
        setupUI()
        
        showPlaceholderIfNeeded(currentText: nil)
    }
    
    private func setupUI() {
        view.addSubview(pickImageView)
        pickImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25).isActive = true
        pickImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        pickImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        view.addSubview(nameLabel)
        nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 33).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -33).isActive = true
        nameLabel.topAnchor.constraint(equalTo: pickImageView.bottomAnchor, constant: 42).isActive = true
        nameLabel.text = model?.name
        
        view.addSubview(textView)
        textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 29).isActive = true
        textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -29).isActive = true
        textView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 25).isActive = true
        textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -OffsetsService.shared.bottomOffset).isActive = true
    }
    
    @objc private func onStart() {
        hideInputs()
    }
    
    @objc private func onPickImage() {
        hideInputs()
    }
    
    private func showPlaceholderIfNeeded(currentText: String?) {
        if currentText == nil || currentText?.isEmpty == true {
            textView.text = infoPlaceholder
        }
    }
    
    private func hideInputs() {
        textView.resignFirstResponder()
    }
}

extension CreateChallengeInfoVC: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.text == infoPlaceholder {
            textView.text = nil
        }
        
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        showPlaceholderIfNeeded(currentText: textView.text)
    }
}
