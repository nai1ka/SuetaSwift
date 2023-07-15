//
//  MapViewController.swift
//  Sueta
//
//  Created by Nail Minnemullin on 12.07.2023.
//

import Foundation
import UIKit
import MapKit
import FirebaseFirestore
import FirebaseAuth

class MapViewController: UIViewController{
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    let viewModel: MainViewModel
    
    init(_ viewModel: MainViewModel) {
    
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        
    }
    
    //MARK: PUBLIC
    
    func updateAnnotations(){
              for event in viewModel.events.value{
                  let annotation = MKPointAnnotation()
                  annotation.coordinate = CLLocationCoordinate2D(latitude: event.position.latitude, longitude: event.position.longitude)
                  mapView.addAnnotation(annotation)
              }
          }
    
    
    //MARK: PRIVATE
    
    private func initViews(){
        view.addSubview(mapView)
        mapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
    }
    
    
   
}


