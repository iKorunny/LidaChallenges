//
//  MainVC.swift
//  LidaChallenges
//
//  Created by Ihar Karunny on 6/17/24.
//

import UIKit

final class MainVC: UIViewController {
    private lazy var window: UIWindow? = {
        return navigationController?.view.window
    }()
    
    private let source: CategoriesSource = CategoriesSourceImpl()
    
    private var onceAppeared = false
    
    private lazy var activityManager: AppActivityManager = {
        return AppActivityManager()
    }()
    
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = FontsProvider.regularAppFont(with: 20)
        label.textColor = ColorThemeProvider.shared.itemTextTitle
        label.numberOfLines = 1
        label.text = "CategoriesTitle".localised()
        label.contentMode = .left
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.dataSource = self
        collection.delegate = self
        collection.backgroundColor = .clear
        collection.showsHorizontalScrollIndicator = false
        if let layout = collection.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        return collection
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .clear
        scrollView.alwaysBounceVertical = true
        scrollView.delegate = self
        return scrollView
    }()
    
    private lazy var scrollContentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .clear
        return contentView
    }()
    
    private var actionItems: [MainVCListActionItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = ""
        
        actionItems = [
            MainVCListActionItem(image: UIImage(named: "CreateChallengeAction")!,
                                 title: "CreateChallengeActionTitle".localised(),
                                 action: { _ in
                                     AppRouter.shared.toStartCreateChallenge()
                                 }),
            MainVCListActionItem(image: UIImage(named: "RandomChallengeAction")!,
                                 title: "RandomChallengeActionTitle".localised(),
                                 action: { [weak self] item in
                                     print("action \(item.title)")
                                     guard let self else { return }
                                     self.activityManager.lock(vc: self)
                                     
                                     DatabaseService.shared.fetchRandomChallenge { [weak self] challenge in
                                         DispatchQueue.main.async { [weak self] in
                                             self?.activityManager.unlock(onUnlock: {
                                                 guard let challenge else { return }
                                                 AppRouter.shared.toOpenChallenge(model: challenge)
                                             })
                                         }
                                     }
                                 }),
            MainVCListActionItem(image: UIImage(named: "CreatedChallenges")!,
                                 title: "CreatedChallengesActionTitle".localised(),
                                 action: { [weak self] item in
                                     print("action \(item.title)")
                                     
                                     guard let self else { return }
                                     self.activityManager.lock(vc: self)
                                     
                                     DatabaseService.shared.fetchHasCustomChallenges { [weak self] hasCustomChallenges in
                                         DispatchQueue.main.async { [weak self] in
                                             self?.activityManager.unlock(onUnlock: {
                                                 if hasCustomChallenges {
                                                     AppRouter.shared.toChallengesList(categoryID: 0)
                                                 }
                                                 else {
                                                     AppRouter.shared.toStartCreateChallenge()
                                                 }
                                             })
                                         }
                                     }
                                 }),
            MainVCListActionItem(image: UIImage(named: "CompletedChallengesAction")!,
                                 title: "CompletedChallengesActionTitle".localised(),
                                 action: { item in
                                     print("action \(item.title)")
                                     
                                     AppRouter.shared.toMyChallenges(with: .completed,
                                                                     screenTitle: "CompletedChallengesActionTitle".localised())
                                 })
        ]

        view.backgroundColor = .clear
        setupCollection()
        addSearch()
        addScroll()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !onceAppeared && source.categoriesCount > 2 {
            onceAppeared = true
            let middleIndex = Int(floor(Double(source.categoriesCount) / 2.0))
            collectionView.scrollToItem(at: IndexPath(row: middleIndex, section: 0), at: .centeredHorizontally, animated: false)
        }
    }
    
    private func setupCollection() {
        collectionView.register(MainCategoriesCell.self, forCellWithReuseIdentifier: "MainCategoriesCell")
    }
    
    private func addSearch() {
        let resultController = ChallengesSearchResultController()
        let search = UISearchController(searchResultsController: resultController)
        search.searchResultsUpdater = resultController
        search.delegate = self
        search.searchBar.delegate = self
        self.navigationItem.searchController = search
        search.searchBar.sizeToFit()
    }
    
    private func addScroll() {
        view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        scrollView.addSubview(scrollContentView)
        scrollContentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        scrollContentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        scrollContentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        scrollContentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        
        scrollContentView.addSubview(headerLabel)
        headerLabel.topAnchor.constraint(equalTo: scrollContentView.topAnchor, constant: 32).isActive = true
        headerLabel.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 19).isActive = true
        headerLabel.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -19).isActive = true
        
        addCollectionView()
        addActionButtons()
    }
    
    private func addCollectionView() {
        scrollContentView.addSubview(collectionView)
        collectionView.heightAnchor.constraint(equalToConstant: 169).isActive = true
        collectionView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 33).isActive = true
//        collectionView.bottomAnchor.constraint(equalTo: scrollContentView.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor).isActive = true
    }
    
    private func addActionButtons() {
        var previousView: UIView = collectionView
        for i in 0..<actionItems.count {
            let actionView = MainVCListActionView()
            actionView.backgroundColor = ColorThemeProvider.shared.itemBackground
            actionView.layer.masksToBounds = true
            actionView.layer.cornerRadius = 10
            actionView.translatesAutoresizingMaskIntoConstraints = false
            
            scrollContentView.addSubview(actionView)
            actionView.fill(with: actionItems[i])
            
            actionView.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 18).isActive = true
            actionView.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -18).isActive = true
            actionView.heightAnchor.constraint(equalToConstant: 48).isActive = true
            actionView.topAnchor.constraint(equalTo: previousView.bottomAnchor, constant: 23).isActive = true
            
            let isLast = i == (actionItems.count - 1)
            if isLast {
                actionView.bottomAnchor.constraint(equalTo: scrollContentView.bottomAnchor).isActive = true
            }
            previousView = actionView
        }
    }
}

extension MainVC: UISearchControllerDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
    }
}

extension MainVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
}

extension MainVC: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView === self.scrollView && scrollView.isTracking {
            navigationItem.searchController?.searchBar.resignFirstResponder()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView === collectionView {
            collectionViewStoppedScroll()
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard scrollView === collectionView else { return }
        if decelerate {
            return
        }
        collectionViewStoppedScroll()
    }
    
    private func collectionViewStoppedScroll() {
        let pageOffset: CGFloat = 237 + 38
        let page: Int = Int(round(collectionView.contentOffset.x / pageOffset))
        collectionView.setContentOffset(CGPoint(x: pageOffset * Double(page), y: 0), animated: true)
    }
}

extension MainVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return source.categoriesCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCategoriesCell", for: indexPath) as? MainCategoriesCell else { return UICollectionViewCell() }
        
        let categories = source.categories
        let category = categories[indexPath.row]
        cell.set(text: category.title, image: category.icon)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 237, height: 169)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 34
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        guard let screenWidth = window?.bounds.width else { return UIEdgeInsets.zero }
        let inset = screenWidth * 0.5 - 237 * 0.5
        return UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        AppRouter.shared.toChallengesList(categoryID: source.categories[indexPath.row].id)
    }
}
