//
//  AppRootVC.swift
//  LidaChallenges
//
//  Created by Ihar Karunny on 6/17/24.
//

import UIKit

class AppRootVC: UIViewController {
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView(image: .init(named: "MainAppBackground"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var containerView: UIView = {
        let newView = UIView()
        newView.backgroundColor = .clear
        newView.translatesAutoresizingMaskIntoConstraints = false
        return newView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(backgroundImageView)
        backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        view.addSubview(containerView)
        containerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true // TODO: containt to advertising view
        
        toMainVC()
    }
    
    private func toMainVC() {
        let nextVC = UINavigationController(rootViewController: MainVC())
        
        smartAddChild(vc: nextVC, to: containerView)
    }
}
