//
//  EventsListViewController.swift
//  Sueta
//
//  Created by Nail Minnemullin on 12.07.2023.
//

import Foundation
import UIKit
import Combine

class UserListViewController: UIViewController, UserDeleteListener {
    
    
    var eventID: String?
    func onUserWasDeleted(userID: String, index: Int) {
        guard let eventID = eventID else{
            return
        }
        FirebaseHelper.shared.unsubscribe(user: userID, from: eventID)
        tableController.users.remove(at: index)
        tableView.beginUpdates()
        let indexPath = IndexPath(row: index, section: 0)
        tableView.deleteRows(at: [indexPath], with: .fade)
        tableView.endUpdates()
        
       
        
        
    }
    
  
    let tableView = UITableView()
    let tableController = UserListTableViewController()
    var users: [User] = []{
        didSet{
            updateUsers()
        }
    }
    
    override func viewDidLoad() {
        
        view.backgroundColor = .systemBackground
        
        tableView.dataSource = tableController
        tableView.delegate = tableController
        tableController.userDeleteListener = self
        
        setupTableView()
        tableView.reloadData()
        
    }
    
    
    private func setupTableView(){
        view.addSubview(tableView)
        tableView.allowsSelection = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.register(UserCell.self, forCellReuseIdentifier: "userCell")
    }
    
    
    private func updateUsers(){
        tableController.users = users
        tableView.reloadData()
    }
    
    
}

