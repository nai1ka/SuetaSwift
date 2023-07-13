//
//  Event.swift
//  Sueta
//
//  Created by Nail Minnemullin on 12.07.2023.
//

import Foundation
import FirebaseFirestore

struct Event{
    let title: String
    let description: String
    let peopleNumber: Int
    let ownerID: String
    let date: Date
    let position: GeoPoint
    let users: [User] = []
    
}
