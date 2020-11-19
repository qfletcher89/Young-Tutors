//
//  ClassesModel.swift
//  Young Tutors
//
//  Created by Kendall Easterly on 11/18/20.
//

import Foundation
import FirebaseFirestore

class ClassesModel: ObservableObject {
    
    @Published var classes = [Class]()
    var db: Firestore!
    
    init() {
        
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        
        db = Firestore.firestore()
        
    }
    
    func getClasses(for subject: Subject) {
        
        db.collection("subjects").document(subject.id).collection("classes").getDocuments { (snapshot, error) in
            
            if let err = error {
                
                print("error in get classes \(err)")
                
            } else {
                
                if let documents = snapshot?.documents {
                    
                    var classArray = [Class]()
                    
                    for document in documents {
                        
                        let data = document.data()
                        
                        
                        let name = data["name"] as! String
                        let levels = data["levels"] as! String
                        
                        var sessionArray = [Session]()
                        
                        if let sessions = data["sessions"] as? [String: [String]] {
                            for session in sessions {
                                
                                let time = session.key
                                let tutors = session.value
                                
                                sessionArray.append(Session(id: time, tutors: tutors))
                                
                            }
                        }
                        
                        classArray.append(Class(id: document.documentID, name: name, levels: levels, sessions: sessionArray))
                        
                        
                        
                    }
                    
                    self.classes = classArray
                    
                } else {
                    print("couldn't get documents in get classes")
                }
            }
        }
    }
}

struct Class: Identifiable {
    
    var id: String
    var name: String
    var levels: String
    var sessions: [Session]
    
}

struct Session: Identifiable {
    
    var id: String
    var tutors: [String]
    
}
