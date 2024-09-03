//
//  StartedChallengeDetailsVC.swift
//  LidaChallenges
//
//  Created by Ihar Karunny on 9/3/24.
//

import UIKit

final class StartedChallengeDetailsVC: UIViewController {
    
    let model: StartedChallenge
    
    init(model: StartedChallenge) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .red
    }
}
