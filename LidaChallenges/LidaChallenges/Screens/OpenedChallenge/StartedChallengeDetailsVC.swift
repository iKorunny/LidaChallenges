//
//  StartedChallengeDetailsVC.swift
//  LidaChallenges
//
//  Created by Ihar Karunny on 9/3/24.
//

import UIKit

final class StartedChallengeDetailsVC: UIViewController {
    
    let model: StartedChallenge
    
    private lazy var infoButton: UIBarButtonItem = {
        UIBarButtonItem(image: UIImage(named: "ChallengeInfoIcon"),
                        style: .plain,
                        target: self,
                        action: #selector(onInfo))
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = FontsProvider.regularAppFont(with: 14)
        label.textColor = ColorThemeProvider.shared.subtitle
        label.textAlignment = .left
        return label
    }()
    
    init(model: StartedChallenge) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    private var hasSubtitle: Bool {
        model.originalChallenge.subtitle != nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = model.originalChallenge.title
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: FontsProvider.regularAppFont(with: 32),
                                                                   .foregroundColor: ColorThemeProvider.shared.itemTextTitle]
        navigationItem.rightBarButtonItem = infoButton
        
        if hasSubtitle {
            view.addSubview(subtitleLabel)
            subtitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 23).isActive = true
            subtitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18).isActive = true
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 130).isActive = true
            subtitleLabel.text = model.originalChallenge.subtitle
        }
        
        

        view.backgroundColor = .red
    }
    
    @objc private func onInfo() {
        AppRouter.shared.toOpenChallengeInfo(model: model.originalChallenge)
    }
}
