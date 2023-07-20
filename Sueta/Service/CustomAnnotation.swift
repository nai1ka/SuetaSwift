//
//  CustomAnnotation.swift
//  Sueta
//
//  Created by Nail Minnemullin on 18.07.2023.
//

import Foundation
import MapKit
import UIKit


class CustomAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var index: Int? // Unique identifier for the annotation

    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        
    }
}
