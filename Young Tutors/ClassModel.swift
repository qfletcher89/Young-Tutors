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
                        
                        var sessionDictionary = [String:[String]]()
                        
                        for object in data {
                            
                            if let sessions = object.value as? [String] {
                                
                                sessionDictionary[object.key] = sessions
                                
                            }
                        }
                        
                        var sessionArray = [Session]()
                        
                        for session in sessionDictionary {
                            
                            let id = session.key
                            let tutors = session.value
                            let day = id[0]
                            let protoTime = id.substring(fromIndex: 1)
                            
                            let time1 = protoTime[0]
                            let time2 = protoTime.substring(fromIndex: 1)
                            let time = time1 + ":" + time2
                            
                            if !tutors.isEmpty {
                                
                                let session = Session(id: id,
                                                      day: day.description,
                                                      time: time.description,
                                                      tutors: tutors)
                                
                                sessionArray.append(session)
                            }
                        }
                        
                        sessionArray.sort()
                        
                        classArray.append(Class(id: document.documentID, name: name, levels: levels, sessions: sessionArray, subject: subject.id))
                        
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
    var subject: String
    
}

struct Session: Identifiable, Comparable {
    static func < (lhs: Session, rhs: Session) -> Bool {
        return lhs.id < rhs.id
    }
    
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


///For the handling of the session methods
extension ClassModel {
    
    func createSession(at time: String, with tutor: String, subject: Subject, course: Class) {
        
        let funcCourse = subject.id + "-" + course.id
        
        if let profile = Auth.auth().currentUser {
            var email = "not-found"
            var name = "not-found"
            
            if let funcEmail = profile.email {
                email = funcEmail
            }
            
            if let funcName = profile.displayName {
                name = funcName
            }
            
            db.collection("events").addDocument(data: ["student": name,
                                                       "studentID": profile.uid,
                                                       "sstudentEmail":email,
                                                       "time":time,
                                                       "tutor":tutor,
                                                       "class":funcCourse])
            
            db.collection("subjects")
                .document(subject.id)
                .collection("classes")
                .document(course.id)
                .setData([time:FieldValue.arrayRemove([tutor])], merge: true)
        }
    }
}
