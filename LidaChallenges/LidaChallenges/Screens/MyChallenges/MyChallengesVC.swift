//
//  MyChallengesVC.swift
//  LidaChallenges
//
//  Created by Ihar Karunny on 7/15/24.
//

import UIKit

enum MyChallengesVCState {
    case noData
    case hasData
}

private struct Constants {
    static let headerID = "MyChallengesVCHeader"
    static let cellID = "MyChallengesVCCell"
}

enum MyChallengesVCMode {
    case all
    case completed
    
    func activeSupported() -> Bool {
        switch self {
        case .all:
            return true
        case .completed:
            return false
        }
    }
    
    func completedSupported() -> Bool {
        switch self {
        case .all:
            return true
        case .completed:
            return true
        }
    }
}

final class MyChallengesVC: UIViewController {
    
    private lazy var window: UIWindow? = {
        return navigationController?.view.window
    }()
    
    private var state: MyChallengesVCState = .noData {
        didSet {
            stateChanged(newState: state)
        }
    }
    
    private var sections: [MyChallengesSection] = [] {
        didSet {
            state = sections.isEmpty ? .noData : .hasData
        }
    }
    
    private lazy var activityManager: AppActivityManager = {
        return AppActivityManager()
    }()
    
    private lazy var noDataLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = FontsProvider.regularAppFont(with: 24)
        label.textColor = ColorThemeProvider.shared.warningItem
        label.text = "MyChallengesNoData".localised()
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collection = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .clear
        
        collection.delegate = self
        collection.dataSource = self
        
        collection.register(MyChallengesSectionHeader.self,
                            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                            withReuseIdentifier: Constants.headerID)
        
        collection.register(MyChallengesCell.self, forCellWithReuseIdentifier: Constants.cellID)
        
        collection.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: OffsetsService.shared.bottomOffset, right: 0)
        
        return collection
    }()
    
    var mode: MyChallengesVCMode = .all
    var screenTitle: String?
    private var shouldReloadData = true

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .clear
        navigationItem.title = screenTitle ?? "MyChallengesLargeButtonTitle".localised()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: FontsProvider.regularAppFont(with: 20),
                                                                   .foregroundColor: ColorThemeProvider.shared.itemTextTitle]
        view.addSubview(noDataLabel)
        noDataLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        noDataLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -OffsetsService.shared.bottomOffset).isActive = true
        
        stateChanged(newState: state)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reloadDataIfNeeded()
    }
    
    private func reloadDataIfNeeded() {
        guard shouldReloadData else { return }
        shouldReloadData = false
        let isTopVC = navigationController?.topViewController == self
        if isTopVC, let navVC = navigationController {
            activityManager.lock(vc: navVC.parent ?? navVC)
        }
        
        DatabaseService.shared.fetchAllStartedChallenges { [weak self] challenges in
            let active = challenges?.filter({ !$0.isFinished }) ?? []
            let complete = challenges?.filter({ $0.isFinished }) ?? []
            DispatchQueue.main.async { [weak self] in
                let handleBlock: () -> Void = { [weak self] in
                    var newSections: [MyChallengesSection] = []
                    if !active.isEmpty && self?.mode.activeSupported() == true {
                        newSections.append(.init(title: "MyChallengesActiveTitle".localised(), challenges: active))
                    }
                    
                    if !complete.isEmpty && self?.mode.completedSupported() == true {
                        newSections.append(.init(title: "MyChallengesCompleteTitle".localised(), challenges: complete))
                    }
                    
                    self?.sections = newSections
                }
                
                if isTopVC {
                    self?.activityManager.unlock(onUnlock: handleBlock)
                }
                else {
                    handleBlock()
                }
            }
        }
    }
    
    private func stateChanged(newState: MyChallengesVCState) {
        switch newState {
        case .hasData:
            noDataLabel.isHidden = true
            collectionView.isHidden = false
        case .noData:
            noDataLabel.isHidden = false
            collectionView.isHidden = true
        }
        
        collectionView.reloadData()
    }
}

extension MyChallengesVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].challenges.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellID, for: indexPath) as? MyChallengesCell else { return UICollectionViewCell() }
        
        cell.fill(with: sections[indexPath.section].challenges[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else { return UICollectionReusableView() }
        
        let section = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Constants.headerID, for: indexPath) as! MyChallengesSectionHeader
        section.setupIfNeeded()
        section.titleLabel.text = sections[indexPath.section].title
        return section
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 35, bottom: 0, right: 35)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 40
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 40
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionWidth = (window?.bounds.width ?? 0) - 2 * 35
        let itemWidth = floor((collectionWidth - 40) * 0.5)
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let collectionWidth = (window?.bounds.width ?? 0)
        return CGSize(width: collectionWidth, height: 54)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = sections[indexPath.section].challenges[indexPath.row]
        AppRouter.shared.toStartedChallenge(model: model) { [weak self] in
            self?.shouldReloadData = true
        }
    }
}
