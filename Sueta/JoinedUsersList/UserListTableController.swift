//
//  EventListTableController.swift
//  Sueta
//
//  Created by Arina Goncharova on 13.07.2023.
//

import Foundation
import UIKit

class UserListTableViewController: UITableViewController{
    
    var users: [User] = []
    
    var userDeleteListener: UserDeleteListener?
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func deleteRow(at index: Int){
        users.remove(at: index)
        tableView.beginUpdates()
                let indexPath = IndexPath(row: index, section: 0)
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.endUpdates()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userCell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! UserCell
        userCell.index = indexPath.row
        userCell.userDeleteListener = userDeleteListener
        userCell.user = users[indexPath.row]
        //        let cellColor = UIColor(red: 253/255.0, green: 250/255.0, blue: 186/255.0, alpha: 1)
        //        eventCell.contentView.backgroundColor = cellColor
        
        
        return userCell
    }
   
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}


