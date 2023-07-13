//
//  NewEventViewController.swift
//  Sueta
//
//  Created by Nail Minnemullin on 13.07.2023.
//

import Foundation
import UIKit

class NewEventViewController: UIViewController{
    
    private final let segmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl(items: ["One", "Two", "Three"])
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.selectedSegmentIndex = 0
        return segmentControl
    }()
    
  //  private final let 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews(){
        view.backgroundColor = .systemBackground
        view.addSubview(segmentControl)
        segmentControl.topAnchor.constraint(equalTo: view.topAnchor, constant: 16).isActive = true
        segmentControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        segmentControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
    }
    
    
}
