//
//  MainViewController.swift
//  Sueta
//
//  Created by Nail Minnemullin on 12.07.2023.
//

import Foundation
import UIKit
import MapKit

class MainViewController: UITabBarController{
    
    private var viewModel = MainViewModel()
   
    let  mapViewController: MapViewController
    
    init() {
        mapViewController = MapViewController(viewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        mapViewController = MapViewController(viewModel)
        super.init(coder: coder)
    }
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
           UITabBar.appearance().barTintColor = .systemBackground
           tabBar.tintColor = .label
        setupVCs()
        bindViewModel()
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
    
    func setupVCs() {
        viewControllers = [
            createNavController(for: mapViewController, title: NSLocalizedString("Map", comment: ""), image: UIImage(systemName: "map")!),
            createNavController(for: EventsListViewController(), title: NSLocalizedString("Events", comment: ""), image: UIImage(systemName: "list.bullet")!),
            createNavController(for: ProfileViewController(), title: NSLocalizedString("Profile", comment: ""), image: UIImage(systemName: "person.crop.circle")!),
        ]
    }
    
    func bindViewModel() {
            viewModel.events.bind(to: self) { strongSelf, _ in
                strongSelf.mapViewController.updateAnnotations()
            }
        }
    
   
}