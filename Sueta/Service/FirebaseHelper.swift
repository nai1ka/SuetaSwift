//
//  FirebaseHelper.swift
//  Sueta
//
//  Created by Nail Minnemullin on 13.07.2023.
//

import Foundation
import FirebaseFirestore

class FirebaseHelper {
    static let shared = FirebaseHelper()
    let db = Firestore.firestore()

    private init() {}

    func addEvent(_ event: Event) {
        db.collection("core").document("events").collection("list").addDocument(data: [
            "eventDate": event.date,
            "eventDescription": event.description,
            "eventName": event.title,
            "eventOwner": event.ownerID,
            "eventPosition": event.position,
            "peopleNumber": event.peopleNumber
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    func readEvents(completion: @escaping (_ events: [Event]) -> Void){
        db.collection("core").document("events").collection("list").getDocuments {(querySnapshot, err) in
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
                           let peopleNumber = data["peopleNumber"] as? Int ?? 0
                          
                           if let position = data["eventPosition"] as? GeoPoint {
                               newEvents.append(Event(title: title, description: description, peopleNumber: peopleNumber, ownerID: ownerID, date: date, position: position))
                           }
                       }
                       completion(newEvents)
                   }
               }
        
    }
}

