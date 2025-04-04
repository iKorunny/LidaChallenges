//
//  OpenedChallengeVC.swift
//  LidaChallenges
//
//  Created by Ihar Karunny on 8/25/24.
//

import UIKit

protocol OpenedChallengeModel {
    var identifier: String { get }
    var name: String { get }
    var fullDescription: String? { get }
    var icon: UIImage? { get }
    var isCustom: Bool { get }
    var categoryID: Int { get }
}

class OpenedChallengeVC: BaseBackgroundedViewController {
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    let model: OpenedChallengeModel
    
    private var contentBottomConstraint: NSLayoutConstraint?
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.backgroundColor = .clear
        scroll.alwaysBounceVertical = true
        return scroll
    }()
    
    private lazy var scrollContentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .clear
        return contentView
    }()
    
    private lazy var iconPresentationView: UIView = {
        let iconView = UIView()
        iconView.backgroundColor = .clear
        iconView.translatesAutoresizingMaskIntoConstraints = false
        
        let imageView = UIImageView(image: model.icon)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        
        iconView.addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: iconView.topAnchor, constant: 27).isActive = true
        imageView.bottomAnchor.constraint(equalTo: iconView.bottomAnchor, constant: -28).isActive = true
        imageView.centerXAnchor.constraint(equalTo: iconView.centerXAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 160).isActive = true
        
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.heightAnchor.constraint(equalToConstant: 1).isActive = true
        line.backgroundColor = ColorThemeProvider.shared.ligthSeparator
        
        iconView.addSubview(line)
        line.leadingAnchor.constraint(equalTo: iconView.leadingAnchor).isActive = true
        line.trailingAnchor.constraint(equalTo: iconView.trailingAnchor).isActive = true
        line.bottomAnchor.constraint(equalTo: iconView.bottomAnchor).isActive = true
        
        return iconView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = FontsProvider.regularAppFont(with: 20)
        label.textColor = ColorThemeProvider.shared.itemTextTitle
        label.text = model.name
        
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = FontsProvider.regularAppFont(with: 14)
        label.textColor = ColorThemeProvider.shared.itemTextTitle
        label.text = model.fullDescription
        
        return label
    }()
    
    private(set) lazy var shareBuiltInButton: UIBarButtonItem = {
        UIBarButtonItem(image: UIImage.init(named: "ChallegeBuiltInShare"),
                        style: .plain,
                        target: self,
                        action: #selector(shareBuiltInChallenge))
    }()
    
    init(model: OpenedChallengeModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(bannerADAvailabilityChanged), name: .bannerAdChanged, object: nil)

        navigationItem.title = "OpenedChallengeTitle".localised()
        
        navigationItem.rightBarButtonItems = model.isCustom ? [] : [shareBuiltInButton]
        
        view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        contentBottomConstraint = scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -OffsetsService.shared.bottomOffset)
        contentBottomConstraint?.isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        scrollView.addSubview(scrollContentView)
        scrollContentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        scrollContentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        scrollContentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        scrollContentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        scrollContentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        var firstView: UIView?
        if model.icon != nil {
            scrollContentView.addSubview(iconPresentationView)
            iconPresentationView.topAnchor.constraint(equalTo: scrollContentView.topAnchor).isActive = true
            iconPresentationView.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor).isActive = true
            iconPresentationView.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor).isActive = true
            
            firstView = iconPresentationView
        }
        
        scrollContentView.addSubview(titleLabel)
        
        titleLabel.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 36).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -36).isActive = true
        
        if let firstView = firstView {
            titleLabel.topAnchor.constraint(equalTo: firstView.bottomAnchor, constant: 34).isActive = true
        }
        else {
            titleLabel.topAnchor.constraint(equalTo: scrollContentView.topAnchor).isActive = true
        }
        
        scrollContentView.addSubview(descriptionLabel)
        descriptionLabel.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 36).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -36).isActive = true
        descriptionLabel.bottomAnchor.constraint(equalTo: scrollContentView.bottomAnchor, constant: -27).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 27).isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: FontsProvider.regularAppFont(with: 16),
                                                                   .foregroundColor: ColorThemeProvider.shared.itemTextTitle]
    }
    
    @objc private func shareBuiltInChallenge() {
        URLSchemeManager.shared.shareBuiltInChallenge(with: model.identifier, from: self)
    }
    
    @objc private func bannerADAvailabilityChanged() {
        contentBottomConstraint?.constant = -OffsetsService.shared.bottomOffset
        view.layoutIfNeeded()
    }
}
