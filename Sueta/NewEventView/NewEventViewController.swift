//
//  NewEventViewController.swift
//  Sueta
//
//  Created by Nail Minnemullin on 13.07.2023.
//

import Foundation
import UIKit

class NewEventViewController: UIViewController{
    
    private final let segmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl(items: ["One", "Two"])
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.selectedSegmentIndex = 0
        
        segmentControl.addTarget(self, action: #selector(onSegmentValueChanged), for: .valueChanged)
        return segmentControl
    }()
    private final let enterTitleLabel: UILabel = generateTitle(for: "Введите название")
    private final let enterDiscriptionLabel: UILabel = generateTitle(for: "Введите описание")
    private final let enterNumberOfPeopleLabel: UILabel = generateTitle(for: "Сколько нужно человек?")
    
    private final let titleTextField: UITextField = generateTextField(for: "Название")
    private final let descriptionTextField: UITextField = generateTextField(for: "Описание")
    private final let numberOfPeopleTextField: UITextField = generateTextField(for: "Количество людей")
    
    
    
    private final let generalInfoView = UIView()
    
    private final let mapInfoView =  UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews(){
        view.backgroundColor = .systemBackground
        view.addSubview(segmentControl)
        segmentControl.topAnchor.constraint(equalTo: view.topAnchor, constant: 16).isActive = true
        segmentControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        segmentControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        
        view.addSubview(generalInfoView)
        generalInfoView.topAnchor.constraint(equalTo: segmentControl.bottomAnchor).isActive = true
        generalInfoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        generalInfoView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
        setupGeneralInfoView()
    }
    
    
    //MARK: PRIVATE
    
    @objc private func onSegmentValueChanged(){
        
        switch segmentControl.selectedSegmentIndex{
        case 0:
            generalInfoView.isHidden = false
            mapInfoView.isHidden = true
            
        case 1:
            generalInfoView.isHidden = true
            mapInfoView.isHidden = false
        default:
            break
        }
        
    }
    

    
  
    
    private func setupGeneralInfoView(){
        generalInfoView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(generalInfoView)
        
        generalInfoView.addSubview(enterTitleLabel)
        enterTitleLabel.topAnchor.constraint(equalTo: segmentControl.bottomAnchor,constant: 32).isActive = true
        enterTitleLabel.leadingAnchor.constraint(equalTo: generalInfoView.leadingAnchor).isActive = true
        enterTitleLabel.trailingAnchor.constraint(equalTo: generalInfoView.trailingAnchor).isActive = true
        
        generalInfoView.addSubview(titleTextField)
        titleTextField.topAnchor.constraint(equalTo: enterTitleLabel.bottomAnchor, constant: 16).isActive = true
        titleTextField.leadingAnchor.constraint(equalTo: generalInfoView.leadingAnchor).isActive = true
        titleTextField.trailingAnchor.constraint(equalTo: generalInfoView.trailingAnchor).isActive = true
        
        generalInfoView.addSubview(enterDiscriptionLabel)
        enterDiscriptionLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 16).isActive = true
        enterDiscriptionLabel.leadingAnchor.constraint(equalTo: generalInfoView.leadingAnchor).isActive = true
        enterDiscriptionLabel.trailingAnchor.constraint(equalTo: generalInfoView.trailingAnchor).isActive = true
        
        generalInfoView.addSubview(descriptionTextField)
        descriptionTextField.topAnchor.constraint(equalTo: enterDiscriptionLabel.bottomAnchor, constant: 16).isActive = true
        descriptionTextField.leadingAnchor.constraint(equalTo: generalInfoView.leadingAnchor).isActive = true
        descriptionTextField.trailingAnchor.constraint(equalTo: generalInfoView.trailingAnchor).isActive = true
        
        
        generalInfoView.addSubview(enterNumberOfPeopleLabel)
               enterNumberOfPeopleLabel.topAnchor.constraint(equalTo: descriptionTextField.bottomAnchor, constant: 16).isActive = true
        enterNumberOfPeopleLabel.leadingAnchor.constraint(equalTo: generalInfoView.leadingAnchor).isActive = true
        enterNumberOfPeopleLabel.trailingAnchor.constraint(equalTo: generalInfoView.trailingAnchor).isActive = true
        
        generalInfoView.addSubview(numberOfPeopleTextField)
               numberOfPeopleTextField.topAnchor.constraint(equalTo: enterNumberOfPeopleLabel.bottomAnchor, constant: 16).isActive = true
        numberOfPeopleTextField.leadingAnchor.constraint(equalTo: generalInfoView.leadingAnchor).isActive = true
        numberOfPeopleTextField.trailingAnchor.constraint(equalTo: generalInfoView.trailingAnchor).isActive = true
               
        
        
        
     
    }
    
    private static func generateTitle(for value: String) -> UILabel{
           let text = UILabel()
           text.text = value
           text.textColor = .blue
           text.font = UIFont.boldSystemFont(ofSize: 20)
           text.translatesAutoresizingMaskIntoConstraints = false
           return text
       }
       
      private static func generateTextField(for placeholder: String) -> UITextField{
           let field = UITextField()
           field.placeholder = placeholder
           field.translatesAutoresizingMaskIntoConstraints = false
           return field
       }
}
