//
//  PopupVC.swift
//  LidaChallenges
//
//  Created by Ihar Karunny on 10/8/24.
//

import UIKit

struct PopupVCConfig {
    let overlayBackground: Bool
    let overlayColor: UIColor
    let autodismiss: Bool
}

final class PopupVC: UIViewController {
    deinit {
        view.removeGestureRecognizer(dismissGesture)
    }
    
    private lazy var dismissGesture: UITapGestureRecognizer = {
        UITapGestureRecognizer(target: self, action: #selector(dismissIfNeeded))
    }()
    
    private(set) var contentView: UIView
    
    private let config: PopupVCConfig
    
    init(with content: UIView, config: PopupVCConfig) {
        self.contentView = content
        self.config = config
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if config.overlayBackground {
            view.backgroundColor = config.overlayColor
        }
        else {
            view.backgroundColor = .clear
        }
        
        if config.autodismiss {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
                self?.dismissIfNeeded()
            }
        }
        
        view.addSubview(contentView)
        contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        contentView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        view.addGestureRecognizer(dismissGesture)
    }
    
    @objc private func dismissIfNeeded() {
        guard !isBeingDismissed else { return }
        dismiss(animated: true)
    }
}
