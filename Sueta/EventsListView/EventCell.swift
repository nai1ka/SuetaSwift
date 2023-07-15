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
            eventNameLabel.text = event?.title
            numOfParticipantsLabel.text = String(event?.peopleNumber ?? 0)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM"
            if let date = event?.date {
                eventDate.text = dateFormatter.string(from: date)
            } else {
                eventDate.text = dateFormatter.string(from: Date())
            }
            
        }
    }
    private lazy var eventNameLabel: UILabel = {
        let eventNameLabel = UILabel()
        eventNameLabel.translatesAutoresizingMaskIntoConstraints = false
        eventNameLabel.textColor = .black
        return eventNameLabel
    }()
    
    private lazy var numOfParticipantsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var eventDate: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
   
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(eventNameLabel)
        addSubview(numOfParticipantsLabel)
        addSubview(eventDate)

        
        eventNameLabel.anchor(top: topAnchor, left: safeAreaLayoutGuide.leftAnchor, bottom: nil, right: nil, paddingTop: 24, paddingLeft: 24, paddingBottom: 8, paddingRight: 0, width: frame.size.width / 2, height: 0, enableInsets: false)
        
        numOfParticipantsLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        numOfParticipantsLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -24).isActive = true

        eventDate.anchor(top: eventNameLabel.bottomAnchor, left: safeAreaLayoutGuide.leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 24, paddingBottom: 8, paddingRight: 0, width: frame.size.width/2, height: 0, enableInsets: false)
        
        
       
       
         
         
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupData(_ data: Event){
        eventNameLabel.text = data.title
        numOfParticipantsLabel.text = String(data.peopleNumber)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        eventNameLabel.text = nil
        numOfParticipantsLabel.text = nil
    }
    
    
}
