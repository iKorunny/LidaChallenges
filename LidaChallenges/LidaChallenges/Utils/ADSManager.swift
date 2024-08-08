//
//  ADSManager.swift
//  LidaChallenges
//
//  Created by Ihar Karunny on 8/5/24.
//

import Foundation
import GoogleMobileAds

private enum Constants {
    static let becomeActiveToShowLaunchAd: Int = 3
    static let becomeActiveCountKey = "becomeActiveCountKey"
}

final class ADSManager: NSObject {
    static var shared = ADSManager()
    
    private var becomeActiveCount: Int {
        get { UserDefaults.standard.integer(forKey: Constants.becomeActiveCountKey) }
        set { UserDefaults.standard.setValue(newValue, forKey: Constants.becomeActiveCountKey) }
    }
    
    private var bannerView: GADBannerView? {
        didSet {
            bannerView?.delegate = self
        }
    }
    
    func showOnLaunchAdIfNeeded(fromv vc: UIViewController?) {
        guard becomeActiveCount >= Constants.becomeActiveToShowLaunchAd else { return }
        AppOpenAdManager.shared.showAdIfAvailable(from: vc)
    }
    
    func initialise() {
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        AppOpenAdManager.shared.delegate = self
        
#if DEBUG
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [ 
            "eb056001e5ff10f475b2f43c8c330a71",
            "98ad7d9978019bd4798e462320666fa0"
        ]
#endif
    }
    
    func didBecomeActive() {
        becomeActiveCount += 1
    }
    
    func setupBannerView(_ view: GADBannerView, from rootVC: UIViewController) {
        bannerView = view
        bannerView?.adUnitID = "ca-app-pub-7140632902714147/2319187055"
        bannerView?.rootViewController = rootVC
        
        bannerView?.load(GADRequest())
    }
}

extension ADSManager: GADBannerViewDelegate {
    func bannerViewDidRecordClick(_ bannerView: GADBannerView) {
        print("ADSManager did record click")
    }
    
    func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
        print("ADSManager did record impression")
    }
}

extension ADSManager: AppOpenAdManagerDelegate {
    func didShowAd() {
        becomeActiveCount = 0
    }
}
