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

class MapViewController: UIViewController, CLLocationManagerDelegate{
    
    let eventViewController = SingleEventViewController()
    var locationManager: CLLocationManager? = nil
    
    var userChangeDeledate: OnEventChangeListener?
    private var task: AnyCancellable?
    private var events: [Event] = []
    let viewModel: MainViewModel
    
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    init(_ viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    //MARK: OVERRIDE
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        setupLocationManager()
        initViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
    }
    //MARK: PUBLIC
    
    func updateAnnotations(){
        for i in events.indices{
            
            let annotation = CustomAnnotation(coordinate: CLLocationCoordinate2D(latitude: events[i].position.latitude, longitude: events[i].position.longitude))
            annotation.title = events[i].title
            
            annotation.index = i
            mapView.addAnnotation(annotation)
        }
    }
    
    
    //MARK: PRIVATE
    
    private func initViews(){
        mapView.delegate = self
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
    
    func setupLocationManager() {
        locationManager = CLLocationManager()
        
        locationManager!.delegate = self
        locationManager!.desiredAccuracy = kCLLocationAccuracyBest
        
        // Request location authorization from the user
        locationManager!.requestWhenInUseAuthorization()
        
        // Start updating the user's location
        locationManager!.startUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            // Update the map view's region to focus on the user's current location
            let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
            SharedData.shared.currentCoordinates = location
            mapView.setRegion(region, animated: true)
            
            // Optionally, you can stop updating location once you have the initial location
            locationManager?.stopUpdatingLocation()
        }
    }
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print("calloutAccessoryControlTapped")
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView){
        if let annotationIndex = (view.annotation as? CustomAnnotation)?.index {
            // Use the annotationID to identify the corresponding event or perform further actions
            self.present(eventViewController, animated: true)
            eventViewController.event = events[annotationIndex]
            eventViewController.eventChangeListener = userChangeDeledate
            
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // Check if the annotation is of the desired type
        guard let myAnnotation = annotation as? CustomAnnotation else {
            return nil
        }
        
        let identifier = "customAnnotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            // Create a new annotation view if it doesn't exist
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        } else {
            // Reuse the existing annotation view
            annotationView?.annotation = annotation
        }
        
        // Customize the appearance of the annotation view
        
        
        annotationView?.image = UIImage(systemName: "mappin.circle")
        annotationView?.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        
        
        
        return annotationView
    }
}


