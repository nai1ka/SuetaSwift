//
//  MainViewModel.swift
//  Sueta
//
//  Created by Nail Minnemullin on 12.07.2023.
//

import Foundation
import Bond
import FirebaseFirestore


class MainViewModel{
    
    let events = Observable<[Event]>([])
    let error = Observable<Error?>(nil)
    let db = Firestore.firestore()
    var newEvent: Event?
   
    
    func fetchEvents(){
        db.collection("core").document("events").collection("list").getDocuments { [weak self](querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                var newEvents: [Event] = []
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let title = data["eventName"] as? String ?? ""
                    let description = data["eventDescription"] as? String ?? ""
                    let ownerID = data["owner"] as? String ?? ""
                    let date = data["eventDate"] as? Date ?? Date()
                   
                    if let rawPosition = (data["eventPosition"] as? [String:Any]), let position = rawPosition["geopoint"] as? GeoPoint{
                        newEvents.append(Event(title: title, description: description, ownerID: ownerID, date: date, position: position))
                    }
                }
                self?.events.value = newEvents
            }
        }
    }
    
}
