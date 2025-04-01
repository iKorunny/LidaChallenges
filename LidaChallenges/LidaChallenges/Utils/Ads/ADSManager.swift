//
//  ADSManager.swift
//  LidaChallenges
//
//  Created by Ihar Karunny on 8/5/24.
//

import Foundation
import UIKit

extension Notification.Name {
    static let bannerAdChanged = Notification.Name("ADsManagerBannerAdChanged")
}

enum AdsManagerConstants {
    static let becomeActiveToShowLaunchAd: Int = 3
    static let becomeActiveCountKey = "becomeActiveCountKey"
}

protocol ADSManager {
    var onAdAvailable: ((Bool) -> Void)? { get set }
    var adAvailable: Bool { get }
    
    func showOnLaunchAdIfNeeded(fromv vc: UIViewController?)
    func initialise()
    func didBecomeActive()
    
    func createBannerView(with width: CGFloat, useCache: Bool) -> UIView
    func setupBannerView(from rootVC: UIViewController)
}
