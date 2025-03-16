//
//  GoogleADSManager.swift
//  LidaChallenges
//
//  Created by Ihar Karunny on 8/5/24.
//

import Foundation
import UIKit
//import GoogleMobileAds

final class GoogleADSManager: NSObject, ADSManager {
    var onAdAvailable: ((Bool) -> Void)?
    var adAvailable: Bool = false
    
    static var shared = GoogleADSManager()
    
    private var becomeActiveCount: Int {
        get { UserDefaults.standard.integer(forKey: AdsManagerConstants.becomeActiveCountKey) }
        set { UserDefaults.standard.setValue(newValue, forKey: AdsManagerConstants.becomeActiveCountKey) }
    }
    
//    private var bannerView: GADBannerView? {
//        didSet {
//            bannerView?.delegate = self
//        }
//    }
    
    func showOnLaunchAdIfNeeded(fromv vc: UIViewController?) {
        guard becomeActiveCount >= AdsManagerConstants.becomeActiveToShowLaunchAd else { return }
//        ADSGodContainer.shared.showAdIfAvailable(from: vc)
    }
    
    func initialise() {
//        GADMobileAds.sharedInstance().start(completionHandler: nil)
        ADSGodContainer.shared.appOpenAdManager.delegate = self
        
#if DEBUG
//        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [ 
//            "eb056001e5ff10f475b2f43c8c330a71",
//            "98ad7d9978019bd4798e462320666fa0"
//        ]
#endif
    }
    
    func didBecomeActive() {
        becomeActiveCount += 1
    }
    
    func createBannerView(with width: CGFloat, useCache: Bool) -> UIView {
//        if useCache && bannerView != nil {
//            return bannerView!
//        }
//        
//        let adaptiveSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(viewWidth)
//        let banner = GADBannerView(adSize: adaptiveSize)
//        banner.translatesAutoresizingMaskIntoConstraints = false
//        
//        if useCache {
//            bannerView = banner
//        }
//        
//        return banner
        let banner = UIView()
        banner.translatesAutoresizingMaskIntoConstraints = false
        return banner
    }
    
    func setupBannerView(from rootVC: UIViewController) {
//        bannerView?.adUnitID = "ca-app-pub-7140632902714147/2319187055"
//        bannerView?.rootViewController = rootVC
//        
//        bannerView?.load(GADRequest())
    }
}

//extension ADSManager: GADBannerViewDelegate {
//adAvailable = false // set on didLoad and loadToFail
//onAdAvailable(adView)
//    func bannerViewDidRecordClick(_ bannerView: GADBannerView) {
//        print("ADSManager did record click")
//    }
//    
//    func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
//        print("ADSManager did record impression")
//    }
//}

extension GoogleADSManager: AppOpenAdManagerDelegate {
    func didShowAd() {
        becomeActiveCount = 0
    }
}
