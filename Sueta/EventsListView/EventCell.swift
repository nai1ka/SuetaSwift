//
//  EventCell.swift
//  Sueta
//
//  Created by Arina Goncharova on 13.07.2023.
//

import Foundation
import UIKit

final class EventTableViewCell:UITableViewCell {
    
    var event: Event?{
        didSet {
            guard let event = event else{
                return
            }
            eventNameLabel.text = event.title
            numOfParticipantsLabel.text = String(event.peopleNumber - event.users.count)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM"
            eventDate.text = dateFormatter.string(from: event.date)
        }
    }
    let cellView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 52/255.0, green: 120/255.0, blue: 247/255.0, alpha: 0.2)
        view.layer.cornerRadius = 20
        return view
    }()
    
    private lazy var eventNameLabel: UILabel = {
        let eventNameLabel = UILabel()
        eventNameLabel.translatesAutoresizingMaskIntoConstraints = false
        eventNameLabel.textColor = .black
        eventNameLabel.font = .boldSystemFont(ofSize: 18)
        return eventNameLabel
    }()
    
    private lazy var numOfParticipantsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        
        label.backgroundColor = .white
        label.font = .systemFont(ofSize: 16)
//        label.textColor = .blue
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
    
    private lazy var eventDate: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
        label.sizeToFit()
        return label
    }()
    
    
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(cellView)
        
        cellView.addSubview(eventNameLabel)
        cellView.addSubview(numOfParticipantsLabel)
        cellView.addSubview(dateIcon)
        cellView.addSubview(eventDate)
        
        cellView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 8, paddingBottom: 4, paddingRight: 8, width: frame.size.width, height: 100, enableInsets: false)
        
        eventNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 24).isActive = true
        eventNameLabel.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 24).isActive = true
        eventNameLabel.trailingAnchor.constraint(equalTo: numOfParticipantsLabel.leadingAnchor, constant: -10).isActive = true
        
        dateIcon.topAnchor.constraint(equalTo: eventNameLabel.bottomAnchor, constant: 8).isActive = true
        dateIcon.leftAnchor.constraint(equalTo: cellView.leftAnchor, constant: 24).isActive = true
        dateIcon.widthAnchor.constraint(equalToConstant: 30).isActive = true
        dateIcon.heightAnchor.constraint(equalToConstant: 30).isActive = true

        numOfParticipantsLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        numOfParticipantsLabel.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -24).isActive = true
        numOfParticipantsLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true // Настройте ширину label по своему усмотрению
        numOfParticipantsLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true // Настройте высоту label по своему усмотрению

        
        numOfParticipantsLabel.backgroundColor = .white
      
        numOfParticipantsLabel.layer.backgroundColor = UIColor.white.cgColor
        numOfParticipantsLabel.layer.cornerRadius = 10 // Опционально, чтобы округлить углы фона
        numOfParticipantsLabel.layer.masksToBounds = true
        
        eventDate.centerYAnchor.constraint(equalTo: dateIcon.centerYAnchor).isActive = true
        eventDate.leadingAnchor.constraint(equalTo: dateIcon.trailingAnchor, constant: 10).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        eventNameLabel.text = nil
        numOfParticipantsLabel.text = nil
        eventDate.text = nil
    }
    
    
}
