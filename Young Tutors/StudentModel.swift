//
//  StudentModel.swift
//  Young Tutors
//
//  Created by Kendall Easterly on 12/2/20.
//

import SwiftUI
import Firebase
import FirebaseAuth

class StudentModel: ObservableObject {
    
    @Published var events = [Event]()
    var db: Firestore!
    
    init() {
        let settings = FirestoreSettings()
        
        Firestore.firestore().settings = settings
        
        db = Firestore.firestore()
        
    }
    
    func getEvents() {
        
        if let profile = Auth.auth().currentUser {
            
            db.collection("events")
                .whereField("studentID", isEqualTo: profile.uid)
                .getDocuments { (snapshot, error) in
                    
                    if let err = error {
                        
                        print("there was an error getting events \(err.localizedDescription)")
                        
                    } else {
                        
                        if let documents = snapshot?.documents {
                            
                            var eventsArray = [Event]()
                            
                            for document in documents {
                                
                                let data = document.data()
                                
                                let tutor = data["tutor"] as! String
                                let time = data["time"] as! String
                                let course = data["class"] as! String
                                let student = data["student"] as! String
                                let studentID = data["studentID"] as! String
                                let email = data["studentEmail"] as! String
                                
                                let event = Event(id: document.documentID, time: time, student: student, studentID: studentID, course: course, tutor: tutor, email: email)
                                
                                eventsArray.append(event)
                            }
                            
                            eventsArray.sort()
                            
                            self.events = eventsArray
                            
                        }
                        
                    }
                    
                }
        }
    }
}

