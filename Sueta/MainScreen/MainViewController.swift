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

class MainViewController: UITabBarController, OnEventChangeListener, SignOutListener{
    
    private var events: [Event] = []
    private var task: AnyCancellable?
    private var viewModel = MainViewModel()
    
    let mapViewController: MapViewController
    let eventListViewController: EventsListViewController
    let profileViewController: ProfileViewController
    
    
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
    
    init() {
        mapViewController = MapViewController(viewModel)
        eventListViewController = EventsListViewController()
        profileViewController = ProfileViewController()
        super.init(nibName: nil, bundle: nil)
        eventListViewController.eventChangeDelegate = self
        profileViewController.userChangeDeledate = self
        profileViewController.signOutListener = self
        mapViewController.userChangeDeledate = self
        
    }
    
    required init?(coder: NSCoder) {
        mapViewController = MapViewController(viewModel)
        eventListViewController = EventsListViewController()
        profileViewController = ProfileViewController()
        super.init(coder: coder)
    }
    
    //MARK: OVERRIDE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        bindViewModel()
        view.backgroundColor = .systemBackground
        UITabBar.appearance().barTintColor = .systemBackground
        tabBar.tintColor = .label
        setupVCs()
        setupViews()
        viewModel.fetchEvents()
    }
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.hidesBackButton = true
    }
    
    
    //MARK: PUBLIC
    
    func onEventReload() {
        viewModel.fetchEvents()
    }
    
    func onSignOut() {
        self.navigationController?.pushViewController(AuthViewController(), animated: true)
    }
    
    func onUsersChanged() {
        print("Changed")
        viewModel.fetchEvents()
    }
    
    func onEventAdded() {
        viewModel.fetchEvents()
    }
    
    
    
    //MARK: PRIVATE
    
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
    
    
    private func setupVCs() {
        viewControllers = [
            createNavController(for: mapViewController, title: "Карта", image: UIImage(systemName: "map")!),
            createNavController(for: eventListViewController, title: "Событий", image: UIImage(systemName: "list.bullet")!),
            createNavController(for: profileViewController, title: "Профиль", image: UIImage(systemName: "person.crop.circle")!),
        ]
    }
    
    private func setupViews(){
        view.addSubview(newEventButton)
        newEventButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        newEventButton.bottomAnchor.constraint(equalTo: self.tabBar.topAnchor, constant: -10).isActive = true
        newEventButton.heightAnchor.constraint(equalToConstant:40).isActive = true
    }
    
    
    
    @objc private func createNewEvent(){
        let newEventVC = NewEventViewController()
        newEventVC.onEventChangeListener = self
        self.present(newEventVC, animated: true)
    }
    
    private func bindViewModel() {
        task = viewModel.$state
            .sink { [weak self] state in
                switch state{
                case .loaded(let events):
                    self?.eventListViewController.events = events
                    self?.profileViewController.events = events
                case .loading:
                    print("Loading")
                case .error(let err):
                    print(err)
                }
                
            }
    }
    
}
