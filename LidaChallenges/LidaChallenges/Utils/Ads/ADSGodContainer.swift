//
//  ADSGodContainer.swift
//  LidaChallenges
//
//  Created by Лидия on 15.03.25.
//

final class ADSGodContainer {
    static let shared = ADSGodContainer()
    
    lazy var adsManager: ADSManager = {
        // GoogleADSManager()
        YandexADSManager()
    }()
    
    lazy var appOpenAdManager: AppOpenAdManager = {
//        GoogleAppOpenAdManager()
        YandexAppOpenAdManager()
    }()
}
