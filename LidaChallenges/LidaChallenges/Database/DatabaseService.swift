//
//  DatabaseService.swift
//  LidaChallenges
//
//  Created by Ihar Karunny on 8/24/24.
//

import Foundation
import CoreData
import UIKit

final class DatabaseService {
    static let shared = DatabaseService()
    
    private let startedDBService = StartedChallengeDBService()
    
    private lazy var workingQueue: DispatchQueue = {
        return DispatchQueue(label: "DatabaseServiceQueue", qos: .userInitiated, attributes: .concurrent)
    }()
    
    var context: NSManagedObjectContext?
    
    func createCustomChallenge(name: String,
                               daysCount: Int,
                               selectedRegularity: Set<ChallengeRegularityType>,
                               icon: UIImage?,
                               description: String?,
                               completion: @escaping ((CustomChallenge?) -> Void)) {
        guard let context = context else {
            completion(nil)
            return
        }
        workingQueue.async(flags: .barrier) {
            CustomChallengeDBService.shared.createCustomChallenge(name: name,
                                                                  daysCount: daysCount,
                                                                  selectedRegularity: selectedRegularity,
                                                                  icon: icon,
                                                                  description: description,
                                                                  context: context) { dbModel in
                guard let model = dbModel else {
                    completion(nil)
                    return
                }
                completion(CustomChallenge.create(from: model))
            }
        }
    }
    
    func fetchCustomChallenges(onSuccess: @escaping (([CustomChallenge]?) -> Void)) {
        guard let context = context else { return }
        
        workingQueue.async {
            CustomChallengeDBService.shared.fetchCustomChallenges(context: context) { dbModels in
                onSuccess(dbModels?.compactMap({ CustomChallenge.create(from: $0) }))
            }
        }
    }
    
    func deleteAllCustomChallenges() {
        guard let context = context else { return }
        
        workingQueue.async(flags: .barrier) {
            CustomChallengeDBService.shared.deleteAllCustomChallenges(context: context)
        }
    }
    
    func fetchCustomChallenges(with nameSubstring: String, onSuccess: @escaping (([CustomChallenge]?) -> Void)) {
        guard let context = context else { return }
        
        workingQueue.async {
            CustomChallengeDBService.shared.fetchCustomChallenges(with: nameSubstring,
                                                                  context: context) { dbModels in
                onSuccess(dbModels?.compactMap({ CustomChallenge.create(from: $0) }))
            }
        }
    }
}


// MARK: StartedCHallenges
extension DatabaseService {
    func startChallenge(with id: String, isCustom: Bool, completion: ((StartedChallenge) -> Void)) {
        
    }
}
