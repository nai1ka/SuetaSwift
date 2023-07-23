//
//  EventCell.swift
//  Sueta
//
//  Created by Arina Goncharova on 13.07.2023.
//

import Foundation
import UIKit

final class UserCell:UITableViewCell {
    
    var user: User?{
        didSet {
            guard let user = user else{
                return
            }
            userNameLabel.text = user.name
        }
    }
    
    var userDeleteListener: UserDeleteListener?
    var index: Int?
    var event: Event?
    private lazy var userNameLabel: UILabel = {
        let userNameLabel = UILabel()
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        userNameLabel.textColor = .black
        return userNameLabel
    }()
    
    
    
    private lazy var deletUserButton: UIButton = {
        var button: UIButton
        
        if #available(iOS 15.0, *) {
            var filled = UIButton.Configuration.filled()
            filled.baseBackgroundColor = .red
            filled.image = UIImage(systemName: "x.square.fill")
            filled.buttonSize = .medium
           
            button = UIButton(configuration: filled, primaryAction: nil)
            button.translatesAutoresizingMaskIntoConstraints = false
            
        } else {
            button = UIButton()
            button.backgroundColor = UIColor.red
            button.layer.cornerRadius = 8
            button.clipsToBounds = true
            button.setBackgroundImage(UIImage(systemName: "x.square.fill"), for: .normal)
            
        }
        button.addTarget(self, action: #selector(onDeleteUserClick), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
       
        
        
        return button
        
    }()
    
    
    
    
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(userNameLabel)
        contentView.addSubview(deletUserButton)
        NSLayoutConstraint.activate([
            userNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            userNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            deletUserButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            deletUserButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            deletUserButton.widthAnchor.constraint(equalToConstant: 36),
            deletUserButton.heightAnchor.constraint(equalToConstant: 36)
            
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        userNameLabel.text = nil
    }
    
    @objc private func onDeleteUserClick(){
       
        guard let userID = user?.id, let index = index else{
            return
        }
        userDeleteListener?.onUserWasDeleted(userID: userID, index: index)
    }
    
    
}

protocol UserDeleteListener{
    func onUserWasDeleted(userID: String, index: Int)
}
