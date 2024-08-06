//
//  ADSManager.swift
//  LidaChallenges
//
//  Created by Ihar Karunny on 8/5/24.
//

import Foundation
import GoogleMobileAds

final class ADSManager {
    static var shared = ADSManager()
    
    private var bannerView: GADBannerView?
    
    func initialise() {
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
#if DEBUG
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [ 
            "eb056001e5ff10f475b2f43c8c330a71",
            "98ad7d9978019bd4798e462320666fa0"
        ]
#endif
    }
    
    func setupBannerView(_ view: GADBannerView, from rootVC: UIViewController) {
        bannerView = view
        bannerView?.adUnitID = "ca-app-pub-7140632902714147/2319187055"
        bannerView?.rootViewController = rootVC
        
        bannerView?.load(GADRequest())
    }
}
