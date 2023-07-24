//
//  MainViewModel.swift
//  Sueta
//
//  Created by Nail Minnemullin on 12.07.2023.
//

import Foundation
import FirebaseFirestore
import Combine

enum State {
    case loading
    case loaded([Event])
    case error(String)
}

class MainViewModel{
    
    @Published var state: State = .loading
    let db = Firestore.firestore()
   
    
    func fetchEvents(){
        PersistentContainer.shared.fetchAllEvents(){ events in
            self.state = .loaded(events)
            FirebaseHelper.shared.readEvents(completion: { events in
                        self.state = .loaded(events)
                        PersistentContainer.shared.save(events: events)
                        
                    })
            
        }
        
    }
    
}
