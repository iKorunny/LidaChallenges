//
//  StartedChallengeDetailsVC.swift
//  LidaChallenges
//
//  Created by Ihar Karunny on 9/3/24.
//

import UIKit

private enum Constants {
    static let cellID = "ChallengeDayCell"
}

final class StartedChallengeDetailsVC: UIViewController {
    
    let model: StartedChallenge
    
    private var keyboardService: KeyboardAppearService?
    
    private lazy var infoButton: UIBarButtonItem = {
        UIBarButtonItem(image: UIImage(named: "ChallengeInfoIcon"),
                        style: .plain,
                        target: self,
                        action: #selector(onInfo))
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = FontsProvider.regularAppFont(with: 14)
        label.textColor = ColorThemeProvider.shared.subtitle
        label.textAlignment = .left
        return label
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.backgroundColor = .clear
        scroll.alwaysBounceVertical = true
        scroll.delegate = self
        
        scroll.addSubview(scrollContent)
        
        scrollContent.topAnchor.constraint(equalTo: scroll.topAnchor).isActive = true
        scrollContent.bottomAnchor.constraint(equalTo: scroll.bottomAnchor).isActive = true
        scrollContent.leadingAnchor.constraint(equalTo: scroll.leadingAnchor).isActive = true
        scrollContent.trailingAnchor.constraint(equalTo: scroll.trailingAnchor).isActive = true
        scrollContent.widthAnchor.constraint(equalTo: scroll.widthAnchor).isActive = true
        let heighAnchor = scrollContent.heightAnchor.constraint(equalTo: scroll.heightAnchor)
        heighAnchor.priority = .defaultLow
        heighAnchor.isActive = true
        
        return scroll
    }()
    
    private lazy var scrollContent: UIView = {
        let content = UIView()
        content.translatesAutoresizingMaskIntoConstraints = false
        content.backgroundColor = .clear
        
        content.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: content.topAnchor, constant: 57).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: content.leadingAnchor, constant: 52).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: content.trailingAnchor, constant: -52).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: calculatedCollectionHeight).isActive = true
        
        return content
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collection = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .clear
        
        collection.delegate = self
        collection.dataSource = self
        
        collection.register(ChallengeDayCell.self, forCellWithReuseIdentifier: Constants.cellID)
        
        return collection
    }()
    
    private lazy var window: UIWindow? = {
        return navigationController?.view.window
    }()
    
    init(model: StartedChallenge) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    private var hasSubtitle: Bool {
        model.originalChallenge.subtitle != nil
    }
    
    private var numberOfDays: Int {
        model.originalChallenge.daysCount
    }
    
    private var daysPerLine = 5
    
    private lazy var cellSize: CGSize = {
        let perLine = daysPerLine
        let collectionWidth = (window?.bounds.width ?? 0) - 2 * 52
        let itemWidth = floor((collectionWidth - 6 * CGFloat(perLine - 1)) / CGFloat(perLine))
        return CGSize(width: itemWidth, height: itemWidth)
    }()
    
    private lazy var dayLines: Int = {
       return Int(ceil(CGFloat(numberOfDays) / CGFloat(daysPerLine)))
    }()
    
    private var calculatedCollectionHeight: CGFloat {
        return CGFloat(dayLines) * cellSize.height + CGFloat(dayLines - 1) * 6
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = model.originalChallenge.title
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: FontsProvider.regularAppFont(with: 32),
                                                                   .foregroundColor: ColorThemeProvider.shared.itemTextTitle]
        navigationItem.rightBarButtonItem = infoButton
        
        view.addSubview(scrollView)
        
        if hasSubtitle {
            view.addSubview(subtitleLabel)
            subtitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 23).isActive = true
            subtitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18).isActive = true
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 130).isActive = true
            subtitleLabel.text = model.originalChallenge.subtitle
            
            scrollView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor).isActive = true
        }
        else {
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        }
        
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        let scrollBottom = scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -OffsetsService.shared.bottomOffset)
        scrollBottom.isActive = true
        keyboardService = KeyboardAppearService(mainView: view, bottomConstraint: scrollBottom)
        
        

        view.backgroundColor = .clear
    }
    
    @objc private func onInfo() {
        AppRouter.shared.toOpenChallengeInfo(model: model.originalChallenge)
    }
    
    private func hideInputViews() {
        
    }
}

extension StartedChallengeDetailsVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView === self.scrollView {
            guard scrollView.isTracking else { return }
            hideInputViews()
        }
    }
}

extension StartedChallengeDetailsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfDays
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellID, for: indexPath) as? ChallengeDayCell else { return UICollectionViewCell() }
        
        cell.setupIfNeeded()
        cell.set(state: ChallengeDayCellState(rawValue: Int.random(in: 0...3))!)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 6
    }
}
