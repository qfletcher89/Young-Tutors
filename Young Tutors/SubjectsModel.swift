//
//  SubjectsModel.swift
//  Young Tutors
//
//  Created by Kendall Easterly on 11/18/20.
//

import SwiftUI
import FirebaseFirestore

class SubjectsModel: ProgressHudActivator {
    
    //ur gonna need to make an object to handle your hud
    @Published var subjects = [Subject]()
    
    func getSubjects() {
        
        super.activate()
        
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
                    
                    super.deactivateHud()
                    super.success()
                    
                    withAnimation(Animation.easeOut(duration: 0.5)){
                        self.subjects = subjectsArray
                    }
                    
                } else {
                    super.error()
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
