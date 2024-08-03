//
//  AlertsPresenter.swift
//  LidaChallenges
//
//  Created by Ihar Karunny on 8/3/24.
//

import Foundation
import UIKit

final class AlertsPresenter {
    static func presentAlertNoLibraryAccess(from vc: UIViewController) {
        let alertController = UIAlertController (title: "NoLibraryAccessAlertTitle".localised(), message: "NoLibraryAccessAlertBody".localised(), preferredStyle: .alert)
        let toSettingsAction = UIAlertAction(title: "AlertToSettingsButtonTitle".localised(), style: .default) { _ in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString),
            UIApplication.shared.canOpenURL(settingsUrl) else { return }
            UIApplication.shared.open(settingsUrl)
        }
        
        alertController.addAction(toSettingsAction)
        alertController.addAction(.init(title: "AlertCancelButtonTitle".localised(), style: .cancel))
        alertController.modalPresentationStyle = .overFullScreen
        
        vc.present(alertController, animated: true)
    }
}
