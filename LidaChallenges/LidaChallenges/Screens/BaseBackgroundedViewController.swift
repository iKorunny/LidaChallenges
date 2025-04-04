//
//  BaseBackgroundedViewController.swift
//  LidaChallenges
//
//  Created by Лидия on 4.04.25.
//

import UIKit

class BaseBackgroundedViewController: UIViewController {
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView(image: .init(named: "MainAppBackground"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
    }
    
    private func setupBackground() {
        view.addSubview(backgroundImageView)
        backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}
