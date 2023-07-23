//
//  SharedData.swift
//  Sueta
//
//  Created by Nail Minnemullin on 21.07.2023.
//

import Foundation
import CoreLocation

class SharedData{
    static let shared = SharedData()
    
    private init(){}
    
    var currentCoordinates: CLLocation?
    
    
    
}
