//
//  TestModel.swift
//  Young Tutors
//
//  Created by Kendall Easterly on 11/18/20.
//

import Foundation
import FirebaseFirestore

class TestModel: ObservableObject {
    
    @Published var subjects = [Subject]()
    @Published var classes = [Class]()
    var db: Firestore!
    
    init() {
        
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        
        db = Firestore.firestore()
        
    }
    
    func getSubjects() {
        
        db.collection("subjects").getDocuments { (snapshot, error) in
            
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
                    
                    self.subjects = subjectsArray
                    
                } else {
                    print("could not get documents in snapshot")
                }
                
            }
            
        }
        
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
                        
                        let sessions = data["sessions"] as! [String: [String]]
                        let name = data["name"] as! String
                        let levels = data["levels"] as! String
                        
                        var sessionArray = [Session]()
                        
                        for session in sessions {
                            
                            let time = session.key
                            let tutors = session.value
                            
                            sessionArray.append(Session(id: time, tutors: tutors))
                            
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

