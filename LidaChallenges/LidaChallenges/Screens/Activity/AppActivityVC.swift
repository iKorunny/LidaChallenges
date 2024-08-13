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
    
    private lazy var loadingImage: UIImageView = {
        let imageView = UIImageView(image: .init(named: "AppLoader"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var animation: CABasicAnimation = {
        let rotation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        
        rotation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        rotation.toValue = -CGFloat.pi * 4
        rotation.duration = 2
        rotation.isCumulative = true
        rotation.autoreverses = true
        rotation.repeatCount = .greatestFiniteMagnitude
        return rotation
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black.withAlphaComponent(0.1)
        view.addSubview(loadingImage)
        loadingImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loadingImage.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func startAnimation() {
        loadingImage.layer.add(animation, forKey: "rotationAnimation")
    }
    
    func stopAnimation() {
        loadingImage.layer.removeAnimation(forKey: "rotationAnimation")
    }
}
