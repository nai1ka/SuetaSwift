//
//  SignUpView.swift
//  Sueta
//
//  Created by Nail Minnemullin on 14.07.2023.
//

import Foundation
import UIKit
import FirebaseAuth

class SignInView: UIView, UITextFieldDelegate{
    
    var loginListener: OnLoginListener?
    
    private lazy var loginLabel = AuthViewController.generateTitle(for: "Войдите в аккаунт")
    private lazy var emailTextField = AuthViewController.generateTextField(for: "Введите email")
    private lazy var passwordTextField = AuthViewController.generateTextField(for: "Введите пароль", secured: true)
    
    
    private lazy var loginButton: UIButton = {
        let button: UIButton!
        if #available(iOS 15.0, *) {
            var filled = UIButton.Configuration.filled()
            filled.title = "Войти"
            filled.buttonSize = .large
            filled.titlePadding = 10
            filled.baseBackgroundColor = .blue
            button = UIButton(configuration: filled, primaryAction: nil)
            button.translatesAutoresizingMaskIntoConstraints = false
            
        } else {
            button = UIButton()
            button.setTitle( "Навести суеты!", for: .normal)
            // TODO fix this
            
        }
        button.addTarget(self, action: #selector(onLoginClick), for: .touchUpInside)
        return button
        
        
    }()
    
    private lazy var createAccountButton: UIButton = {
           let button = UIButton(type: .system)
           button.setTitle("Создать аккаунт", for: .normal)
           button.translatesAutoresizingMaskIntoConstraints = false
           button.setTitleColor(.blue, for: .normal)
           button.addTarget(self, action: #selector(createAccountClick), for: .touchUpInside)
           return button
       }()
    
    
    private let stackView =  UIStackView()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    func initSubviews() {
       
                emailTextField.delegate = self
                passwordTextField.delegate = self
              
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(stackView)
        stackView.axis = .vertical
        stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16).isActive = true
        stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
        stackView.spacing = 16
        stackView.addArrangedSubview(loginLabel)
        stackView.addArrangedSubview(emailTextField)
        stackView.addArrangedSubview(passwordTextField)
        
        
        self.addSubview(createAccountButton)
        self.addSubview(loginButton)
        NSLayoutConstraint.activate([
            createAccountButton.topAnchor.constraint(equalTo: stackView.bottomAnchor,constant: 8),
            createAccountButton.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            loginButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
            loginButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            loginButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
        ])
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           textField.resignFirstResponder()
           return true
       }
    
    @objc private func onLoginClick(){
        
        guard let email = emailTextField.text, let password = passwordTextField.text else{
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard self != nil else { return }
            if(authResult == nil){
                print("Incorrect values")
            }
            else{
                print(authResult!.description)
                self?.loginListener?.successfullyLogined()
            }
           
          // ...
        }
    }
    
    @objc private func createAccountClick(){
        loginListener?.onCreateAccout()
    }
}
