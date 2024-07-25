//
//  AppRouter.swift
//  LidaChallenges
//
//  Created by Ihar Karunny on 7/15/24.
//

import Foundation
import UIKit

enum AppScreenType {
    case myChallenges
    case other
}

final class AppRouter {
    static var shared = AppRouter()
    var navigationController: UINavigationController?
    
    var currentNavigationStackType: AppScreenType {
        guard let vc = navigationController?.visibleViewController else { return .other }
        
        switch vc {
        case is MyChallengesVC:
            return .myChallenges
        default:
            return .other
        }
    }
    
    func toMyChallenges() {
        guard currentNavigationStackType != .myChallenges else { return }
        let nextVC = MyChallengesVC()
        navigationController?.pushViewController(nextVC, animated: false)
    }
    
    func toStartCreateChallenge() {
        let nextVC = CreateChallengeMainVC()
        navigationController?.pushViewController(nextVC, animated: false)
    }
    
    func toCreateChallengeInfo(with model: ChallengeModelToCreate) {
        let nextVC = CreateChallengeInfoVC()
        nextVC.model = model
        navigationController?.pushViewController(nextVC, animated: false)
    }
}
