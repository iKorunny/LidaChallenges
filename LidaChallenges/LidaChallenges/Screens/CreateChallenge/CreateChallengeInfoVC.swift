//
//  CreateChallengeInfoVC.swift
//  LidaChallenges
//
//  Created by Ihar Karunny on 7/25/24.
//

import UIKit

final class CreateChallengeInfoVC: UIViewController {
    
    deinit {
        scrollView.removeGestureRecognizer(hideInputsTapGesture)
    }
    
    var model: ChallengeModelToCreate?
    
    private let infoPlaceholder = "CreateChallengeInfoPlaceholder".localised()
    
    private var keyboardService: KeyboardAppearService?
    
    private lazy var hideInputsTapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(hideInputs))
        return gesture
    }()
    
    private lazy var startButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "CreateChallengeInfoContinue".localised(),
                                     style: .plain,
                                     target: self,
                                     action: #selector(onStart))
        button.isEnabled = false
        return button
    }()
    
    private lazy var scrollContent: UIView = {
        let content = UIView()
        content.translatesAutoresizingMaskIntoConstraints = false
        content.backgroundColor = .clear
        
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
        label.textAlignment = .center
        label.textColor = ColorThemeProvider.shared.itemTextTitle
        label.font = FontsProvider.regularAppFont(with: 20)
        return label
    }()
    
    private lazy var pickImageLabel: UILabel = {
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
        
        return label
    }()
    
    private lazy var pickImageButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = ColorThemeProvider.shared.mainBackground
        button.setImage(.init(named: "CreateChallengePickImage"), for: .normal)
        button.addTarget(self, action: #selector(onPickImage), for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFit
        
        return button
    }()
    
    private lazy var pickImageView: UIView = {
        let background = UIView()
        background.translatesAutoresizingMaskIntoConstraints = false
        background.backgroundColor = .clear
        background.heightAnchor.constraint(equalTo: background.widthAnchor, multiplier: 160 / 430).isActive = true
        
        background.addSubview(pickImageButton)
        pickImageButton.topAnchor.constraint(equalTo: background.topAnchor).isActive = true
        pickImageButton.leadingAnchor.constraint(equalTo: background.leadingAnchor).isActive = true
        pickImageButton.trailingAnchor.constraint(equalTo: background.trailingAnchor).isActive = true
        pickImageButton.bottomAnchor.constraint(equalTo: background.bottomAnchor).isActive = true
        
        background.addSubview(pickImageLabel)
        pickImageLabel.centerYAnchor.constraint(equalTo: background.centerYAnchor).isActive = true
        pickImageLabel.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 10).isActive = true
        pickImageLabel.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -10).isActive = true
        
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
        updateCreateButtonEnability()
        
        showPlaceholderIfNeeded(currentText: nil)
    }
    
    private func setupUI() {
        scrollContent.addSubview(pickImageView)
        pickImageView.topAnchor.constraint(equalTo: scrollContent.safeAreaLayoutGuide.topAnchor, constant: 25).isActive = true
        pickImageView.leadingAnchor.constraint(equalTo: scrollContent.leadingAnchor).isActive = true
        pickImageView.trailingAnchor.constraint(equalTo: scrollContent.trailingAnchor).isActive = true
        
        scrollContent.addSubview(nameLabel)
        nameLabel.leadingAnchor.constraint(equalTo: scrollContent.leadingAnchor, constant: 33).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: scrollContent.trailingAnchor, constant: -33).isActive = true
        nameLabel.topAnchor.constraint(equalTo: pickImageView.bottomAnchor, constant: 33).isActive = true
        nameLabel.text = model?.name
        
        let bottomLine = UIView()
        bottomLine.translatesAutoresizingMaskIntoConstraints = false
        scrollContent.addSubview(bottomLine)
        bottomLine.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        bottomLine.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        bottomLine.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 29).isActive = true
        bottomLine.backgroundColor = ColorThemeProvider.shared.separator
        bottomLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        scrollContent.addSubview(textView)
        textView.leadingAnchor.constraint(equalTo: scrollContent.leadingAnchor, constant: 29).isActive = true
        textView.trailingAnchor.constraint(equalTo: scrollContent.trailingAnchor, constant: -29).isActive = true
        textView.topAnchor.constraint(equalTo: bottomLine.bottomAnchor, constant: 19).isActive = true
        textView.bottomAnchor.constraint(equalTo: scrollContent.bottomAnchor).isActive = true
        
        view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        let scrollBottom = scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -OffsetsService.shared.bottomOffset)
        scrollBottom.isActive = true
        keyboardService = KeyboardAppearService(mainView: view, bottomConstraint: scrollBottom)
    }
    
    @objc private func onStart() {
        hideInputs()
    }
    
    @objc private func onPickImage() {
        hideInputs()
        AppRouter.shared.toCreateChallengeImage { [weak self] pickedImage in
            self?.pickImageButton.setImage(pickedImage, for: .normal)
            self?.pickImageLabel.text = "CreateChallengeImagePickerChange".localised()
        }
    }
    
    private func showPlaceholderIfNeeded(currentText: String?) {
        if currentText == nil || currentText?.isEmpty == true {
            textView.text = infoPlaceholder
        }
    }
    
    @objc private func hideInputs() {
        textView.resignFirstResponder()
    }
    
    private func updateCreateButtonEnability() {
        let insEnabled = true
        startButton.isEnabled = insEnabled
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

extension CreateChallengeInfoVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.isTracking else { return }
        hideInputs()
    }
}
