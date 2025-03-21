//
//  CreateChallengeImageVC.swift
//  LidaChallenges
//
//  Created by Ihar Karunny on 7/28/24.
//

import UIKit
import Photos

final class CreateChallengeImageVC: UIViewController {
    private lazy var window: UIWindow? = {
        return navigationController?.view.window
    }()
    
    private enum Constants {
        static let offset: CGFloat = 16
    }
    
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.dataSource = self
        collection.delegate = self
        collection.backgroundColor = .clear
        collection.showsVerticalScrollIndicator = false
        if let layout = collection.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
        }
        
        return collection
    }()
    
    var onPickImage: ((UIImage) -> Void)?
    
    private lazy var builtInIconNames: [String] = {
        var result: [String] = []
        
        for i in 1...84 {
            result.append("challengeIconPick_\(i)")
        }
        
        return result
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .clear
        
        navigationItem.title = "CreateChallengeImagePickerTitle".localised()
        
        view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.offset).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.offset).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -OffsetsService.shared.bottomOffset).isActive = true
        
        collectionView.register(CreateChallengeImagePickGalleryCell.self, forCellWithReuseIdentifier: "CreateChallengeImagePickGalleryCell")
        collectionView.register(CreateChallengeImagePickCell.self, forCellWithReuseIdentifier: "CreateChallengeImagePickCell")
    }
    
    private func toGalleryPicker() {
        let status = PHPhotoLibrary.authorizationStatus()
        
        switch status {
        case .denied, .restricted:
            AlertsPresenter.presentAlertNoLibraryAccess(from: navigationController ?? self)
        default:
            let nativePicker = UIImagePickerController()
            nativePicker.allowsEditing = true
            nativePicker.delegate = self
            (navigationController ?? self).present(nativePicker, animated: true)
        }
    }
}

extension CreateChallengeImageVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: Constants.offset, left: 0, bottom: Constants.offset, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        Constants.offset
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        Constants.offset
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return builtInIconNames.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CreateChallengeImagePickGalleryCell", for: indexPath) as! CreateChallengeImagePickGalleryCell
            cell.set(text: "CreateChallengeImagePickerGallery".localised())
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CreateChallengeImagePickCell", for: indexPath) as! CreateChallengeImagePickCell
            cell.set(iconName: builtInIconNames[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionWidth = (window?.bounds.width ?? 0) - 2 * Constants.offset
        switch indexPath.section {
        case 0:
            return CGSize(width: collectionWidth, height: 62)
        default:
            let inRow = 3
            let cellWidthOffset = Constants.offset * CGFloat(inRow - 1)
            let cellWidth = floor((collectionWidth - cellWidthOffset) / CGFloat(inRow))
            return CGSize(width: cellWidth, height: cellWidth)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0: toGalleryPicker()
        default:
            let imageName = builtInIconNames[indexPath.row]
            guard let icon = UIImage(named: imageName) else { return }
            onPickImage?(icon)
            navigationController?.popViewController(animated: true)
        }
    }
}

extension CreateChallengeImageVC: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let newImage = info[.editedImage] as? UIImage {
            let pickedImage = UIImageResizer.resizeTo720p(image: newImage)
            onPickImage?(pickedImage)
        }
        
        picker.dismiss(animated: true)
        navigationController?.popViewController(animated: true)
    }
}
