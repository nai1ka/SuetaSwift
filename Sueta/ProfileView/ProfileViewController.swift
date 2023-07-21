//
//  EventsListViewController.swift
//  Sueta
//
//  Created by Nail Minnemullin on 12.07.2023.
//

import Foundation
import UIKit
import Combine


class ProfileViewController: UIViewController{
    var user: User? {
        didSet {
            guard let user else { return }
            //            setupData(user)
        }
    }
    var childViewController: EventsListViewController?

    
    private final let segmentControl: UISegmentedControl = {
           let segmentControl = UISegmentedControl(items: ["Созданные", "Подписанные"])
           segmentControl.translatesAutoresizingMaskIntoConstraints = false
           segmentControl.selectedSegmentIndex = 0
           
           segmentControl.addTarget(self, action: #selector(onSegmentValueChanged), for: .valueChanged)
           return segmentControl
       }()
    
    var eventListViewController: EventsListViewController?
    
    private var task: AnyCancellable?
    var events: [Event] = [] {
           didSet{
               onSegmentValueChanged()
           }
       }
    
    var userChangeDeledate: OnEventChangeListener?
    
    
 
    
    private lazy var signOutButton: UIButton = {
        var button: UIButton
        if #available(iOS 15.0, *) {
                    var filled = UIButton.Configuration.filled()
                    filled.title = "Выйти!"
                    filled.buttonSize = .large
                    filled.titlePadding = 10
                    button = UIButton(configuration: filled, primaryAction: nil)
                    button.translatesAutoresizingMaskIntoConstraints = false
                    
                } else {
                    button = UIButton()
                    button.setTitle( "Выйти!", for: .normal)
                    
                }

        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(onSignOut), for: .touchUpInside)
        
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
        addChildViewController()
    }
    
    private func setupViews(){
      
        view.addSubview(signOutButton)
        view.addSubview(segmentControl)
        NSLayoutConstraint.activate([
            signOutButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
           
            signOutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signOutButton.widthAnchor.constraint(equalToConstant: 100),
            signOutButton.heightAnchor.constraint(equalToConstant: 40),
            segmentControl.topAnchor.constraint(equalTo: signOutButton.bottomAnchor, constant: 20),
            segmentControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            segmentControl.heightAnchor.constraint(equalToConstant: 30)
        ])
        
    }
    
    @objc private func onSignOut(){
        FirebaseHelper.shared.signOut()
        self.navigationController?.pushViewController(AuthViewController(), animated: true)
    }
    private func addChildViewController() {
        let eventListVC = EventsListViewController()
        eventListVC.userChangeDelegate = userChangeDeledate
        addChild(eventListVC)
        view.addSubview(eventListVC.view)
        eventListVC.view.translatesAutoresizingMaskIntoConstraints = false
        eventListVC.didMove(toParent: self)
        childViewController = eventListVC
        
        // Customize the frame of the child view controller's view
        NSLayoutConstraint.activate([
            eventListVC.view.topAnchor.constraint(equalTo: segmentControl.bottomAnchor),
            eventListVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            eventListVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            eventListVC.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
       
        // Adjust the position and size of the child view controller's view according to your requirements
    }
    
    @objc private func onSegmentValueChanged(){
          
          switch segmentControl.selectedSegmentIndex{
          case 0:
              childViewController?.events = self.events.filter({ event in
                  if let currentUserID = FirebaseHelper.shared.getCurrentUser()?.uid{
                      return event.ownerID == currentUserID
                  }
                 return true
                
              })
            
            
              
          case 1:
              childViewController?.events = self.events.filter({ event in
                                if let currentUserID = FirebaseHelper.shared.getCurrentUser()?.uid{
                                    return event.users.contains(currentUserID)
                                }
                               return true
                              
                            })
          default:
              break
          }
          
      }
    
}
