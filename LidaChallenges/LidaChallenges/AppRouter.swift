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
    var navigationController: UINavigationController? {
        didSet {
            if navigationController != nil {
                delayedStack.forEach { vc in
                    navigationController?.pushViewController(vc, animated: false)
                }
                
                delayedStack = []
            }
        }
    }
    
    private var delayedStack: [UIViewController] = []
    
    var currentNavigationStackType: AppScreenType {
        guard let vc = navigationController?.visibleViewController else { return .other }
        
        switch vc {
        case is MyChallengesVC:
            return .myChallenges
        default:
            return .other
        }
    }
    
    func toMyChallenges(with mode: MyChallengesVCMode, screenTitle: String?) {
        guard currentNavigationStackType != .myChallenges else { return }
        
        let stackCount = navigationController?.viewControllers.count ?? 0
        if stackCount > 1 {
            if navigationController!.viewControllers[stackCount - 2] is MyChallengesVC {
                navigationController?.popViewController(animated: false)
                return
            }
        }
        
        
        let nextVC = MyChallengesVC()
        nextVC.mode = mode
        nextVC.screenTitle = screenTitle
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
    
    func toCreateChallengeImage(onPickImage: @escaping (UIImage) -> Void) {
        let nextVC = CreateChallengeImageVC()
        nextVC.onPickImage = onPickImage
        navigationController?.pushViewController(nextVC, animated: false)
    }
    
    func toOpenChallengeAfterCreation(model: OpenedChallengeModel) {
        navigationController?.popToRootViewController(animated: false)
        DispatchQueue.main.asyncAfter(deadline: .now()) { [weak self] in
            let nextVC = StartOpenedChallengeVC(model: model)
            self?.navigationController?.pushViewController(nextVC, animated: false)
        }
    }
    
    func toOpenChallenge(model: OpenedChallengeModel, delayIfNeeded: Bool = false) {
        let nextVC = StartOpenedChallengeVC(model: model)
        navigationController?.pushViewController(nextVC, animated: false)
        
        if delayIfNeeded && navigationController == nil {
            delayedStack.append(nextVC)
        }
    }
    
    func toStartedChallengeAfterStart(model: StartedChallenge) {
        navigationController?.popToRootViewController(animated: false)
        DispatchQueue.main.asyncAfter(deadline: .now()) { [weak self] in
            let nextVC = StartedChallengeDetailsVC(model: model, onChangesToReload: nil)
            self?.navigationController?.pushViewController(nextVC, animated: false)
        }
    }
    
    func toStartedChallenge(model: StartedChallenge, onSomeChanges: (() -> Void)? = nil) {
        let nextVC = StartedChallengeDetailsVC(model: model, onChangesToReload: onSomeChanges)
        navigationController?.pushViewController(nextVC, animated: false)
    }
    
    func toOpenChallengeInfo(model: OpenedChallengeModel) {
        let nextVC = OpenedChallengeVC(model: model)
        navigationController?.pushViewController(nextVC, animated: false)
    }
    
    func toChallengesList(categoryID: Int) {
        let nextVC = ChallengesListVC()
        nextVC.categoryID = categoryID
        navigationController?.pushViewController(nextVC, animated: false)
    }
}
