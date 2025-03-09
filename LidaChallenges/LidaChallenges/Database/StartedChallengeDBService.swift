//
//  StartedChallengeDBService.swift
//  LidaChallenges
//
//  Created by Ihar Karunny on 9/1/24.
//

import Foundation
import CoreData

final class StartedChallengeDBService {
    func startChallenge(challengeIdentifier: String,
                        isCustom: Bool,
                        context: NSManagedObjectContext,
                        completion: @escaping ((DBStartedChallengeModel?) -> Void)) {
        let newStartedChallenge = DBStartedChallengeModel(context: context)
        let identifier = "StartedChallenge_\(challengeIdentifier)_\(Formatters.formateDateTimeLong(Date()))"
        newStartedChallenge.identifier = identifier
        newStartedChallenge.originalChallengeIdentifier = challengeIdentifier
        newStartedChallenge.isCustomChallenge = isCustom
        newStartedChallenge.startDate = Date()
        
        do {
            try context.save()
            fetchStartedChallenge(context: context,
                                  with: identifier,
                                  onSuccess: completion)
        }
        catch let error {
            print("startChallenge: \(error)")
        }
    }
    
    func fetchStartedChallenge(context: NSManagedObjectContext,
                               with id: String,
                               onSuccess: @escaping ((DBStartedChallengeModel?) -> Void)) {
        do {
            let request = DBStartedChallengeModel.fetchRequest()
            request.predicate = NSPredicate(format: "identifier == %@", id)
            let models = try context.fetch(request)
            onSuccess(models.first)
        }
        catch let error {
            print("fetchStartedChallenges with id: \(error)")
        }
    }
    
    func fetchAllStartedChallenges(context: NSManagedObjectContext,
                                   onSuccess: @escaping (([DBStartedChallengeModel]?) -> Void)) {
        do {
            let request = DBStartedChallengeModel.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "startDate", ascending: false)]
            let models = try context.fetch(request)
            onSuccess(models)
        }
        catch let error {
            print("fetchAllStartedChallenges: \(error)")
        }
    }
    
    func deleteAllStartedChallenges(context: NSManagedObjectContext) {
        fetchAllStartedChallenges(context: context) { dbModels in
            for model in (dbModels ?? []) {
                context.delete(model)
            }
        }
    }
    
    func save(dayResult: ChallengeDayRecordResult,
              dayIndex: Int,
              to challenge: DBStartedChallengeModel,
              context: NSManagedObjectContext,
              completion: @escaping ((DBStartedChallengeModel?) -> Void)) {
        
        var records: [ChallengeDayRecord] = challenge.dayRecords != nil ?
        ((try? JSONDecoder().decode([ChallengeDayRecord].self, from: challenge.dayRecords!)) ?? [])
        : []
        if let storedDay = records.first(where: { $0.dayIndex == dayIndex }) {
            storedDay.result = dayResult
        }
        else {
            records.append(.init(dayIndex: dayIndex, result: dayResult))
        }
        challenge.dayRecords = try! JSONEncoder().encode(records)
        
        do {
            try context.save()
            fetchStartedChallenge(context: context,
                                  with: challenge.identifier!,
                                  onSuccess: completion)
        }
        catch let error {
            print("save(dayResult: \(error)")
        }
    }
    
    func save(note: String?,
              to challenge: DBStartedChallengeModel,
              context: NSManagedObjectContext) {
        
        challenge.note = note
        
        do {
            try context.save()
        }
        catch let error {
            print("save(note: \(error)")
        }
    }
}
