//
//  SubjectsModel.swift
//  Young Tutors
//
//  Created by Kendall Easterly on 11/18/20.
//

import SwiftUI
import FirebaseFirestore

class SubjectsModel: ObservableObject {
    
    @Published var subjects = [Subject]()
    var db: Firestore!
    var lastDocument: DocumentSnapshot? = nil
    
    init() {
        
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        
        db = Firestore.firestore()
        
    }
    
    func getSubjects() {
        
        db.collection("subjects").order(by: "order").getDocuments { (snapshot, error) in
            
            if let err = error {
                print("error in get subjects \(err)")
            } else {
                
                if let documents = snapshot?.documents {
                    
                    var subjectsArray = [Subject]()
                    
                    for document in documents {
                        
                        let data = document.data()
                        
                        let id = document.documentID
                        let count = data["sessionCount"] as! Int
                        
                        subjectsArray.append(Subject(id: id, count: count))
                        
                    }
                    withAnimation{
                    self.subjects = subjectsArray
                    }
                } else {
                    print("could not get documents in snapshot")
                }
            }
        }
    }
}

struct Subject: Identifiable {
    
    var id: String
    var count: Int
    
}
