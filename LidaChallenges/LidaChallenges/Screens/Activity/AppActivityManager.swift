//
//  AppActivityManager.swift
//  LidaChallenges
//
//  Created by Ihar Karunny on 8/21/24.
//

import Foundation
import UIKit

final class AppActivityManager {
    private lazy var activityVC: AppActivityVC = {
        let vc = AppActivityVC()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        return vc
    }()
    private var count: Int = 0
    
    func lock(vc: UIViewController) {
        count += 1
        guard count == 1 else { return }
        vc.present(activityVC, animated: true) { [weak self] in
            self?.activityVC.startAnimation()
        }
    }
    
    func unlock(onUnlock: (() -> Void)?) {
        count -= 1
        guard count == 0 else { return }
        activityVC.dismiss(animated: true) { [weak self] in
            self?.activityVC.stopAnimation()
            onUnlock?()
        }
    }
}
