//
//  MainViewModel.swift
//  Sueta
//
//  Created by Nail Minnemullin on 12.07.2023.
//

import Foundation
import Bond
import FirebaseFirestore


class MainViewModel{
    
    let events = Observable<[Event]>([])
    let error = Observable<Error?>(nil)
    let db = Firestore.firestore()
   
    
    func fetchEvents(){
        FirebaseHelper.shared.readEvents(completion: { events in
            self.events.value = events
            
        })
    }
    
}
