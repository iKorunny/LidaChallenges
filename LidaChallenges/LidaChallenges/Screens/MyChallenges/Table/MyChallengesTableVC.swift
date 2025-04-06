//
//  MyChallengesTableVC.swift
//  LidaChallenges
//
//  Created by Лидия on 6.04.25.
//

import UIKit

private struct Constants {
    static let headerID = "MyChallengesTableHeaderView"
    static let cellID = "MyChallengesListCell"
    static let fakeCellID = "MyChallengesFakeCell"
}

final class MyChallengesTableVC: BaseBackgroundedViewController {
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private var contentBottomConstraint: NSLayoutConstraint?
    
    private lazy var window: UIWindow? = {
        return navigationController?.view.window
    }()
    
    private var state: MyChallengesVCState = .noData {
        didSet {
            guard oldValue != state else { return }
            stateChanged(newState: state)
        }
    }
    
    private var sections: [MyChallengesSection] = []
    
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
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.backgroundColor = .clear
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        
        table.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 350, right: 0)
        
        table.register(MyChallengesTableHeaderView.self, forHeaderFooterViewReuseIdentifier: Constants.headerID)
        table.register(MyChallengesListCell.self, forCellReuseIdentifier: Constants.cellID)
        table.register(MyChallengesFakeCell.self, forCellReuseIdentifier: Constants.fakeCellID)
        table.backgroundView = nil
        
        table.separatorStyle = .none
        table.sectionFooterHeight = CGFloat.leastNormalMagnitude
        table.sectionHeaderTopPadding = 1.0
        
        return table
    }()
    
    var mode: MyChallengesVCMode = .all
    var screenTitle: String?
    private var shouldReloadData = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(bannerADAvailabilityChanged), name: .bannerAdChanged, object: nil)

        view.backgroundColor = .clear
        navigationItem.title = screenTitle ?? "MyChallengesLargeButtonTitle".localised()
        view.addSubview(noDataLabel)
        noDataLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        noDataLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18).isActive = true
        contentBottomConstraint = tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -OffsetsService.shared.bottomOffset)
        contentBottomConstraint?.isActive = true
        
        stateChanged(newState: state)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: FontsProvider.regularAppFont(with: 20),
                                                                   .foregroundColor: ColorThemeProvider.shared.itemTextTitle]
        
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
                    self?.updateState()
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
            tableView.isHidden = false
        case .noData:
            noDataLabel.isHidden = false
            tableView.isHidden = true
        }
        
        tableView.reloadData()
    }
    
    @objc private func bannerADAvailabilityChanged() {
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: OffsetsService.shared.bottomOffset, right: 0)
        contentBottomConstraint?.constant = -OffsetsService.shared.bottomOffset
        view.layoutIfNeeded()
    }
    
    private func updateState() {
        state = sections.isEmpty ? .noData : .hasData
    }
}

extension MyChallengesTableVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.filter({ !$0.challenges.isEmpty }).count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].challenges.count * 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let notFakeCell = isNotFakeCellIndex(row: indexPath.row)
        
        if notFakeCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellID, for: indexPath) as? MyChallengesListCell else { return UITableViewCell() }
            
            let modelIndex = getModelIndex(rowIndex: indexPath.row)
            
            cell.fill(with: sections[indexPath.section].challenges[modelIndex])
            
            return cell
        }
        else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.fakeCellID, for: indexPath) as? MyChallengesFakeCell else { return UITableViewCell() }
            cell.setup()
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: Constants.headerID) as? MyChallengesTableHeaderView else { return nil }
        header.setupIfNeeded()
        header.titleLabel.text = sections[section].title
        return header
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard isNotFakeCellIndex(row: indexPath.row) else { return }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let modelIndex = getModelIndex(rowIndex: indexPath.row)
        let model = sections[indexPath.section].challenges[modelIndex]
        AppRouter.shared.toStartedChallenge(model: model) { [weak self] in
            self?.shouldReloadData = true
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return isNotFakeCellIndex(row: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let section = sections[indexPath.section]
        let removed = section.challenges.remove(at: getModelIndex(rowIndex: indexPath.row))
        if section.challenges.isEmpty {
            sections.remove(at: indexPath.section)
            tableView.deleteSections([indexPath.section], with: .automatic)
            if sections.isEmpty {
                updateState()
            }
        }
        else {
            let attachedFakeIndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
            tableView.deleteRows(at: [indexPath, attachedFakeIndexPath], with: .automatic)
        }
        
        DatabaseService.shared.deleteStartedChallenges(identifier: removed.identifier) { deleted in
            guard deleted else { return }
            AppDelegate.shared.appNotificationManager.resetNotifications()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard isNotFakeCellIndex(row: indexPath.row) else {
            return 14
        }
        
        return 42
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    private func isNotFakeCellIndex(row: Int) -> Bool {
        return row % 2 == 0
    }
    
    private func getModelIndex(rowIndex: Int) -> Int {
        return Int(floor(CGFloat(rowIndex) / 2.0))
    }
}
