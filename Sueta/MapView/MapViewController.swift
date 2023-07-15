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
    
    private lazy var newEventButton: UIButton={
        let button: UIButton!
        if #available(iOS 15.0, *) {
            var filled = UIButton.Configuration.filled()
            filled.title = "Навести суеты!"
            filled.buttonSize = .large
            filled.titlePadding = 10
            button = UIButton(configuration: filled, primaryAction: nil)
            button.translatesAutoresizingMaskIntoConstraints = false
            
        } else {
            button = UIButton()
            button.setTitle( "Навести суеты!", for: .normal)
            
        }
        button.addTarget(self, action: #selector(createNewEvent), for: .touchUpInside)
        return button
        
      
    }()
    
    
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
        
        view.addSubview(newEventButton)
        newEventButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        newEventButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
        
        newEventButton.heightAnchor.constraint(equalToConstant:40).isActive = true
        
    }
    
    @objc private func createNewEvent(){
        self.present(NewEventViewController(), animated: true)
        do{
            try Auth.auth().signOut()
        }
        catch{
            print("Cannot sign out")
        }
       
//        FirebaseHelper.shared.addEvent(Event(title: "Sueta", description: "Hello world", peopleNumber: 10, ownerID: "Arina", date: Date(), position: GeoPoint(latitude: 0, longitude: 0)))
    }
    
   
}


