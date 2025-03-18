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
    
    private lazy var activityManager: AppActivityManager = {
        return AppActivityManager()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItems = model.isCustom ? [startButton] : [startButton, shareBuiltInButton]
    }
    
    @objc private func onStart() {
        if let navVC = navigationController {
            activityManager.lock(vc: navVC.parent ?? navVC)
        }
        
        DatabaseService.shared.startChallenge(with: model.identifier, 
                                              isCustom: model.isCustom) { [weak self] startedChallenge in
            DispatchQueue.main.async { [weak self] in
                self?.activityManager.unlock() {
                    guard let startedChallenge = startedChallenge else { return }
                    AppRouter.shared.toStartedChallengeAfterStart(model: startedChallenge)
                }
                
                if let challenge = startedChallenge?.originalChallenge {
                    AppDelegate.shared.appNotificationManager.scheduleNotification(for: challenge)
                    
#if DEBUG
                    AppDelegate.shared.appNotificationManager.scheduleDebugNotification(for: challenge)
#endif
                }
                
            }
        }
    }
}
