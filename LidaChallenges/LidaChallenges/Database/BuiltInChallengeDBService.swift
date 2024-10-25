//
//  BuiltInChallengeDBService.swift
//  LidaChallenges
//
//  Created by Ihar Karunny on 10/24/24.
//

import Foundation
import CoreData

final class BuiltInChallengeDBService {
    static let shared = BuiltInChallengeDBService()
    
    func saveChallenge(id: String,
                       daysCount: Int,
                       descriptionKey: String?,
                       iconName: String?,
                       nameKey: String,
                       regularity: [Int],
                       subtitleKey: String?,
                       categoryID: Int,
                       context: NSManagedObjectContext,
                       completion: @escaping (() -> Void)) {
        let challenge = syncFetchChallenge(with: id, context: context) ?? DBBuiltInChallenge(context: context)
        challenge.identifier = id
        challenge.daysCount = Int64(daysCount)
        challenge.descriptionKey = descriptionKey
        challenge.iconName = iconName
        challenge.nameKey = nameKey
        challenge.regularity = regularity as NSObject
        challenge.subtitleKey = subtitleKey
        challenge.categoryID = Int16(categoryID)
        
        do {
            try context.save()
            completion()
        }
        catch let error {
            print("saveChallenge: \(error)")
        }
    }
    
    func syncFetchChallenge(with id: String, context: NSManagedObjectContext) -> DBBuiltInChallenge? {
        do {
            let request = DBBuiltInChallenge.fetchRequest()
            request.predicate = NSPredicate(format: "identifier == %@", id)
            let models = try context.fetch(request)
            return models.first
        }
        catch let error {
            print("syncFetchChallenge: \(error)")
        }
        return nil
    }
    
    func syncFetchChallenges(with nameKeys: [String],
                             context: NSManagedObjectContext) -> [DBBuiltInChallenge] {
        do {
            let request = DBBuiltInChallenge.fetchRequest()
            request.predicate = NSPredicate(format: "%K IN %@", #keyPath(DBBuiltInChallenge.nameKey), nameKeys)
            let models = try context.fetch(request)
            return models
        }
        catch let error {
            print("syncFetchChallengesWithNameKeys: \(error)")
        }
        return []
    }
    
    func syncFetchAllChallenges(context: NSManagedObjectContext) -> [DBBuiltInChallenge] {
        do {
            let request = DBBuiltInChallenge.fetchRequest()
            let models = try context.fetch(request)
            return models
        }
        catch let error {
            print("syncFetchAllChallenges: \(error)")
        }
        return []
    }
}
