//
//  StartOpenedChallengeVC.swift
//  LidaChallenges
//
//  Created by Ihar Karunny on 8/25/24.
//

import UIKit

final class StartOpenedChallengeVC: OpenedChallengeVC {
    
    private lazy var startButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "OpenedChallengeStartButton".localised(),
                                     style: .plain,
                                     target: self,
                                     action: #selector(onStart))
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = startButton
    }
    
    @objc private func onStart() {
        
    }
}
