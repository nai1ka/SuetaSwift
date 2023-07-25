//
//  SignUpView.swift
//  Sueta
//
//  Created by Nail Minnemullin on 14.07.2023.
//

import Foundation
import UIKit
import FirebaseAuth

class SignUpView: UIView, UITextFieldDelegate{
    
    var loginListener: OnLoginListener?
    
    private lazy var createAccountLabel = AuthViewController.generateTitle(for: "Создайте новый аккаунт")
    private lazy var nameTextField = AuthViewController.generateTextField(for: "Введите имя")
    private lazy var emailTextField = AuthViewController.generateTextField(for: "Введите email")
    private lazy var firstPasswordTextField = AuthViewController.generateTextField(for: "Введите пароль", secured: true)
    private lazy var secondPasswordTextField = AuthViewController.generateTextField(for: "Повторите пароль", secured: true)
    
    
    private lazy var registerButton: UIButton = {
        let button: UIButton!
        if #available(iOS 15.0, *) {
            var filled = UIButton.Configuration.filled()
            filled.title = "Зарегистироваться"
            filled.buttonSize = .large
            filled.titlePadding = 10
            filled.baseBackgroundColor = .blue
            button = UIButton(configuration: filled, primaryAction: nil)
            
            
        } else {
            button = UIButton()
            button.setTitle( "Навести суеты!", for: .normal)
            // TODO fix this
            
        }
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(onRegisterClick), for: .touchUpInside)
        return button
        
        
    }()
    
    private lazy var alreadyHaveAccount: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Уже есть аккаунт?", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(alreadyHaveAccountClick), for: .touchUpInside)
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
        nameTextField.delegate = self
        emailTextField.delegate = self
        firstPasswordTextField.delegate = self
        secondPasswordTextField.delegate = self
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(stackView)
        stackView.axis = .vertical
        stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16).isActive = true
        stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
        stackView.spacing = 16
        stackView.addArrangedSubview(createAccountLabel)
        stackView.addArrangedSubview(nameTextField)
        stackView.addArrangedSubview(emailTextField)
        stackView.addArrangedSubview(firstPasswordTextField)
        stackView.addArrangedSubview(secondPasswordTextField)
        
        
        
        self.addSubview(alreadyHaveAccount)
        
        self.addSubview(registerButton)
        NSLayoutConstraint.activate([
            alreadyHaveAccount.topAnchor.constraint(equalTo: stackView.bottomAnchor,constant: 8),
            alreadyHaveAccount.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            
            
            registerButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
            registerButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            registerButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
        ])
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc private func onRegisterClick(){
        
        
        guard let name = nameTextField.text, let email = emailTextField.text, let password = firstPasswordTextField.text, password == secondPasswordTextField.text, password.count > 4 else{
            // TODO finish this
            print("Incorrent values")
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) {[weak self] authResult, error in
            if(authResult == nil){
                print("Cannot signup")
            }
            else{
                self?.loginListener?.successfullyRegistered(name: name)
            }
            
        }
    }
    
    @objc private func alreadyHaveAccountClick(){
        loginListener?.onAlreadyHasAccount()
    }
}
