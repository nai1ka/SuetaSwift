//
//  SingleEventViewController.swift
//  Sueta
//
//  Created by Arina Goncharova on 14.07.2023.
//

import UIKit
import MapKit

class SingleEventViewController: UIViewController{
    var event: Event? {
        didSet {
            guard let event else { return }
            setupData(event)
        }
    }
    
    
    final let leftPadding: CGFloat = 30
    final let rightPadding: CGFloat = -30
    final let topMargin: CGFloat = 12
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    var eventChangeListener: OnEventChangeListener? = nil
    
    
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
        
        return mapView
    }()
    
    private lazy var joinButton: UIButton = {
        var button: UIButton
        
        
        if #available(iOS 15.0, *) {
            var filled = UIButton.Configuration.filled()
            
            filled.buttonSize = .large
            filled.titlePadding = 10
            button = UIButton(configuration: filled, primaryAction: nil)
            button.translatesAutoresizingMaskIntoConstraints = false
            
        } else {
            button = UIButton()
            button.backgroundColor = UIColor.blue
            button.layer.cornerRadius = 8
            button.clipsToBounds = true
            
        }
        button.translatesAutoresizingMaskIntoConstraints = false
        
        
        return button
    }()
    
    private lazy var seeJoinedUsersButton: UIButton = {
        var button: UIButton
        
        
        if #available(iOS 15.0, *) {
            var filled = UIButton.Configuration.filled()
            
            filled.buttonSize = .large
            filled.titlePadding = 10
            button = UIButton(configuration: filled, primaryAction: nil)
            button.translatesAutoresizingMaskIntoConstraints = false
            
        } else {
            button = UIButton()
            button.backgroundColor = UIColor.blue
            button.layer.cornerRadius = 8
            button.clipsToBounds = true
            
        }
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Участники", for: .normal)
        button.addTarget(self, action: #selector(seeJoinedUSers), for: .touchUpInside)
        
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
        
        
        
        if let currentUser = FirebaseHelper.shared.getCurrentUser(){
            if(event.ownerID == currentUser.uid){ // Current user is a host
                seeJoinedUsersButton.isHidden = false
                joinButton.isHidden = true
            }
            else{ // Current user is not a host
                seeJoinedUsersButton.isHidden = true
                    joinButton.isHidden = false
                if(event.users.contains(currentUser.uid)){
                    joinButton.setTitle("Отписаться", for: .normal)
                    joinButton.addTarget(self, action: #selector(onLeaveClicked), for: .touchUpInside)
                }
                else{
                    joinButton.setTitle("Присоединиться", for: .normal)
                    joinButton.addTarget(self, action: #selector(onJoinClicked), for: .touchUpInside)
                }
            }
            
            
        }
        
        
        descriptionLabel.text = event.description
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.numberOfLines = 0
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM"
        eventDateLabel.text = dateFormatter.string(from: event.date)
        Task{
            do{
                let owner = try await FirebaseHelper.shared.getUserBy(id: event.ownerID)
                DispatchQueue.main.async {
                    
                    self.ownerIDLabel.text = owner?.name ?? "Unknown user"
                               }
            }
            catch{
                print("error")
            }
            
            
        }
       
        
        setupNumberOfUsersLabel(event.peopleNumber - event.users.count)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: event.position.latitude, longitude: event.position.longitude)
        let region = MKCoordinateRegion(center:  annotation.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(region, animated: true)
        
        mapView.addAnnotation(annotation)
    }
    func setupScrollView(){
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        view.addSubview(joinButton)
        view.addSubview(seeJoinedUsersButton)
        
        
        joinButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
        joinButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        joinButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
      
        
        seeJoinedUsersButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
        seeJoinedUsersButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        seeJoinedUsersButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        
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
            dateIcon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: leftPadding),
            dateIcon.widthAnchor.constraint(equalToConstant: 40),
            dateIcon.heightAnchor.constraint(equalToConstant: 40),
            
            eventDateLabel.topAnchor.constraint(equalTo: dateIcon.topAnchor),
            eventDateLabel.centerYAnchor.constraint(equalTo: dateIcon.centerYAnchor),
            eventDateLabel.leftAnchor.constraint(equalTo: dateIcon.rightAnchor, constant: 6),
            
            
            numOfParticipantsLabel.topAnchor.constraint(equalTo: dateIcon.bottomAnchor, constant: topMargin),
            numOfParticipantsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: leftPadding),
            numOfParticipantsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: rightPadding),
            
            descriptionName.topAnchor.constraint(equalTo: numOfParticipantsLabel.bottomAnchor, constant: topMargin),
            descriptionName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: leftPadding),
            
            descriptionLabel.topAnchor.constraint(equalTo: descriptionName.bottomAnchor, constant: topMargin),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: leftPadding),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: rightPadding),
            
            organisatorLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: topMargin),
            organisatorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: leftPadding),
            
            ownerIDLabel.topAnchor.constraint(equalTo: organisatorLabel.bottomAnchor, constant: 16),
            ownerIDLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: leftPadding),
            
            locationLabel.topAnchor.constraint(equalTo: ownerIDLabel.bottomAnchor, constant: topMargin),
            locationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: leftPadding),
            
            mapView.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: topMargin),
            mapView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            mapView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: leftPadding),
            mapView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: rightPadding),
            mapView.heightAnchor.constraint(equalTo: mapView.widthAnchor),
            mapView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
            
            
        ])
        
    }
    
    @objc private func onJoinClicked(){
        print("join clicked")
        if let event = event, let eventID = event.id{
            FirebaseHelper.shared.joinEvent(eventID: eventID)
            eventChangeListener?.onUsersChanged()
            joinButton.removeTarget(nil, action: nil, for: .allEvents)
            joinButton.setTitle("Отписаться", for: .normal)
            joinButton.addTarget(self, action: #selector(onLeaveClicked), for: .touchUpInside)
            setupNumberOfUsersLabel(event.peopleNumber - event.users.count - 1)
            
        }
        
    }
    
    @objc private func onLeaveClicked(){
        print("leave clicked")
        if let eventID = event?.id{
            FirebaseHelper.shared.leave(event: eventID)
            eventChangeListener?.onUsersChanged()
            self.dismiss(animated: true)
            
        }
        
    }
    
    private func setupNumberOfUsersLabel(_ numberOfPeople: Int){
        guard event != nil else{
            numOfParticipantsLabel.text = "Места закончились"
            return
        }
        if (numberOfPeople > 0) {
            numOfParticipantsLabel.text = "Осталось мест: \(numberOfPeople)"
        } else {
            numOfParticipantsLabel.text = "Места закончились"
        }
    }
    
    @objc private func seeJoinedUSers(){
        guard let event = event else{
            return
        }
        let controller = UserListViewController()
        controller.eventID = event.id
        self.present(controller, animated: true)
        Task {
            await FirebaseHelper.shared.getUsersFor(userIDS: event.users, completion:{ users in
                DispatchQueue.main.async {
                    controller.users = users
                }
                
            })
        }
    }
}
