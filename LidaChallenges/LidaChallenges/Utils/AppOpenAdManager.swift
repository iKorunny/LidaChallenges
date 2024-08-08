//
//  AppOpenAdManager.swift
//  LidaChallenges
//
//  Created by Ihar Karunny on 8/8/24.
//

import Foundation
import GoogleMobileAds

protocol AppOpenAdManagerDelegate {
    func didShowAd()
}

final class AppOpenAdManager: NSObject {
    private var appOpenAd: GADAppOpenAd? {
        didSet {
            appOpenAd?.fullScreenContentDelegate = self
            loadTime = Date()
        }
    }
    private var isLoadingAd = false
    private var isShowingAd = false
    private var loadTime: Date?
    private let fourHoursInSeconds = TimeInterval(3600 * 4)
    
    static let shared = AppOpenAdManager()
    
    var delegate: AppOpenAdManagerDelegate?
    
    private func loadAd() async {
        // Do not load ad if there is an unused ad or one is already loading.
        if isLoadingAd || isAdAvailable() {
            return
        }
        isLoadingAd = true
        
        do {
            appOpenAd = try await GADAppOpenAd.load(
                withAdUnitID: "ca-app-pub-7140632902714147/6212772985", request: GADRequest())
        } catch {
            print("AppOpenAdManager: App open ad failed to load with error: \(error.localizedDescription)")
        }
        isLoadingAd = false
    }
    
    func showAdIfAvailable(from vc: UIViewController?) {
        // If the app open ad is already showing, do not show the ad again.
        guard !isShowingAd else { return }
        
        // If the app open ad is not available yet but is supposed to show, load
        // a new ad.
        if !isAdAvailable() {
            Task {
                await loadAd()
            }
            return
        }
        
        showAd(from: vc)
    }
    
    private func showAd(from vc: UIViewController?) {
        if let ad = appOpenAd, let vc {
            isShowingAd = true
            ad.present(fromRootViewController: vc)
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

extension AppOpenAdManager: GADFullScreenContentDelegate {
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("AppOpenAdManager: App open ad will be presented.")
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        appOpenAd = nil
        isShowingAd = false
        delegate?.didShowAd()
        // Reload an ad.
        Task {
            await loadAd()
        }
    }
    
    func ad(
        _ ad: GADFullScreenPresentingAd,
        didFailToPresentFullScreenContentWithError error: Error
    ) {
        appOpenAd = nil
        isShowingAd = false
        // Reload an ad.
        Task {
            await loadAd()
        }
    }
}
