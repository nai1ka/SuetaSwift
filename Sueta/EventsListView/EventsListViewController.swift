//
//  EventsListViewController.swift
//  Sueta
//
//  Created by Nail Minnemullin on 12.07.2023.
//

import Foundation
import UIKit

class EventsListViewController: UIViewController {
    
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
        setupTableView()
        tableView.reloadData()
        
    }
    
    func setupTableView(){
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.register(EventTableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func updateEvents(){
        tableController.setEvents(viewModel.events.value)
        tableView.reloadData()
    }
}

