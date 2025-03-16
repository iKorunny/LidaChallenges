//
//  YandexADSManager.swift
//  LidaChallenges
//
//  Created by Ihar Karunny on 8/5/24.
//

import Foundation
import UIKit
import YandexMobileAds

final class YandexADSManager: NSObject, ADSManager {
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    var onAdAvailable: ((Bool) -> Void)?
    
    var adAvailable: Bool = false
    
    static var shared = GoogleADSManager()
    
    private var becomeActiveCount: Int {
        get { UserDefaults.standard.integer(forKey: AdsManagerConstants.becomeActiveCountKey) }
        set { UserDefaults.standard.setValue(newValue, forKey: AdsManagerConstants.becomeActiveCountKey) }
    }
    
    private var bannerView: AdView?
    
    func showOnLaunchAdIfNeeded(fromv vc: UIViewController?) {
        guard becomeActiveCount >= AdsManagerConstants.becomeActiveToShowLaunchAd else { return }
        ADSGodContainer.shared.appOpenAdManager.showAdIfAvailable(from: vc)
    }
    
    func initialise() {
        MobileAds.initializeSDK()
        ADSGodContainer.shared.appOpenAdManager.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(connectionChanged), name: .networkAvailabilityChanged, object: nil)
    }
    
    func didBecomeActive() {
        becomeActiveCount += 1
    }
    
    func createBannerView(with width: CGFloat, useCache: Bool = true) -> UIView {
        if useCache && bannerView != nil {
            return bannerView!
        }
        
        let adSize = BannerAdSize.stickySize(withContainerWidth: width)
#if DEBUG
        let adView = AdView(adUnitID: "demo-banner-yandex", adSize: adSize)
#else
        let adView = AdView(adUnitID: "R-M-14550241-2", adSize: adSize)
#endif
        adView.delegate = self
        adView.translatesAutoresizingMaskIntoConstraints = false
        
        if useCache {
            bannerView = adView
        }
        
        return adView
    }
    
    private func loadAd() {
        bannerView?.loadAd()
    }
    
    func setupBannerView(from rootVC: UIViewController) {
        loadAd()
    }
    
    @objc private func connectionChanged() {
        guard NetworkManager.shared.isConnected else { return }
        loadAd()
    }
}

extension YandexADSManager: AdViewDelegate {
    func adViewDidLoad(_ adView: AdView) {
        print("YandexADSManager adViewDidLoad")
        adAvailable = true
        onAdAvailable?(adAvailable)
    }
    
    func adViewDidFailLoading(_ adView: AdView, error: any Error) {
        print("adViewDidLoad adViewDidFailLoading error: \(error.localizedDescription)")
        adAvailable = false
        onAdAvailable?(adAvailable)
    }
    
    func adView(_ adView: AdView, didTrackImpression impressionData: (any ImpressionData)?) {
        print("YandexADSManager didTrackImpression didTrackImpression: \(impressionData?.rawData ?? "")")
    }
    
    func adViewDidClick(_ adView: AdView) {
        print("YandexADSManager adViewDidClick")
    }
}

extension YandexADSManager: AppOpenAdManagerDelegate {
    func didShowAd() {
        becomeActiveCount = 0
    }
}
