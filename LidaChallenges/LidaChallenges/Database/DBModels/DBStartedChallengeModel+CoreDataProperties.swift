//
//  DBStartedChallengeModel+CoreDataProperties.swift
//  LidaChallenges
//
//  Created by Ihar Karunny on 9/1/24.
//
//

import Foundation
import CoreData


extension DBStartedChallengeModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DBStartedChallengeModel> {
        return NSFetchRequest<DBStartedChallengeModel>(entityName: "DBStartedChallengeModel")
    }

    @NSManaged public var note: String?
    @NSManaged public var identifier: String?
    @NSManaged public var startDate: Date?
    @NSManaged public var isCustomChallenge: Bool
    @NSManaged public var originalChallengeIdentifier: String?
    @NSManaged public var dayRecords: Data?

}

extension DBStartedChallengeModel : Identifiable {

}
