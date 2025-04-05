//
//  ChallengesListVC.swift
//  LidaChallenges
//
//  Created by Ihar Karunny on 10/25/24.
//

import Foundation
import UIKit

final class ChallengesListVC: BaseBackgroundedViewController {
    private struct Constants {
        static let headerId = "ChallengesSearchResultHeaderView"
        static let cellId = "ChallengesListCell"
        static let fakeCellId = "ChallengesFakeCell"
    }
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.backgroundColor = .clear
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        
        table.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 350, right: 0)
        
        table.register(ChallengesSearchResultHeaderView.self, forHeaderFooterViewReuseIdentifier: Constants.headerId)
        table.register(ChallengesListCell.self, forCellReuseIdentifier: Constants.cellId)
        table.register(ChallengesFakeCell.self, forCellReuseIdentifier: Constants.fakeCellId)
        table.backgroundView = nil
        
        table.separatorStyle = .none
        table.sectionFooterHeight = CGFloat.leastNormalMagnitude
        table.sectionHeaderTopPadding = 1.0
        
        table.estimatedRowHeight = 16.0
        
        return table
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private var tableSections: [ChallengesSearchResultSection] = []
    
    private var didDBRequest = false
    var categoryID: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18).isActive = true
        
        view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !didDBRequest {
            requestData()
            didDBRequest = true
        }
    }
    
    private func requestData() {
        activityIndicator.startAnimating()
        tableView.isUserInteractionEnabled = false
        DatabaseService.shared.fetchAllStoredChallenges { [weak self] challenges in
            var calculatedSections: [ChallengesSearchResultSection] = []
            var categoryIds: Set<Int> = []
            
            challenges.forEach {
                categoryIds.insert($0.categoryID)
            }
            let categories = CategoriesSourceImpl().categories(with: Array(categoryIds))
            
            categories.forEach { category in
                calculatedSections.append(ChallengesSearchResultSection(title: category.title,
                                                                        rows: challenges.filter({ $0.categoryID == category.id }).compactMap({ ChallengesSearchResultRow(model: $0) })))
            }
            
            let customChallenges: [Challenge] = challenges.filter({ $0.isCustom })
            if !customChallenges.isEmpty {
                calculatedSections.append(.init(title: "CustomChallengeSectionTitle".localised(),
                                      rows: customChallenges.compactMap({ ChallengesSearchResultRow(model: $0) })))
            }
            
            
            self?.activityIndicator.stopAnimating()
            self?.tableView.isUserInteractionEnabled = true
            
            self?.tableSections = calculatedSections
            self?.tableView.reloadData()
            
            guard let focusSectionIndex = calculatedSections.firstIndex(where: { $0.rows.first?.model.categoryID == self?.categoryID }) else { return }
            self?.tableView.scrollToRow(at: IndexPath(row: 0, section: focusSectionIndex), at: .top, animated: false)
        }
    }
}

extension ChallengesListVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableSections[section].rows.count * 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let notFakeCell = isNotFakeCellIndex(row: indexPath.row)
        
        if notFakeCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellId, for: indexPath) as? ChallengesListCell else { return UITableViewCell() }
            
            cell.setupIfNeeded()
            let modelIndex = getModelIndex(rowIndex: indexPath.row)
            cell.titleLabel.text = tableSections[indexPath.section].rows[modelIndex].title
            
            return cell
        }
        else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.fakeCellId, for: indexPath) as? ChallengesFakeCell else { return UITableViewCell() }
            cell.setup()
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: Constants.headerId) as? ChallengesSearchResultHeaderView else { return nil }
        header.setupIfNeeded()
        header.titleLabel.text = tableSections[section].title
        return header
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard isNotFakeCellIndex(row: indexPath.row) else { return }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let modelIndex = getModelIndex(rowIndex: indexPath.row)
        let model = tableSections[indexPath.section].rows[modelIndex].model
        AppRouter.shared.toOpenChallenge(model: model)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return isCustomSection(with: indexPath.section) && isNotFakeCellIndex(row: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let section = tableSections[indexPath.section]
        let removed = section.rows.remove(at: getModelIndex(rowIndex: indexPath.row))
        if section.rows.isEmpty {
            tableSections.remove(at: indexPath.section)
            tableView.deleteSections([indexPath.section], with: .automatic)
        }
        else {
            let attachedFakeIndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
            tableView.deleteRows(at: [indexPath, attachedFakeIndexPath], with: .automatic)
        }
        
        DatabaseService.shared.deleteStartedChallenges(with: removed.model.identifier) { _ in
            AppDelegate.shared.appNotificationManager.resetNotifications()
        }
        DatabaseService.shared.deleteCustomChallenge(with: removed.model.identifier)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard isNotFakeCellIndex(row: indexPath.row) else {
            return 16
        }
        
        return UITableView.automaticDimension
    }
    
    private func isCustomSection(with index: Int) -> Bool {
        return tableSections[index].isCustom
    }
    
    private func isNotFakeCellIndex(row: Int) -> Bool {
        return row % 2 == 0
    }
    
    private func getModelIndex(rowIndex: Int) -> Int {
        return Int(floor(CGFloat(rowIndex) / 2.0))
    }
}
