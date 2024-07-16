//
//  MyChallengesVC.swift
//  LidaChallenges
//
//  Created by Ihar Karunny on 7/15/24.
//

import UIKit

enum MyChallengesVCState {
    case noData
    case hasData
}

final class MyChallengesVC: UIViewController {
    
    private var state: MyChallengesVCState = .noData {
        didSet {
            stateChanged(newState: state)
        }
    }
    
    private lazy var noDataLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = FontsProvider.regularAppFont(with: 24)
        label.textColor = ColorThemeProvider.shared.warningItem
        label.text = "MyChallengesNoData".localised()
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .clear
        navigationItem.title = "MyChallengesLargeButtonTitle".localised()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: FontsProvider.regularAppFont(with: 20),
                                                                   .foregroundColor: ColorThemeProvider.shared.itemTextTitle]
        view.addSubview(noDataLabel)
        noDataLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        noDataLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        stateChanged(newState: state)
    }
    
    private func stateChanged(newState: MyChallengesVCState) {
        switch newState {
        case .hasData:
            noDataLabel.isHidden = true
        case .noData:
            noDataLabel.isHidden = false
        }
    }
}
