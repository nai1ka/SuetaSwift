//
//  EventListTableController.swift
//  Sueta
//
//  Created by Arina Goncharova on 13.07.2023.
//

import Foundation
import UIKit

class EventListTableViewController: UITableViewController{
    
    var events: [Event] = []
    var cellDelegate: OnCellClickDelegate?
    
    var listViewController: OnCellClickDelegate?
   
    
    func setEvents(_ events: [Event]){
        self.events = events
    }
    
  
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let eventCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EventTableViewCell
        eventCell.event = events[indexPath.row]
        
        return eventCell
    }
    override  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        listViewController?.onCellClick(indexPath: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}

protocol OnCellClickDelegate {
    func onCellClick(indexPath: IndexPath)
}
