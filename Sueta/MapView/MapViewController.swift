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
    
    let eventViewController = SingleEventViewController()
    
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
           
              
        annotationView?.image = UIImage(systemName: "mappin.square.fill")
        annotationView?.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
                
            

            return annotationView
    }
}


