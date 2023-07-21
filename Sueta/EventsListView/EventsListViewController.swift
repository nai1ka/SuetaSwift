//
//  EventsListViewController.swift
//  Sueta
//
//  Created by Nail Minnemullin on 12.07.2023.
//

import Foundation
import UIKit
import Combine

class EventsListViewController: UIViewController, OnCellClickDelegate {
   
    private var task: AnyCancellable?

    func onCellClick(indexPath: IndexPath) {
        let eventViewController = SingleEventViewController()
        self.present(eventViewController, animated: true)
        eventViewController.event = events[indexPath.row]
        eventViewController.eventChangeListener = userChangeDelegate
    }
    
    var userChangeDelegate: OnEventChangeListener? = nil
    
    
    let tableView = UITableView()
    let tableController = EventListTableViewController()
    var events: [Event] = [] {
        didSet{
            updateEvents()
        }
    }
    
    override func viewDidLoad() {
       
        view.backgroundColor = .systemBackground
        tableView.dataSource = tableController
        tableView.delegate = tableController
        tableController.listViewController = self
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
    
    
}

