//
//  CustomChallengeDBService.swift
//  LidaChallenges
//
//  Created by Ihar Karunny on 8/24/24.
//

import Foundation
import CoreData
import UIKit

final class CustomChallengeDBService {
    static let shared = CustomChallengeDBService()
    
    func createCustomChallenge(name: String,
                               daysCount: Int,
                               selectedRegularity: Set<CreateChallengeRegularityType>,
                               icon: UIImage?,
                               description: String?,
                               context: NSManagedObjectContext,
                               completion: @escaping ((DBCustomChallengeModel?) -> Void)) {
        let newCustomChallenge = DBCustomChallengeModel(context: context)
        let identifier = "CustomChallenge_\(UUID().uuidString)"
        newCustomChallenge.identifier = identifier
        newCustomChallenge.name = name
        newCustomChallenge.daysCount = Int64(daysCount)
        newCustomChallenge.regularity = (Array(selectedRegularity).map({ $0.rawValue })) as NSObject
        newCustomChallenge.icon = icon?.pngData()
        newCustomChallenge.descriptionString = description
        
        do {
            try context.save()
            fetchCustomChallenge(context: context,
                                 with: identifier,
                                 onSuccess: completion)
        }
        catch let error {
            print("createCustomChallenge: \(error)")
        }
    }
    
    func fetchCustomChallenges(context: NSManagedObjectContext,
                               onSuccess: @escaping (([DBCustomChallengeModel]?) -> Void)) {
        do {
            let request = DBCustomChallengeModel.fetchRequest()
            let models = try context.fetch(request)
            onSuccess(models)
        }
        catch let error {
            print("fetchCustomChallenges: \(error)")
        }
    }
    
    func fetchCustomChallenge(context: NSManagedObjectContext,
                              with id: String,
                              onSuccess: @escaping ((DBCustomChallengeModel?) -> Void)) {
        do {
            let request = DBCustomChallengeModel.fetchRequest()
            request.predicate = NSPredicate(format: "identifier == %@", id)
            let models = try context.fetch(request)
            onSuccess(models.first)
        }
        catch let error {
            print("fetchCustomChallenge with id: \(error)")
        }
    }
    
    func deleteAllCustomChallenges(context: NSManagedObjectContext) {
        fetchCustomChallenges(context: context) { dbModels in
            for model in (dbModels ?? []) {
                context.delete(model)
            }
        }
    }
}