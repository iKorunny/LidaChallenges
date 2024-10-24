//
//  DatabaseService.swift
//  LidaChallenges
//
//  Created by Ihar Karunny on 8/24/24.
//

import Foundation
import CoreData
import UIKit

protocol BuiltInChallengesDatabase {
    func saveBuiltIn(challenges: [BuiltInChallengeConfig], completion: @escaping ((Bool) -> Void))
}

final class DatabaseService {
    static let shared = DatabaseService()
    
    private let startedDBService = StartedChallengeDBService()
    private let buildInDBService = BuiltInChallengeDBService()
    
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
    func startChallenge(with id: String, isCustom: Bool, completion: @escaping ((StartedChallenge?) -> Void)) {
        guard let context = context else { return }
        
        workingQueue.async {
            if isCustom {
                CustomChallengeDBService.shared.fetchCustomChallenge(context: context,
                                                                     with: id) { [weak self] customChallenge in
                    guard let customChallenge,
                            let self,
                            let challengeId = customChallenge.identifier else { return }
                    self.workingQueue.async(flags: .barrier) { [weak self] in
                        self?.startedDBService.startChallenge(challengeIdentifier: challengeId,
                                                              isCustom: true,
                                                              context: context,
                                                              completion: { dbModel in
                            guard let model = dbModel,
                                  let modelId = model.identifier,
                                  let modelStartDate = model.startDate,
                                  let originalChallenge = Challenge.create(from: customChallenge) else {
                                completion(nil)
                                return
                            }
                            
                            completion(StartedChallenge(identifier: modelId, 
                                                        startDate: modelStartDate,
                                                        isCustomChallenge: model.isCustomChallenge, originalChallenge: originalChallenge,
                                                        dayRecords: [], 
                                                        note: nil))
                        })
                    }
                }
            }
            else {
                //TODO: implement later
            }
        }
    }
    
    func deleteAllStartedChallenges() {
        guard let context = context else { return }
        
        workingQueue.async(flags: .barrier) { [weak self] in
            self?.startedDBService.deleteAllStartedChallenges(context: context)
        }
    }
    
    func fetchAllStartedChallenges(onSuccess: @escaping (([StartedChallenge]?) -> Void)) {
        guard let context = context else { return }
        
        workingQueue.async { [weak self] in
            self?.startedDBService.fetchAllStartedChallenges(context: context, onSuccess: { [weak self] dbModels in
            
                onSuccess(self?.startedDbModelsToModels(dbModels: dbModels))
            })
        }
    }
    
    private func startedDbModelsToModels(dbModels: [DBStartedChallengeModel]?) -> [StartedChallenge]? {
        guard let dbModels else { return nil }
        
        var result: [StartedChallenge] = []
        
        dbModels.forEach { model in
            // TODO: implement later for not custom
            guard let context,
                  let modelId = model.identifier,
                  let modelStartDate = model.startDate,
                  let originalChallengeIdentifier = model.originalChallengeIdentifier,
                  let customChallenge = CustomChallengeDBService.shared.fetchCustomChallenge(context: context,
                                                                                             with: originalChallengeIdentifier),
                  let originalChallenge = Challenge.create(from: customChallenge) else {
                return
            }
            
            var dayRecords: [ChallengeDayRecord] = []
            
            if let recordsData = model.dayRecords {
                dayRecords = (try? JSONDecoder().decode([ChallengeDayRecord].self, from: recordsData)) ?? []
            }
            
            result.append(StartedChallenge(identifier: modelId,
                                           startDate: modelStartDate,
                                           isCustomChallenge: model.isCustomChallenge,
                                           originalChallenge: originalChallenge,
                                           dayRecords: dayRecords,
                                           note: model.note)) // TODO: implement later
        }
        
        return result
    }
    
    func save(dayResult: ChallengeDayRecordResult,
              dayIndex: Int,
              challengeID: String,
              completion: @escaping ((Bool, StartedChallenge?) -> Void)) {
        guard let context = context else { return }
        
        workingQueue.async { [weak self] in
            self?.startedDBService.fetchStartedChallenge(context: context,
                                                         with: challengeID,
                                                         onSuccess: { [weak self] foundChallenge in
                guard let foundChallenge else {
                    completion(false, nil)
                    return
                }
                
                self?.workingQueue.async(flags: .barrier) {
                    self?.startedDBService.save(dayResult: dayResult,
                                                dayIndex: dayIndex,
                                                to: foundChallenge,
                                                context: context,
                                                completion: { [weak self] updatedDBModel in
                        guard let updatedDBModel else {
                            completion(false, nil)
                            return
                        }
                        
                        completion(true, self?.startedDbModelsToModels(dbModels: [updatedDBModel])?.first)
                    })
                }
            })
        }
    }
}

extension DatabaseService: BuiltInChallengesDatabase {
    func saveBuiltIn(challenges: [BuiltInChallengeConfig], completion: @escaping ((Bool) -> Void)) {
        guard let context = context else {
            completion(false)
            return
        }
        workingQueue.async(flags: .barrier) { [weak self] in
            let group: DispatchGroup = .init()
            challenges.forEach { _ in
//                print("group.enter()")
                group.enter()
            }
            
            challenges.forEach { challenge in
                self?.buildInDBService.saveChallenge(id: challenge.identifier,
                                                     daysCount: challenge.daysCount,
                                                     descriptionKey: challenge.descriptionKey,
                                                     iconName: challenge.iconName,
                                                     nameKey: challenge.nameKey,
                                                     regularity: challenge.regularity,
                                                     subtitleKey: challenge.subtitleKey,
                                                     categoryID: challenge.categoryID,
                                                     context: context,
                                                     completion: {
                    group.leave()
//                    print("group.leave()")
                })
            }
            
            group.notify(queue: .main) {
                completion(true)
            }
        }
    }
}
