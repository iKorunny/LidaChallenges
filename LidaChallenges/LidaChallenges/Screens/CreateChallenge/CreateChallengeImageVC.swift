//
//  CreateChallengeImageVC.swift
//  LidaChallenges
//
//  Created by Ihar Karunny on 7/28/24.
//

import UIKit

final class CreateChallengeImageVC: UIViewController {
    
    var onPickImage: ((UIImage) -> Void)?
    
    private lazy var saveButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "CreateChallengeImagePickerSave".localised(),
                                     style: .plain,
                                     target: self,
                                     action: #selector(onSave))
        button.isEnabled = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .clear
        
        navigationItem.title = "CreateChallengeImagePickerTitle".localised()
        navigationItem.rightBarButtonItem = saveButton
    }
    

    @objc private func onSave() {
        
    }
}
