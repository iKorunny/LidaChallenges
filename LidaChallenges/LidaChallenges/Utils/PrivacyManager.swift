//
//  PrivacyManager.swift
//  LidaChallenges
//
//  Created by Лидия on 6.04.25.
//

import Foundation
import AppTrackingTransparency

private enum Constants {
    static let attKey = "PrivacyManager_attKey"
}

final class PrivacyManager {
    static let shared = PrivacyManager()
    
    func attGranted(completion: @escaping ((Bool) -> Void)) {
        guard !UserDefaults.standard.bool(forKey: Constants.attKey) else {
            completion(convertToBoolATT(status: ATTrackingManager.trackingAuthorizationStatus))
            return
        }
        
        ATTrackingManager.requestTrackingAuthorization { [weak self] status in
            guard let self else { return }
            if attAnsweredByUser(status: status) {
                UserDefaults.standard.set(true, forKey: Constants.attKey)
            }
            completion(convertToBoolATT(status: status))
        }
    }
    
    private func convertToBoolATT(status: ATTrackingManager.AuthorizationStatus) -> Bool {
        switch status {
        case .authorized:
            return true
        case .denied, .restricted, .notDetermined:
            return false
        @unknown default:
            return false
        }
    }
    
    private func attAnsweredByUser(status: ATTrackingManager.AuthorizationStatus) -> Bool {
        switch status {
        case .authorized, .denied:
            return true
        case .restricted, .notDetermined:
            return false
        @unknown default:
            return false
        }
    }
}
