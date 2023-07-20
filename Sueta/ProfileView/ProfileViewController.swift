//
//  EventsListViewController.swift
//  Sueta
//
//  Created by Nail Minnemullin on 12.07.2023.
//

import Foundation
import UIKit


class ProfileViewController: UIViewController{
    var user: User? {
        didSet {
            guard let user else { return }
//            setupData(user)
        }
    }
    
    private lazy var signOutButton: UIButton = {
        let button = UIButton()
        button.setTitle("Выйти", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(onSignOut), for: .touchUpInside)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 20
       
        return button
    }()
    
    private lazy var profileImage: UIImageView = {
        let img = UIImageView()
        return img
    }()
    
    private lazy var userName: UITextField = {
        let textField = UITextField()
        return textField
    }()
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        setupViews()
    }
    
    private func setupViews(){
        signOutButton.layer.borderWidth
       
        view.addSubview(signOutButton)
        NSLayoutConstraint.activate([
            signOutButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            signOutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            signOutButton.widthAnchor.constraint(equalToConstant: 100),
            signOutButton.heightAnchor.constraint(equalToConstant: 100)
        
        ])
       
    }
    
    @objc private func onSignOut(){
        FirebaseHelper.shared.signOut()
        self.navigationController?.pushViewController(AuthViewController(), animated: true)
    }
}
