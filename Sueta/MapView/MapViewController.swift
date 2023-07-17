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
import Combine

class MapViewController: UIViewController{
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    private var task: AnyCancellable?
    private var events: [Event] = []
    
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
        bindViewModel()
        initViews()
        
    }
    
    //MARK: PUBLIC
    
    func updateAnnotations(){
        for event in events{
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
    
    private func bindViewModel() {
        task = viewModel.$state
            .sink { [weak self] state in
                switch state{
                case .loaded(let events):
                    self?.events = events
                    self?.updateAnnotations()
                case .loading:
                    print("Loading")
                case .error(let err):
                    print(err)
                }
                
            }
        
    }
    
    
    
}


