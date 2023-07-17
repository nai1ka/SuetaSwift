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
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.numberOfLines = 0
        eventNameLabel.sizeToFit()
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
    
//    var dateIconView = UIImageView(image: .)?<#default value#>
    
    private lazy var ownerIDLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        eventNameLabel.text = event.title
        descriptionLabel.text = event.description
        numOfParticipantsLabel.text = String(event.peopleNumber ?? 0)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM"
        eventDateLabel.text = dateFormatter.string(from: event.date)
        ownerIDLabel.text = event.ownerID
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
    }
    
    func setupViews(){
        contentView.addSubview(eventNameLabel)
        eventNameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        eventNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 48).isActive = true
        eventNameLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 3/4).isActive = true
        
//        contentView.addSubview(dateIcon)
        eventNameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        eventNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 48).isActive = true
        eventNameLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 3/4).isActive = true
        
        contentView.addSubview(descriptionName)
        descriptionName.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        descriptionName.topAnchor.constraint(equalTo: eventNameLabel.bottomAnchor, constant: 24).isActive = true
        descriptionName.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 3/4).isActive = true
        
        contentView.addSubview(descriptionLabel)
        descriptionLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: descriptionName.bottomAnchor, constant: 16).isActive = true
        descriptionLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 3/4).isActive = true
        descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
}
