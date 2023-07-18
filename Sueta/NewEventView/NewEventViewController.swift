//
//  NewEventViewController.swift
//  Sueta
//
//  Created by Nail Minnemullin on 13.07.2023.
//

import Foundation
import UIKit
import MapKit
import FirebaseFirestore
import FirebaseAuth

class NewEventViewController: UIViewController{
    
    private final let segmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl(items: ["Информация", "Карта"])
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.selectedSegmentIndex = 0
        
        segmentControl.addTarget(self, action: #selector(onSegmentValueChanged), for: .valueChanged)
        return segmentControl
    }()
    
    var onEventChangeListener: OnEventChangeListener?
    
    private lazy var nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(nextBtnClick), for: .touchUpInside)
        button.setTitle("Далее",
                        for: .normal)
        
        button.setImage(UIImage(systemName: "arrow.right"),
                        
                        for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        return button
    }()
    
    private lazy var prevButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(prevBtnClick), for: .touchUpInside)
        button.setTitle("Назад",
                        for: .normal)
        button.isHidden = true
        
        button.setImage(UIImage(systemName: "arrow.left"),
                        
                        for: .normal)
        return button
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(doneBtnClick), for: .touchUpInside)
        button.setTitle("Готово",
                        for: .normal)
        button.isHidden = true
        
        button.setImage(UIImage(systemName: "checkmark"),
                        
                        for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        return button
    }()
    
    private lazy var enterTitleLabel: UILabel = NewEventViewController.generateTitle(for: "Введите название")
    private lazy var enterDiscriptionLabel: UILabel = NewEventViewController.generateTitle(for: "Введите описание")
    private lazy var enterNumberOfPeopleLabel: UILabel = NewEventViewController.generateTitle(for: "Сколько нужно человек?")
    private lazy var enterDateLabel: UILabel = NewEventViewController.generateTitle(for: "Выберите дату и время")
    
    private lazy var titleTextField:UITextField = NewEventViewController.generateTextField(for: "Название")
    private lazy var descriptionTextField: UITextField = NewEventViewController.generateTextField(for: "Описание")
    private lazy var numberOfPeopleTextField: UITextField = NewEventViewController.generateTextField(for: "Количество людей")
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 14, *) {
            datePicker.preferredDatePickerStyle = .inline
        }
        return datePicker
        
        
    }()
    
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false 
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onMapClick))
        mapView.addGestureRecognizer(gestureRecognizer)
        return mapView
    }()
    
    
    private let generalInfoView = UIView()
    
    private let mapInfoView =  UIView()
    
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
        
        
        view.addSubview(nextButton)
        nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
        view.addSubview(prevButton)
        prevButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        prevButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        
        view.addSubview(doneButton)
        doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
        view.addSubview(generalInfoView)
        generalInfoView.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: 8).isActive = true
        generalInfoView.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -8).isActive = true
        generalInfoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        generalInfoView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
        mapInfoView.isHidden = true
        view.addSubview(mapInfoView)
        mapInfoView.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: 8).isActive = true
        mapInfoView.bottomAnchor.constraint(equalTo: prevButton.topAnchor, constant: -8).isActive = true
        mapInfoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        mapInfoView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
        setupGeneralInfoView()
        setupMapView()
    }
    
    
    //MARK: PRIVATE
    
    @objc private func onSegmentValueChanged(){
        
        switch segmentControl.selectedSegmentIndex{
        case 0:
            generalInfoView.isHidden = false
            mapInfoView.isHidden = true
            prevButton.isHidden = true
            nextButton.isHidden = false
            doneButton.isHidden = true
            
        case 1:
            generalInfoView.isHidden = true
            mapInfoView.isHidden = false
            nextButton.isHidden = true
            prevButton.isHidden = false
            doneButton.isHidden = false
        default:
            break
        }
        
    }
    
    @objc private func nextBtnClick() {
        segmentControl.selectedSegmentIndex = min(segmentControl.numberOfSegments-1, segmentControl.selectedSegmentIndex+1)
        onSegmentValueChanged()
    }
    
    @objc private func prevBtnClick() {
        segmentControl.selectedSegmentIndex = max(0,segmentControl.selectedSegmentIndex-1)
        onSegmentValueChanged()
    }
    
    @objc private func doneBtnClick() {
        if (!(titleTextField.hasText && descriptionTextField.hasText && numberOfPeopleTextField.hasText && mapView.annotations.count==1)){
            return
        }
        
        let title = titleTextField.text
        let description = descriptionTextField.text
        guard let peopleNumber = Int(numberOfPeopleTextField.text!) else{
            return
        }
        
        let date = datePicker.date
        let position = GeoPoint(latitude: mapView.annotations[0].coordinate.latitude,
                                         longitude: mapView.annotations[0].coordinate.longitude)
       
        
        
        let newEvent = Event(title: title!, description: description!, peopleNumber: peopleNumber, ownerID: FirebaseHelper.shared.getCurrentUser()!.uid, date: date, position: position)
        FirebaseHelper.shared.addEvent(newEvent)
        onEventChangeListener?.onEventAdded()
        self.dismiss(animated: true)
    }
    
    @objc func onMapClick(recognizer: UITapGestureRecognizer) {
        mapView.removeAnnotations(mapView.annotations)
        let touch = recognizer.location(in: mapView)
        let coord = mapView.convert(touch, toCoordinateFrom: mapView)
        
        let annot = MKPointAnnotation()
        annot.coordinate = coord
        mapView.addAnnotation(annot)
    }
    
    
    
    
    private func setupGeneralInfoView(){
        generalInfoView.translatesAutoresizingMaskIntoConstraints = false
        
        generalInfoView.addSubview(enterTitleLabel)
        enterTitleLabel.topAnchor.constraint(equalTo: generalInfoView.topAnchor).isActive = true
        
        enterTitleLabel.leadingAnchor.constraint(equalTo: generalInfoView.leadingAnchor).isActive = true
        enterTitleLabel.trailingAnchor.constraint(equalTo: generalInfoView.trailingAnchor).isActive = true
        
        generalInfoView.addSubview(titleTextField)
        titleTextField.topAnchor.constraint(equalTo: enterTitleLabel.bottomAnchor, constant: 8).isActive = true
        titleTextField.leadingAnchor.constraint(equalTo: generalInfoView.leadingAnchor).isActive = true
        titleTextField.trailingAnchor.constraint(equalTo: generalInfoView.trailingAnchor).isActive = true
        
        generalInfoView.addSubview(enterDiscriptionLabel)
        enterDiscriptionLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 16).isActive = true
        enterDiscriptionLabel.leadingAnchor.constraint(equalTo: generalInfoView.leadingAnchor).isActive = true
        enterDiscriptionLabel.trailingAnchor.constraint(equalTo: generalInfoView.trailingAnchor).isActive = true
        
        generalInfoView.addSubview(descriptionTextField)
        descriptionTextField.topAnchor.constraint(equalTo: enterDiscriptionLabel.bottomAnchor, constant: 8).isActive = true
        descriptionTextField.leadingAnchor.constraint(equalTo: generalInfoView.leadingAnchor).isActive = true
        descriptionTextField.trailingAnchor.constraint(equalTo: generalInfoView.trailingAnchor).isActive = true
        
        
        generalInfoView.addSubview(enterNumberOfPeopleLabel)
        enterNumberOfPeopleLabel.topAnchor.constraint(equalTo: descriptionTextField.bottomAnchor, constant: 16).isActive = true
        enterNumberOfPeopleLabel.leadingAnchor.constraint(equalTo: generalInfoView.leadingAnchor).isActive = true
        enterNumberOfPeopleLabel.trailingAnchor.constraint(equalTo: generalInfoView.trailingAnchor).isActive = true
        
        generalInfoView.addSubview(numberOfPeopleTextField)
        numberOfPeopleTextField.topAnchor.constraint(equalTo: enterNumberOfPeopleLabel.bottomAnchor, constant: 8).isActive = true
        numberOfPeopleTextField.leadingAnchor.constraint(equalTo: generalInfoView.leadingAnchor).isActive = true
        numberOfPeopleTextField.trailingAnchor.constraint(equalTo: generalInfoView.trailingAnchor).isActive = true
        
        generalInfoView.addSubview(enterDateLabel)
        enterDateLabel.topAnchor.constraint(equalTo: numberOfPeopleTextField.bottomAnchor, constant: 16).isActive = true
        enterDateLabel.leadingAnchor.constraint(equalTo: generalInfoView.leadingAnchor).isActive = true
        enterDateLabel.trailingAnchor.constraint(equalTo: generalInfoView.trailingAnchor).isActive = true
        
        generalInfoView.addSubview(datePicker)
        datePicker.topAnchor.constraint(equalTo: enterDateLabel.bottomAnchor, constant: 8).isActive = true
        datePicker.leadingAnchor.constraint(equalTo: generalInfoView.leadingAnchor).isActive = true
        datePicker.trailingAnchor.constraint(equalTo: generalInfoView.trailingAnchor).isActive = true
        
    }
    
    private func setupMapView(){
        mapInfoView.translatesAutoresizingMaskIntoConstraints = false
        mapInfoView.addSubview(mapView)
        mapView.topAnchor.constraint(equalTo: mapInfoView.topAnchor).isActive = true
        mapView.leadingAnchor.constraint(equalTo: mapInfoView.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: mapInfoView.trailingAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: mapInfoView.bottomAnchor).isActive = true
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
        field.borderStyle = .roundedRect
        field.isEnabled = true
        field.resignFirstResponder()
        field.selectedTextRange = nil
        
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }
}

protocol OnEventChangeListener{
    func onEventAdded()
}
