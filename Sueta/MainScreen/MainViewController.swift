//
//  MainViewController.swift
//  Sueta
//
//  Created by Nail Minnemullin on 12.07.2023.
//

import Foundation
import UIKit
import MapKit
import Combine

class MainViewController: UITabBarController, OnEventChangeListener{
    func onEventAdded() {
        viewModel.fetchEvents()
    }
    private var events: [Event] = []
    
    private var task: AnyCancellable?
    private var viewModel = MainViewModel()
   
    let mapViewController: MapViewController
    let eventListViewController: EventsListViewController
    
    
    
    private lazy var newEventButton: UIButton={
           let button: UIButton!
           if #available(iOS 15.0, *) {
               var filled = UIButton.Configuration.filled()
               filled.title = "Навести суеты!"
               filled.buttonSize = .large
               filled.titlePadding = 10
               button = UIButton(configuration: filled, primaryAction: nil)
               button.translatesAutoresizingMaskIntoConstraints = false
               
           } else {
               button = UIButton()
               button.setTitle( "Навести суеты!", for: .normal)
               
           }
           button.addTarget(self, action: #selector(createNewEvent), for: .touchUpInside)
           return button
           
         
       }()
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
            if let index = (tabBar.items?.firstIndex(of: item)){
                if(index==2){
                    newEventButton.isHidden = true
                }
                else{
                    newEventButton.isHidden = false
                }
            }
        }
    
    init() {
        mapViewController = MapViewController(viewModel)
        eventListViewController = EventsListViewController(viewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        mapViewController = MapViewController(viewModel)
        eventListViewController = EventsListViewController(viewModel)
        super.init(coder: coder)
    }
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
           UITabBar.appearance().barTintColor = .systemBackground
           tabBar.tintColor = .label
        setupVCs()
        setupViews()
        viewModel.fetchEvents()
    }
    
    private func createNavController(for rootViewController: UIViewController,
                                     title: String,
                                     image: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        navController.navigationBar.barTintColor = .white
        rootViewController.navigationItem.title = title
        
       
        
        return navController
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.hidesBackButton = true
    }
    
    private func setupVCs() {
        viewControllers = [
            createNavController(for: mapViewController, title: NSLocalizedString("Map", comment: ""), image: UIImage(systemName: "map")!),
            createNavController(for: eventListViewController, title: NSLocalizedString("Events", comment: ""), image: UIImage(systemName: "list.bullet")!),
            createNavController(for: ProfileViewController(), title: NSLocalizedString("Profile", comment: ""), image: UIImage(systemName: "person.crop.circle")!),
        ]
    }
    
    private func setupViews(){
        view.addSubview(newEventButton)
                newEventButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
                newEventButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
                
                newEventButton.heightAnchor.constraint(equalToConstant:40).isActive = true
    }
    
   
    
    @objc private func createNewEvent(){
        let newEventVC = NewEventViewController()
        newEventVC.onEventChangeListener = self
        self.present(newEventVC, animated: true)
    }
   
}
