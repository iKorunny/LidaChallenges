//
//  AppOpenAdManager.swift
//  LidaChallenges
//
//  Created by Лидия on 15.03.25.
//

import UIKit

protocol AppOpenAdManagerDelegate {
    func didShowAd()
}

protocol AppOpenAdManager {
    var delegate: AppOpenAdManagerDelegate? { get set }
    
    func showAdIfAvailable(from vc: UIViewController?)
}
