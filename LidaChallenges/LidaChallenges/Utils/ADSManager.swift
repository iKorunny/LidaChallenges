//
//  ADSManager.swift
//  LidaChallenges
//
//  Created by Ihar Karunny on 8/5/24.
//

import Foundation
import GoogleMobileAds

final class ADSManager {
    static func initialise() {
        GADMobileAds.sharedInstance().start(completionHandler: nil)
    }
}
