//
//  Event.swift
//  Sueta
//
//  Created by Nail Minnemullin on 12.07.2023.
//

import Foundation
import FirebaseFirestore

struct Event{
    var id: String?
    let title: String
    let description: String
    var peopleNumber: Int
    let ownerID: String
    let date: Date
    let position: GeoPoint
    var users: [String] = []
    
}
