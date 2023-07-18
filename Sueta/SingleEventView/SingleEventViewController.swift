//
//  SingleEventViewController.swift
//  Sueta
//
//  Created by Arina Goncharova on 14.07.2023.
//

import UIKit
import MapKit

class SingleEventViewController: UIViewController {
    var event: Event? {
        didSet {
            guard let event else { return }
            setupData(event)
        }
    }
    
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    
    private lazy var eventNameLabel: UILabel = {
        let eventNameLabel = UILabel()
        eventNameLabel.translatesAutoresizingMaskIntoConstraints = false
        eventNameLabel.textColor = .black
        eventNameLabel.sizeToFit()
        eventNameLabel.textAlignment = .center
        eventNameLabel.font = .boldSystemFont(ofSize: 24)
        return eventNameLabel
    }()
    
    private lazy var descriptionName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Описание"
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.numberOfLines = 0
        eventNameLabel.sizeToFit()
        return descriptionLabel
    }()
    
    private lazy var organisatorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Организатор"
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()
    
    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Местоположение"
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()
    
    private lazy var numOfParticipantsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        if let numOfParticipants = event?.peopleNumber, let numOfJoined = event?.users.count {
            if (numOfParticipants - numOfJoined > 0) {
                label.text = "Осталось \(numOfParticipants - numOfJoined) мест"
            } else {
                label.text = "Места закончились"
            }
        } else {
            label.text = "Нет информации о местах"
        }
        print(label.text)
        return label
    }()
    
    private lazy var eventDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var dateIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "calendar")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
//    var dateIconView = UIImageView(image: .)?<#default value#>
    
    private lazy var ownerIDLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    //    private lazy var positionMap: GeoPoint = {
    //
    //    }nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupScrollView()
        setupViews()
    }
    
    private func setupData(_ event: Event){
        print("Event title: \(event.title)")
        eventNameLabel.text = event.title
        descriptionLabel.text = event.description
        numOfParticipantsLabel.text = String(event.peopleNumber ?? 0)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM"
        eventDateLabel.text = dateFormatter.string(from: event.date)
        ownerIDLabel.text = event.ownerID
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: event.position.latitude, longitude: event.position.longitude)
        mapView.addAnnotation(annotation)
    }
    func setupScrollView(){
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        contentView.bottomAnchor.constraint(greaterThanOrEqualTo: scrollView.bottomAnchor, constant: -16).isActive = true
    }
    
    func setupViews(){
        contentView.addSubview(eventNameLabel)
        eventNameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        eventNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 48).isActive = true
        eventNameLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 3/4).isActive = true
        
        //date icon
        contentView.addSubview(dateIcon)
        dateIcon.topAnchor.constraint(equalTo: eventNameLabel.topAnchor, constant: 56).isActive = true
        dateIcon.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 48).isActive = true
        dateIcon.widthAnchor.constraint(equalToConstant: 40).isActive = true
        dateIcon.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        //event date label
        contentView.addSubview(eventDateLabel)
//        eventDateLabel.topAnchor.constraint(equalTo: dateIcon.topAnchor).isActive = true
        eventDateLabel.centerYAnchor.constraint(equalTo: dateIcon.centerYAnchor).isActive = true
        eventDateLabel.leftAnchor.constraint(equalTo: dateIcon.leftAnchor, constant: 48).isActive = true
        eventDateLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 3/4).isActive = true
        
        //available places label
        
        contentView.addSubview(numOfParticipantsLabel)
//        numOfParticipantsLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        numOfParticipantsLabel.topAnchor.constraint(equalTo: dateIcon.bottomAnchor, constant: 24).isActive = true
        numOfParticipantsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 48).isActive = true
        numOfParticipantsLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 3/4).isActive = true
        
        //"Description"
        contentView.addSubview(descriptionName)
//        descriptionName.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        descriptionName.topAnchor.constraint(equalTo: numOfParticipantsLabel.bottomAnchor, constant: 24).isActive = true
//        descriptionName.widthAnchor.constraint(equalTo: numOfParticipantsLabel.widthAnchor, multiplier: 3/4).isActive = true
        descriptionName.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 48).isActive = true

        contentView.addSubview(descriptionLabel)
        descriptionLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: descriptionName.bottomAnchor, constant: 16).isActive = true
        descriptionLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 3/4).isActive = true
        descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        //"Organisator"
        contentView.addSubview(organisatorLabel)
        organisatorLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 24).isActive = true
        organisatorLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 3/4).isActive = true
        organisatorLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 48).isActive = true
        
        // Organisator label
        contentView.addSubview(ownerIDLabel)
//        descriptionLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        ownerIDLabel.topAnchor.constraint(equalTo: organisatorLabel.bottomAnchor, constant: 16).isActive = true
        ownerIDLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 3/4).isActive = true
        ownerIDLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24).isActive = true
        
        //"Location"
        contentView.addSubview(locationLabel)
        locationLabel.topAnchor.constraint(equalTo: ownerIDLabel.bottomAnchor, constant: 24).isActive = true
        locationLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 3/4).isActive = true
        locationLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 48).isActive = true
        
        //map view
        contentView.addSubview(mapView)
        mapView.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 24).isActive = true
        mapView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        mapView.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 3/4).isActive = true
        mapView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 3/4).isActive = true
    }
}
