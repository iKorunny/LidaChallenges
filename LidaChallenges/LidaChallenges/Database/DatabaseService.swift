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
    
    func fetchHasCustomChallenges(completion: @escaping (Bool) -> Void) {
        guard let context = context else { return }
        
        workingQueue.async {
            CustomChallengeDBService.shared.fetchCustomHasChallenges(context: context, completion: completion)
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
    
    func fetchAllStoredChallenges(onSuccess: @escaping (([Challenge]) -> Void)) {
        guard let context = context else { return }
        
        let group = DispatchGroup()
        
        var customChallenges: [Challenge] = []
        group.enter()
        workingQueue.async {
            CustomChallengeDBService.shared.fetchCustomChallenges(context: context) { dbModels in
                customChallenges = dbModels?.compactMap({ Challenge.create(from: $0) }) ?? []
                group.leave()
            }
        }
        
        var builtInChallenges: [Challenge] = []
        group.enter()
        workingQueue.async { [weak self] in
            let dbChallenges = self?.buildInDBService.syncFetchAllChallenges(context: context) ?? []
            builtInChallenges = dbChallenges.compactMap({ Challenge.create(from: $0) }).sorted(by: { $0.categoryID < $1.categoryID })
            group.leave()
        }
        
        group.notify(queue: .main) {
            onSuccess(builtInChallenges + customChallenges)
        }
    }
    
    func fetchRandomChallenge(onSuccess: @escaping ((Challenge?) -> Void)) {
        fetchAllStoredChallenges { challenges in
            guard !challenges.isEmpty else {
                onSuccess(nil)
                return
            }
            onSuccess(challenges.randomElement())
        }
    }
}


// MARK: StartedCHallenges
extension DatabaseService {
    func startChallenge(with id: String, isCustom: Bool, completion: @escaping ((StartedChallenge?) -> Void)) {
        guard let context = context else { return }
        
        workingQueue.async { [weak self] in
            if isCustom {
                CustomChallengeDBService.shared.fetchCustomChallenge(context: context,
                                                                     with: id) { [weak self] customChallenge in
                    guard let customChallenge,
                            let self,
                            let challengeId = customChallenge.identifier else { return }
                    self.workingQueue.async(flags: .barrier) { [weak self] in
                        self?.startedDBService.startChallenge(challengeIdentifier: challengeId,
                                                              isCustom: isCustom,
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
                let builtInChallenge = self?.buildInDBService.syncFetchChallenge(with: id, context: context)
                guard let builtInChallenge,
                        let self,
                        let challengeId = builtInChallenge.identifier else { return }
                self.workingQueue.async(flags: .barrier) { [weak self] in
                    self?.startedDBService.startChallenge(challengeIdentifier: challengeId,
                                                          isCustom: isCustom,
                                                          context: context,
                                                          completion: { dbModel in
                        guard let model = dbModel,
                              let modelId = model.identifier,
                              let modelStartDate = model.startDate,
                              let originalChallenge = Challenge.create(from: builtInChallenge) else {
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

            guard let context,
                  let modelId = model.identifier,
                  let modelStartDate = model.startDate,
                  let originalChallengeIdentifier = model.originalChallengeIdentifier else {
                return
            }
            
            var dayRecords: [ChallengeDayRecord] = []
            
            if let recordsData = model.dayRecords {
                dayRecords = (try? JSONDecoder().decode([ChallengeDayRecord].self, from: recordsData)) ?? []
            }
            
            var originalChallenge: Challenge
            if model.isCustomChallenge {
                guard let customChallenge = CustomChallengeDBService.shared.fetchCustomChallenge(context: context,
                                                                                           with: originalChallengeIdentifier),
                      let challenge = Challenge.create(from: customChallenge) else { return }
                originalChallenge = challenge
            }
            else {
                guard let builtInChallenge = buildInDBService.syncFetchChallenge(with: originalChallengeIdentifier, context: context),
                      let challenge = Challenge.create(from: builtInChallenge) else { return }
                originalChallenge = challenge
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
    
    func save(note: String?, for challengeID: String) {
        guard let context = context else { return }
        
        workingQueue.async { [weak self] in
            self?.startedDBService.fetchStartedChallenge(context: context,
                                                         with: challengeID,
                                                         onSuccess: { [weak self] foundChallenge in
                guard let foundChallenge else {
                    return
                }
                
                self?.workingQueue.async(flags: .barrier) {
                    self?.startedDBService.save(note: note,
                                                to: foundChallenge,
                                                context: context)
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
    
    func fetchAllBuiltInChallenges(with nameSubsctring: String,
                                   onSuccess: @escaping (([BuiltInChallenge]?) -> Void)) {
        guard let context = context else { return }
        
        workingQueue.async { [weak self] in
            let allNameKeys = BuiltInChallengesManager.shared.builtInChallengesNameKeys
            let filteredNameKeys = allNameKeys.filter({ $0.localised().lowercased().contains(nameSubsctring.lowercased()) })
            guard !filteredNameKeys.isEmpty else {
                onSuccess([])
                return
            }
            
            let dbModels = self?.buildInDBService.syncFetchChallenges(with: filteredNameKeys, context: context) ?? []
            onSuccess(dbModels.compactMap({ BuiltInChallenge.create(from: $0) }))
        }
    }
    
    func fetchBuiltInChallenge(with id: String, completion: @escaping (BuiltInChallenge?) -> Void) {
        guard let context = context else { return }
        
        workingQueue.async { [weak self] in
            guard !id.isEmpty else {
                completion(nil)
                return
            }
            
            guard let dbModel = self?.buildInDBService.syncFetchChallenge(with: id, context: context) else {
                completion(nil)
                return
            }
            
            let model = BuiltInChallenge.create(from: dbModel)
            completion(model)
        }
    }
}

