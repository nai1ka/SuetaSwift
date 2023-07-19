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
        //        descriptionLabel.sizeToFit()
        return descriptionLabel
    }()
    
    private lazy var organisatorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Организатор"
        label.font = .boldSystemFont(ofSize: 18)
        label.sizeToFit()
        return label
    }()
    
    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Местоположение"
        label.font = .boldSystemFont(ofSize: 18)
        label.sizeToFit()
        return label
    }()
    
    private lazy var numOfParticipantsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        return label
    }()
    
    private lazy var eventDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
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
        label.sizeToFit()
        return label
    }()
    
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.isScrollEnabled = true
        return mapView
    }()
    
    private lazy var joinButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Присоединиться", for: .normal)
        button.backgroundColor = UIColor.blue
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        return button
    }()
    
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
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.numberOfLines = 0
        
        numOfParticipantsLabel.text = String(event.peopleNumber ?? 0)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM"
        eventDateLabel.text = dateFormatter.string(from: event.date)
        ownerIDLabel.text = event.ownerID
        
        if (event.peopleNumber - event.users.count > 0) {
            numOfParticipantsLabel.text = "Количество оставшихся мест: \(event.peopleNumber - event.users.count)"
        } else {
            numOfParticipantsLabel.text = "Места закончились"
        }
    }
    func setupScrollView(){
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        view.addSubview(joinButton)
        joinButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
        joinButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        joinButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: joinButton.topAnchor, constant: -16).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        scrollView.addSubview(contentView)
        
        contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor).isActive = true
        contentView.leftAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leftAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: scrollView.contentLayoutGuide.rightAnchor).isActive = true
    }
    
    func setupViews(){
        view.addSubview(joinButton)
        contentView.addSubview(eventNameLabel)
        contentView.addSubview(dateIcon)
        contentView.addSubview(eventDateLabel)
        contentView.addSubview(numOfParticipantsLabel)
        contentView.addSubview(descriptionName)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(organisatorLabel)
        contentView.addSubview(ownerIDLabel)
        contentView.addSubview(locationLabel)
        contentView.addSubview(mapView)
        
        eventNameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        eventNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 48).isActive = true
        eventDateLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        NSLayoutConstraint.activate([
            dateIcon.topAnchor.constraint(equalTo: eventNameLabel.topAnchor, constant: 56),
            dateIcon.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 48),
            dateIcon.widthAnchor.constraint(equalToConstant: 40),
            dateIcon.heightAnchor.constraint(equalToConstant: 40),
            
            eventDateLabel.topAnchor.constraint(equalTo: dateIcon.topAnchor),
            eventDateLabel.centerYAnchor.constraint(equalTo: dateIcon.centerYAnchor),
            eventDateLabel.leftAnchor.constraint(equalTo: dateIcon.leftAnchor, constant: 48),
            
            
            numOfParticipantsLabel.topAnchor.constraint(equalTo: dateIcon.bottomAnchor, constant: 24),
            numOfParticipantsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 48),
            numOfParticipantsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -48),
            
            descriptionName.topAnchor.constraint(equalTo: numOfParticipantsLabel.bottomAnchor, constant: 24),
            descriptionName.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 48),
            
            descriptionLabel.topAnchor.constraint(equalTo: descriptionName.bottomAnchor, constant: 24),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 48),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -48),
            
            organisatorLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 24),
            organisatorLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 48),
            
            ownerIDLabel.topAnchor.constraint(equalTo: organisatorLabel.bottomAnchor, constant: 16),
            ownerIDLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            
            locationLabel.topAnchor.constraint(equalTo: ownerIDLabel.bottomAnchor, constant: 24),
            locationLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 48),
            
            mapView.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 24),
            mapView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            mapView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 3/4),
            mapView.heightAnchor.constraint(equalTo: mapView.widthAnchor),
            mapView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
        
    }
}
