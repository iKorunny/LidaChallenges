//
//  URLSchemeManager.swift
//  LidaChallenges
//
//  Created by Лидия on 16.03.25.
//
import UIKit

final class URLSchemeManager {
    
    static let shared = URLSchemeManager()
    
    private enum Constants {
        static let openBuiltInChallengPrefix = "challengetime://bic_"
        static let cryptKey = 10
    }
    
    func shareBuiltInChallenge(with id: String, from vc: UIViewController) {
        let text = "\(Constants.openBuiltInChallengPrefix)\(Ceasar.caesarize(str: id, withOffset: Constants.cryptKey))"
        
        let textsToShare = [text]
        
        let activityViewController = UIActivityViewController(activityItems: textsToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = vc.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        
        // present the view controller
        vc.present(activityViewController, animated: true, completion: nil)
    }
    
    func tryToHandleBuiltInChallengeURLScheme(_ scheme: URL) -> Bool {
        if scheme.absoluteString.hasPrefix(Constants.openBuiltInChallengPrefix) {
            let cryptedID = String(scheme.absoluteString.dropFirst(Constants.openBuiltInChallengPrefix.count))
            let decryptedID = Ceasar.caesarize(str: cryptedID, withOffset: -Constants.cryptKey)
            DatabaseService.shared.fetchBuiltInChallenge(with: decryptedID) { challenge in
                guard let challenge else { return }
                
                DispatchQueue.main.async {
                    AppRouter.shared.toOpenChallenge(model: challenge, delayIfNeeded: true)
                }
            }
        }
        
        return false
    }
}
