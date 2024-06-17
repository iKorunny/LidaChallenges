//
//  Controller+Childred.swift
//  LidaChallenges
//
//  Created by Ihar Karunny on 6/17/24.
//

import Foundation
import UIKit

extension UIViewController {
    func smartAddChild(vc: UIViewController, to containerView: UIView) {
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        
        vc.willMove(toParent: self)
        containerView.addSubview(vc.view)
        vc.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        vc.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        vc.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        vc.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        addChild(vc)
        vc.didMove(toParent: self)
    }
    
    func smartRemoveChild(vc: UIViewController) {
        vc.willMove(toParent: nil)
        vc.view.removeFromSuperview()
        vc.removeFromParent()
        vc.didMove(toParent: nil)
    }
}
