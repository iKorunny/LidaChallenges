//
//  PrivacyManager.swift
//  LidaChallenges
//
//  Created by Лидия on 6.04.25.
//

import Foundation
import AppTrackingTransparency

final class PrivacyManager {
    static let shared = PrivacyManager()
    
    func attGranted(completion: @escaping ((Bool) -> Void)) {
        ATTrackingManager.requestTrackingAuthorization { [weak self] status in
            guard let self else { return }
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
