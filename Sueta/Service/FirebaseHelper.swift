//
//  FirebaseHelper.swift
//  Sueta
//
//  Created by Nail Minnemullin on 13.07.2023.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class FirebaseHelper {
    static let shared = FirebaseHelper()
    let db = Firestore.firestore()
    
    
    private init() {}
    
    func addEvent(_ event: Event) {
        guard let user = getCurrentUser() else{
            return
        }
        let ref = db.collection("core").document("events").collection("list").addDocument(data: [
            "eventDate": event.date,
            "eventDescription": event.description,
            "eventName": event.title,
            "eventOwner": event.ownerID,
            "eventPosition": event.position,
            "peopleNumber": event.peopleNumber,
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
        
        db.collection("core").document("users").collection("list").document(user.uid).updateData(["hostedEvents" : FieldValue.arrayUnion([ref.documentID])]) { err in
            if let err = err{
                print("\(err)")
            }
        }
    }
    
    
    
    func registerUser(){
        guard let user = getCurrentUser() else{
            return
        }
        db.collection("core").document("users").collection("list").document(user.uid).setData(
            [
                "subscribedEvents": [String](),
                "hostedEvents": [String]()
                
            ]
            
        ){ err in
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
                    let id = document.documentID
                    let title = data["eventName"] as? String ?? ""
                    let description = data["eventDescription"] as? String ?? ""
                    let ownerID = data["eventOwner"] as? String ?? ""
                    let date = data["eventDate"] as? Date ?? Date()
                    let peopleNumber = data["peopleNumber"] as? Int ?? 0
                    let users = data["registeredPeople"] as? [String] ?? []
                    if let position = data["eventPosition"] as? GeoPoint {
                        var newEvent = Event(id: id, title: title, description: description, peopleNumber: peopleNumber, ownerID: ownerID, date: date, position: position)
                        newEvent.users = users
                        newEvents.append(newEvent)
                    }
                }
                completion(newEvents)
            }
        }
    }
    
    func joinEvent(eventID: String){
        guard let user = getCurrentUser() else{
                   return
               }
        db.collection("core").document("events").collection("list").document(eventID).updateData(["registeredPeople" : FieldValue.arrayUnion([user.uid])]) { err in
                   if let err = err{
                       print("\(err)")
                   }
               }
        
        db.collection("core").document("users").collection("list").document(user.uid).updateData(["registeredEvents" : FieldValue.arrayUnion([eventID])]) { err in
                          if let err = err{
                              print("\(err)")
                          }
                      }
    }
    
    func leaveEvent(eventID: String){
            guard let user = getCurrentUser() else{
                       return
                   }
            db.collection("core").document("events").collection("list").document(eventID).updateData(["registeredPeople" : FieldValue.arrayRemove([user.uid])]) { err in
                       if let err = err{
                           print("\(err)")
                       }
                   }
            
            db.collection("core").document("users").collection("list").document(user.uid).updateData(["registeredEvents" : FieldValue.arrayRemove([eventID])]) { err in
                              if let err = err{
                                  print("\(err)")
                              }
                          }
        }
    
    
    
    
    
    func signOut(){
        do{
            try Auth.auth().signOut()}
        catch{
            print(error)
        }
    }
    
    func getCurrentUser() ->  FirebaseAuth.User?{
        return Auth.auth().currentUser
    }
}

