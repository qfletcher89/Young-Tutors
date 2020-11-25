//
//  ClassesModel.swift
//  Young Tutors
//
//  Created by Kendall Easterly on 11/18/20.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class ClassModel: ObservableObject {
    
    @Published var classes = [Class]()
    var db: Firestore!
    
    init() {
        
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        
        db = Firestore.firestore()
        
    }
    
    func getClasses(for subject: Subject, handler: @escaping ([Class]) -> Void) {
        
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
                                
                                let id = session.key
                                let tutors = session.value
                                let time = id.split(separator: "-").last!
                                let day = id.split(separator: "-").first!
                                
                                let session = Session(id: id,
                                                      day: day.description,
                                                      time: time.description,
                                                      tutors: tutors)
                                
                                sessionArray.append(session)
                                
                            }
                        }
                        
                        classArray.append(Class(id: document.documentID, name: name, levels: levels, sessions: sessionArray))
                        
                    }
                    handler(classArray)
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
    var day: String
    var time:String
    var tutors: [String]
    var selectedTutor: String
    
    init(id: String,
         day: String,
         time:String,
         tutors: [String]) {
        
        self.id = id
        self.day = day
        self.time = time
        self.tutors = tutors
        self.selectedTutor = tutors.first!
        
    }
    
}

//temp create session
extension ClassModel {
    
    func createSession(at time: String, with tutor: String) {
        
        if let profile = Auth.auth().currentUser {
        db.collection("events").addDocument(data: ["isCompleted": false,
                                                   "student": profile.uid,
                                                   "time":time,
                                                   "tutor":tutor])
        }
    }
    
}
