//
//  EventsListViewController.swift
//  Sueta
//
//  Created by Nail Minnemullin on 12.07.2023.
//

import Foundation
import UIKit
import Combine

class JoinedEventsViewController: UIViewController, OnCellClickDelegate {
    let eventViewController = SingleEventViewController()
    private var task: AnyCancellable?
    private var events: [Event] = []
    func onCellClick(indexPath: IndexPath) {
        self.present(eventViewController, animated: true)
        eventViewController.event = events[indexPath.row]
    }
    
    
    let tableView = UITableView()
    let tableController = EventListTableViewController()
    let viewModel: MainViewModel
    init(_ viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .systemBackground
        tableView.dataSource = tableController
        tableView.delegate = tableController
        tableController.listViewController = self
        bindViewModel()
        setupTableView()
        tableView.reloadData()
        
    }
    
    private func setupTableView(){
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.register(EventTableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    private func updateEvents(){
        tableController.setEvents(events)
        tableView.reloadData()
    }
    
    private func bindViewModel() {
           task = viewModel.$state
               .sink { [weak self] state in
                   switch state{
                   case .loaded(let events):
                       self?.events = events.filter{event in
                           guard let userID = FirebaseHelper.shared.getCurrentUser()?.uid
                           else{
                               return true
                           }
                           return event.users.contains(userID)}
                       self?.updateEvents()
                   case .loading:
                       print("Loading")
                   case .error(let err):
                       print(err)
                   }
                   
               }
           
       }
}

