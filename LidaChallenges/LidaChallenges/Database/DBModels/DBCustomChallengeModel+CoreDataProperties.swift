//
//  DBCustomChallengeModel+CoreDataProperties.swift
//  LidaChallenges
//
//  Created by Ihar Karunny on 8/24/24.
//
//

import Foundation
import CoreData


extension DBCustomChallengeModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DBCustomChallengeModel> {
        return NSFetchRequest<DBCustomChallengeModel>(entityName: "DBCustomChallengeModel")
    }

    @NSManaged public var name: String?
    @NSManaged public var daysCount: Int64
    @NSManaged public var regularity: NSObject?
    @NSManaged public var icon: Data?
    @NSManaged public var descriptionString: String?
    @NSManaged public var identifier: String?

}

extension DBCustomChallengeModel : Identifiable {

}
