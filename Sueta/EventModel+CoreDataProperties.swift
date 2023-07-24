//
//  EventModel+CoreDataProperties.swift
//  
//
//  Created by Nail Minnemullin on 24.07.2023.
//
//

import Foundation
import CoreData


extension EventModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EventModel> {
        return NSFetchRequest<EventModel>(entityName: "EventModel")
    }

    @NSManaged public var title: String?
    @NSManaged public var id: String?

}
