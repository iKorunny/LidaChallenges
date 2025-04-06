//
//  ChallengesSearchResultController.swift
//  LidaChallenges
//
//  Created by Ihar Karunny on 8/25/24.
//

import UIKit

final class ChallengesSearchResultController: BaseBackgroundedViewController {
    
    private struct Constants {
        static let headerId = "ChallengesSearchResultHeaderView"
        static let cellId = "ChallengesSearchResultCell"
    }
    
    private lazy var searchService: ChallengesSearchService = {
        ChallengesSearchService()
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.backgroundColor = .clear
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        
        table.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 350, right: 0)
        
        table.register(ChallengesSearchResultHeaderView.self, forHeaderFooterViewReuseIdentifier: Constants.headerId)
        table.register(ChallengesSearchResultCell.self, forCellReuseIdentifier: Constants.cellId)
        table.backgroundView = nil
        
        table.separatorStyle = .none
        table.sectionFooterHeight = CGFloat.leastNormalMagnitude
        table.sectionHeaderTopPadding = 1.0
        
        return table
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private var tableSections: [ChallengesSearchResultSection] = [] {
        didSet {
            tableView.reloadData()
        }
    }

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
}

extension ChallengesSearchResultController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        activityIndicator.startAnimating()
        tableView.isUserInteractionEnabled = false
        searchService.search(with: searchController.searchBar.text ?? "") { [weak self] sections in
            self?.activityIndicator.stopAnimating()
            self?.tableView.isUserInteractionEnabled = true
            
            self?.tableSections = sections
        }
    }
}

extension ChallengesSearchResultController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableSections[section].rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellId, for: indexPath) as? ChallengesSearchResultCell else { return UITableViewCell() }
        
        cell.setupIfNeeded()
        cell.titleLabel.text = tableSections[indexPath.section].rows[indexPath.row].title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: Constants.headerId) as? ChallengesSearchResultHeaderView else { return nil }
        header.setupIfNeeded()
        header.titleLabel.text = tableSections[section].title
        return header
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let model = tableSections[indexPath.section].rows[indexPath.row].model
        AppRouter.shared.toOpenChallenge(model: model)
    }
}
