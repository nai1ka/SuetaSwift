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
//            numOfParticipantsLabel.text = String(event?.peopleNumber)
        }
    }
    private lazy var eventNameLabel: UILabel = {
        let eventNameLabel = UILabel()
        eventNameLabel.translatesAutoresizingMaskIntoConstraints = false
        return eventNameLabel
    }()
    
    let numOfParticipantsLabel: UILabel = {
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

        
        eventNameLabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 0, width: frame.size.width / 2, height: 0, enableInsets: false)
        
        numOfParticipantsLabel.anchor(top: eventNameLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 16, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: frame.size.width / 2, height: 0, enableInsets: false)
        
        
       
       
         
         
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
