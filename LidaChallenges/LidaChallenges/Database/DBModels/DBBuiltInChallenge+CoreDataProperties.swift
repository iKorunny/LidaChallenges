//
//  DBBuiltInChallenge+CoreDataProperties.swift
//  LidaChallenges
//
//  Created by Ihar Karunny on 10/24/24.
//
//

import Foundation
import CoreData


extension DBBuiltInChallenge {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DBBuiltInChallenge> {
        return NSFetchRequest<DBBuiltInChallenge>(entityName: "DBBuiltInChallenge")
    }

    @NSManaged public var daysCount: Int64
    @NSManaged public var descriptionKey: String?
    @NSManaged public var iconName: String?
    @NSManaged public var identifier: String?
    @NSManaged public var nameKey: String?
    @NSManaged public var regularity: NSObject?
    @NSManaged public var subtitleKey: String?
    @NSManaged public var categoryID: Int16

}

extension DBBuiltInChallenge : Identifiable {

}
