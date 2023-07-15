//
//  SingleEventViewController.swift
//  Sueta
//
//  Created by Arina Goncharova on 14.07.2023.
//

import UIKit

class SingleEventViewController: UIViewController {
    var event: Event? {
        didSet {
            guard let event else { return }
            setupData(event)
        }
    }
    
    private lazy var eventNameLabel: UILabel = {
        let eventNameLabel = UILabel()
        eventNameLabel.translatesAutoresizingMaskIntoConstraints = false
        eventNameLabel.textColor = .black
        return eventNameLabel
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        return descriptionLabel
    }()
    
    private lazy var numOfParticipantsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var eventDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var ownerIDLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
//    private lazy var positionMap: GeoPoint = {
//
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews(){
        view.addSubview(eventNameLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(numOfParticipantsLabel)
        view.addSubview(eventDateLabel)
        view.addSubview(ownerIDLabel)
        
        NSLayoutConstraint.activate([
            eventNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            eventNameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            descriptionLabel.topAnchor.constraint(equalTo: eventNameLabel.bottomAnchor, constant: 24),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            numOfParticipantsLabel.topAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: 24),
            numOfParticipantsLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            eventDateLabel.topAnchor.constraint(equalTo: numOfParticipantsLabel.topAnchor, constant: 24),
            eventDateLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            ownerIDLabel.topAnchor.constraint(equalTo: eventDateLabel.topAnchor, constant: 24),
            ownerIDLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24)
        ])
    }
    private func setupData(_ event: Event){
        eventNameLabel.text = event.title
        descriptionLabel.text = event.description
        numOfParticipantsLabel.text = String(event.peopleNumber ?? 0)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM"
        eventDateLabel.text = dateFormatter.string(from: event.date)
        ownerIDLabel.text = event.ownerID
        
        
    }
}
