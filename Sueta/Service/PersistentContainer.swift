//
//  PersistentContainer.swift
//  Sueta
//
//  Created by Nail Minnemullin on 24.07.2023.
//

import Foundation

import CoreData
import FirebaseFirestore

class PersistentContainer {
    // MARK: - Singleton Instance
    static let shared = PersistentContainer()

    // MARK: - Core Data stack
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchAllEvents(completion: @escaping (_ events: [Event]) -> Void) {
        let context = context
        let fetchRequest: NSFetchRequest<EventModel> = EventModel.fetchRequest()

        do {
            let events = try context.fetch(fetchRequest)
            var resultArray: [Event] = []
            for rawEvent in events{
                resultArray.append(Event(id: rawEvent.id, title: rawEvent.title ?? "", description: rawEvent.eventDescription ?? "", peopleNumber: Int(rawEvent.peopleNumber ?? 0), ownerID: "", date: rawEvent.date ?? Date(), position: GeoPoint(latitude: rawEvent.latitude, longitude: rawEvent.longitude)))
            }
            completion(resultArray)
        } catch {
            print("Error fetching events: \(error)")
            
        }
    }
    func save(events: [Event]){
        for event in events{
            save(event: event)
        }
    }
    func save(event: Event) {
        guard let eventID = event.id else{
            return
        }

            // Check if an event with the same id already exists
            let fetchRequest: NSFetchRequest<EventModel> = EventModel.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", eventID)

            do {
                let existingEvents = try context.fetch(fetchRequest)

                if let existingEvent = existingEvents.first {
                    print("Such event exists")
                } else {
                    // Save a new event
                    let newEvent = EventModel(context: context)
                    newEvent.title = event.title
                    newEvent.id = eventID
                    newEvent.peopleNumber = Int32(event.peopleNumber)
                    newEvent.date = event.date
                    newEvent.longitude = event.position.longitude
                    newEvent.latitude = event.position.latitude

                    print("New event saved successfully!")
                }

                try context.save()
            } catch {
                print("Error saving event: \(error)")
            }
    }

    // MARK: - Accessing the Managed Object Context
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
}
