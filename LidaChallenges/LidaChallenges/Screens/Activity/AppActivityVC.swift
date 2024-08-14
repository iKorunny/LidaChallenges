//
//  AppActivityVC.swift
//  LidaChallenges
//
//  Created by Ihar Karunny on 8/13/24.
//

import UIKit

protocol AppActivityView {
    func startAnimation()
    func stopAnimation()
}

final class AppActivityVC: UIViewController, AppActivityView {
    
    private lazy var activityView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black.withAlphaComponent(0.1)
        view.addSubview(activityView)
        activityView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func startAnimation() {
        activityView.startAnimating()
    }
    
    func stopAnimation() {
        activityView.stopAnimating()
    }
}
