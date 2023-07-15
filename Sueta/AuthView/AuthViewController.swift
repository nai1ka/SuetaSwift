//
//  AuthViewController.swift
//  Sueta
//
//  Created by Nail Minnemullin on 14.07.2023.
//

import Foundation
import UIKit
import FirebaseAuth

class AuthViewController: UIViewController, OnLoginListener{
    
    
    func onCreateAccout() {
        signInView.isHidden = true
        signUpView.isHidden = false
    }
    
    func onAlreadyHasAccount() {
        signInView.isHidden = false
        signUpView.isHidden = true
    }
    
    func succsessfullyLogined() {
        self.navigationController?.pushViewController(MainViewController(), animated: true)
    }
    
    
    private lazy var signUpView = SignUpView()
    private lazy var signInView = SignInView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpView.loginListener = self
        signInView.loginListener = self
        setupViews()
    }
    
    
    //MARK: PRIVATE
    
    
    
    private func setupViews(){
        view.backgroundColor = .systemBackground
        signUpView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(signUpView)
        
        signInView.isHidden = true
        signInView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(signInView)
        NSLayoutConstraint.activate([
            signUpView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            signUpView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            signUpView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            signUpView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            
            signInView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            signInView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            signInView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            signInView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
            
        ])
    }
    
    static func generateTitle(for value: String) -> UILabel{
        let text = UILabel()
        text.text = value
        text.textColor = .blue
        text.font = UIFont.boldSystemFont(ofSize: 24)
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }
    
    static func generateTextField(for placeholder: String) -> UITextField{
        let field = UITextField()
        field.placeholder = placeholder
        field.borderStyle = .roundedRect
        field.isEnabled = true
        field.resignFirstResponder()
        field.selectedTextRange = nil
        field.translatesAutoresizingMaskIntoConstraints = false
        field.heightAnchor.constraint(equalToConstant: 48).isActive = true
        return field
    }
    
}

protocol OnLoginListener{
    func succsessfullyLogined()
    func onAlreadyHasAccount()
    func onCreateAccout()
}
