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

final class StartedChallengeDetailsVC: BaseBackgroundedViewController {
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    var model: StartedChallenge
    
    private var keyboardService: KeyboardAppearService?
    
    private var scrollBottomAnchor: NSLayoutConstraint?
    
    private weak var popupVC: UIViewController?
    
    private lazy var currentDate: Date = {
        Date()
    }()
    
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
    
    private lazy var periodLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = ColorThemeProvider.shared.infoBright
        label.font = FontsProvider.mediumAppFont(with: 14)
        label.text = CreateChallengeRegularityUtils.regularityToInfoString(model.originalChallenge.regularity)
        return label
    }()
    
    private lazy var intervalLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = ColorThemeProvider.shared.subtitle
        label.font = FontsProvider.regularAppFont(with: 12)
        
        var text: String = ""
        if let endDate = model.endDate {
            text = "\(Formatters.formateDateShort(model.startDate)) - \(Formatters.formateDateShort(endDate))"
        }
        else {
            text = Formatters.formateDateShort(model.startDate)
        }
        label.text = text
        return label
    }()
    
    private lazy var scrollContent: UIView = {
        let content = UIView()
        content.translatesAutoresizingMaskIntoConstraints = false
        content.backgroundColor = .clear
        
        content.addSubview(periodLabel)
        
        if hasSubtitle {
            content.addSubview(subtitleLabel)
            subtitleLabel.topAnchor.constraint(equalTo: content.topAnchor).isActive = true
            subtitleLabel.trailingAnchor.constraint(equalTo: content.trailingAnchor, constant: -18).isActive = true
            subtitleLabel.leadingAnchor.constraint(equalTo: content.leadingAnchor, constant: 130).isActive = true
            subtitleLabel.text = model.originalChallenge.subtitle
            
            periodLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 9).isActive = true
        }
        else {
            periodLabel.topAnchor.constraint(equalTo: content.topAnchor, constant: 9).isActive = true
        }
        
        periodLabel.leadingAnchor.constraint(equalTo: content.leadingAnchor, constant: 52).isActive = true
        periodLabel.trailingAnchor.constraint(lessThanOrEqualTo: content.trailingAnchor, constant: -52).isActive = true
        
        content.addSubview(intervalLabel)
        intervalLabel.leadingAnchor.constraint(equalTo: periodLabel.leadingAnchor).isActive = true
        intervalLabel.topAnchor.constraint(equalTo: periodLabel.bottomAnchor, constant: 4).isActive = true
        
        content.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: intervalLabel.bottomAnchor, constant: 14).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: content.leadingAnchor, constant: 52).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: content.trailingAnchor, constant: -52).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: calculatedCollectionHeight).isActive = true
        
        
        content.addSubview(textView)
        
        textView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 25).isActive = true
        textView.leadingAnchor.constraint(equalTo: content.leadingAnchor, constant: 52).isActive = true
        textView.trailingAnchor.constraint(equalTo: content.trailingAnchor, constant: -52).isActive = true
        textView.bottomAnchor.constraint(equalTo: content.bottomAnchor, constant: -10).isActive = true
        textView.heightAnchor.constraint(equalToConstant: 153).isActive = true
        
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
    
    private lazy var textView: TextViewWithPlaceholder = {
        let view = TextViewWithPlaceholder(placeholderData: .init(text: "ChallengeNotePlaceholder".localised(), color: ColorThemeProvider.shared.textNotes, font: FontsProvider.regularAppFont(with: 14)),
                                           proxyDelegate: self)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = ColorThemeProvider.shared.itemBackground
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 5
        view.set(text: model.note)
        return view
    }()
    
    private lazy var window: UIWindow? = {
        return navigationController?.view.window
    }()
    
    private var lastEditIndex: Int = -1
    
    private var onChangesToReload: (() -> Void)?
    
    init(model: StartedChallenge, onChangesToReload: (() -> Void)?) {
        self.model = model
        self.onChangesToReload = onChangesToReload
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(bannerADAvailabilityChanged), name: .bannerAdChanged, object: nil)
        
        navigationItem.title = model.originalChallenge.title
        navigationItem.rightBarButtonItem = infoButton
        
        view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        let scrollBottom = scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -OffsetsService.shared.bottomOffset)
        scrollBottom.isActive = true
        keyboardService = KeyboardAppearService(mainView: view, bottomConstraint: scrollBottom)
        scrollBottomAnchor = scrollBottom
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideInputViews))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        view.backgroundColor = .clear // TODO: remove blending
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: FontsProvider.regularAppFont(with: 20),
                                                                   .foregroundColor: ColorThemeProvider.shared.itemTextTitle]
    }
    
    @objc private func onInfo() {
        AppRouter.shared.toOpenChallengeInfo(model: model.originalChallenge)
    }
    
    @objc private func hideInputViews() {
        textView.resignFirstResponder()
    }
    
    @objc private func completeDay() {
        popupVC?.dismiss(animated: true)
        guard lastEditIndex >= 0 else { return }
        
        DatabaseService.shared.save(dayResult: .success,
                                    dayIndex: lastEditIndex,
                                    challengeID: model.identifier) { [weak self] success, updatedModel in
            guard success, let newModel = updatedModel else { return }
            self?.onChangesToReload?()
            DispatchQueue.main.async { [weak self] in
                self?.model = newModel
                self?.collectionView.reloadData()
            }
        }
        
        lastEditIndex = -1
    }
    
    @objc private func failDay() {
        popupVC?.dismiss(animated: true)
        guard lastEditIndex >= 0 else { return }
        
        DatabaseService.shared.save(dayResult: .fail,
                                    dayIndex: lastEditIndex,
                                    challengeID: model.identifier) { [weak self] success, updatedModel in
            guard success, let newModel = updatedModel else { return }
            self?.onChangesToReload?()
            DispatchQueue.main.async { [weak self] in
                self?.model = newModel
                self?.collectionView.reloadData()
            }
        }
        
        lastEditIndex = -1
    }
    
    @objc private func bannerADAvailabilityChanged() {
        scrollBottomAnchor?.constant = -OffsetsService.shared.bottomOffset
        view.layoutIfNeeded()
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
        let state = StartedChallengeUtils.state(for: model, index: indexPath.row, currentDate: currentDate)
        cell.set(state: state)
        
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        hideInputViews()
        
        let state = StartedChallengeUtils.state(for: model, index: indexPath.row, currentDate: currentDate)
        
        guard state != .completed && state != .failed else {
            // TODO: Premium
            return
        }
        
        if state != .disabled {
            lastEditIndex = indexPath.row
            let popupVC = PopupFactory.markChallengeDayPopup(target: self,
                                                             completeAction: #selector(completeDay),
                                                             failedAction: #selector(failDay))
            popupVC.modalPresentationStyle = .overFullScreen
            popupVC.modalTransitionStyle = .crossDissolve
            present(popupVC, animated: true)
            
            self.popupVC = popupVC
        }
        else if let nextDate = StartedChallengeUtils.closestNotAvailableDate(for: model, currentDate: currentDate) {
            let popupVC = PopupFactory.markChallengeDayWillBeEnable(at: nextDate)
            popupVC.modalPresentationStyle = .overFullScreen
            popupVC.modalTransitionStyle = .crossDissolve
            present(popupVC, animated: true)
        }
    }
}


extension StartedChallengeDetailsVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { [weak self] in
            guard let self else { return }
            self.scrollView.scrollRectToVisible(self.textView.frame, animated: true)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        guard self.textView.textData.text != model.note else { return }
        onChangesToReload?()
        DatabaseService.shared.save(note: self.textView.textData.text, for: model.identifier)
    }
}
