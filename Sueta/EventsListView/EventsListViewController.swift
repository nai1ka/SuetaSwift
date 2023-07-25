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
        eventViewController.eventChangeListener = eventChangeDelegate
    }
    
    var eventChangeDelegate: OnEventChangeListener? = nil
    
    
    let refreshControl = UIRefreshControl()
    let tableView = UITableView()
    let tableController = EventListTableViewController()
    var events: [Event] = [] {
        didSet{
            updateEvents()
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
            }
            
        }
    }
    
    override func viewDidLoad() {
       
        navigationController?.navigationBar.isTranslucent = false
        view.backgroundColor = .systemBackground
        tableView.dataSource = tableController
        tableView.delegate = tableController
        tableController.listViewController = self
        setupTableView()
        tableView.reloadData()
      
          refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
          tableView.addSubview(refreshControl)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
          
          // Hide the navigation bar
          navigationController?.setNavigationBarHidden(true, animated: animated)
      
      }
    
    private func setupTableView(){
        view.addSubview(tableView)
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = UIColor.white
        tableView.separatorInset = UIEdgeInsets(top: 40, left: 0, bottom: 40, right: 0)
    
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.register(EventTableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    private func updateEvents(){
        tableController.setEvents(events)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
      
    }
    @objc func refresh(_ sender: AnyObject) {
        eventChangeDelegate?.onEventReload()
    }
    
}

