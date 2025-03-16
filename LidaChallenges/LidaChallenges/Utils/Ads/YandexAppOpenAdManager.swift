//
//  YandexAppOpenAdManager.swift
//  LidaChallenges
//
//  Created by Ihar Karunny on 8/8/24.
//

import Foundation
import UIKit
import YandexMobileAds

final class YandexAppOpenAdManager: NSObject, AppOpenAdManager {
    private var isLoadingAd = false
    private var isShowingAd = false
    private var loadTime: Date?
    private let fourHoursInSeconds = TimeInterval(3600 * 4)
    
    static let shared = YandexAppOpenAdManager()
    
    var delegate: AppOpenAdManagerDelegate?

    private lazy var appOpenAdLoader: AppOpenAdLoader = {
         let loader = AppOpenAdLoader()
         loader.delegate = self
         return loader
     }()
    
    private var appOpenAd: AppOpenAd? {
        didSet {
            loadTime = Date()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override init() {
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(connectionChanged), name: .networkAvailabilityChanged, object: nil)
    }
    
    @objc private func connectionChanged() {
        guard NetworkManager.shared.isConnected else { return }
        loadAd()
    }
    
    private func loadAd() {
        // Do not load ad if there is an unused ad or one is already loading.
        if isLoadingAd || isAdAvailable() || !NetworkManager.shared.isConnected {
            return
        }
        
        isLoadingAd = true
        
#if DEBUG
        let configuration = AdRequestConfiguration(adUnitID: "demo-appopenad-yandex")
#else
        let configuration = AdRequestConfiguration(adUnitID: "R-M-14550241-2")
#endif
        self.appOpenAdLoader.loadAd(with: configuration)
    }

    func showAdIfAvailable(from vc: UIViewController?) {
        // If the app open ad is already showing, do not show the ad again.
        guard !isShowingAd else { return }
        
        // If the app open ad is not available yet but is supposed to show, load
        // a new ad.
        if !isAdAvailable() && NetworkManager.shared.isConnected {
            loadAd()
            return
        }
        
        showAd(from: vc)
    }
    
    private func showAd(from vc: UIViewController?) {
        if let ad = appOpenAd {
            isShowingAd = true
            ad.show(from: vc)
        }
    }
    
    private func isAdAvailable() -> Bool {
        // Check if ad exists and can be shown.
        return appOpenAd != nil && wasLoadTimeLessThanFourHoursAgo()
    }
    
    private func wasLoadTimeLessThanFourHoursAgo() -> Bool {
        guard let loadTime = loadTime else { return false }
        // Check if ad was loaded more than four hours ago.
        return Date().timeIntervalSince(loadTime) < fourHoursInSeconds
    }
}

extension YandexAppOpenAdManager: AppOpenAdLoaderDelegate {
    func appOpenAdLoader(_ adLoader: YandexMobileAds.AppOpenAdLoader, didLoad appOpenAd: YandexMobileAds.AppOpenAd) {
        print("YandexAppOpenAdManager appOpenAdLoader didLoad")
        self.appOpenAd = appOpenAd
        self.appOpenAd?.delegate = self
        self.isLoadingAd = false
    }
    
    func appOpenAdLoader(_ adLoader: YandexMobileAds.AppOpenAdLoader, didFailToLoadWithError error: YandexMobileAds.AdRequestError) {
        print("YandexAppOpenAdManager appOpenAdLoader didFailToLoadWithError: \(error)")
        self.isLoadingAd = false
    }
}

extension YandexAppOpenAdManager: AppOpenAdDelegate {
    func appOpenAdDidShow(_ appOpenAd: AppOpenAd) {
        print("YandexAppOpenAdManager appOpenAdDidShow")
    }
    
    func appOpenAd(_ appOpenAd: AppOpenAd, didFailToShowWithError error: any Error) {
        print("YandexAppOpenAdManager appOpenAd didFailToShowWithError: \(error.localizedDescription)")
        self.appOpenAd = nil
        isShowingAd = false
        loadAd()
    }
    
    func appOpenAdDidDismiss(_ appOpenAd: AppOpenAd) {
        print("YandexAppOpenAdManager appOpenAdDidDismiss")
        self.appOpenAd = nil
        isShowingAd = false
        delegate?.didShowAd()
        loadAd()
    }
}
