//
//  ClassesModel.swift
//  Young Tutors
//
//  Created by Kendall Easterly on 11/18/20.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

class ClassModel: ProgressHudActivator {
    
    @Published var classes = [Class]()
    
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
    
    func createSession(at time: String, with tutor: String, using model: TutorsModel, subject: Subject, course: Class, completion: @escaping () -> Void) {
        
        super.activate()
        
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
            
            //create the event
            db.collection("events").addDocument(data: ["student": name,
                                                       "studentID": profile.uid,
                                                       "studentEmail":email,
                                                       "time":time,
                                                       "tutor":tutor,
                                                       "class":funcCourse]) { (error) in
                if let err = error {
                    super.error()
                    print("there was an error adding the event \(err.localizedDescription)")
                } else {
                    super.success()
                    completion()
                }
            }
            
            //remove the time from all of the tutor's classes
            if let classes = getTutorFromID(model: model, tutorID: tutor).classes {
                print(classes)
                for course in classes {
                    print("on \(course)")
                    let forInSubject = String(course.split(separator: "-").first!)
                    let forInCourse = String(course.split(separator: "-").last!)
                    
                    print(forInCourse)
                    print(forInSubject)
                    
                    db.collection("subjects")
                        .document(forInSubject)
                        .collection("classes")
                        .document(forInCourse)
                        .setData([time:FieldValue.arrayRemove([tutor])], merge: true)
                    
                }
            }
            
//            db.collection("subjects")
//                .document(subject.id)
//                .collection("classes")
//                .document(course.id)
//                .setData([time:FieldValue.arrayRemove([tutor])], merge: true)
        }
    }
    
    private func getTutorFromID(model: TutorsModel, tutorID: String) -> Tutor {
        
        var funcTutor = Tutor(id: "", grade: nil, email: nil, bio: nil, awards: nil, strengths: nil, pronouns: nil, gradient: "", times: nil, classes: nil)
        
        for tutor in model.tutors {
            
            if tutor.id == tutorID {
                funcTutor = tutor
            }
            
        }
        
        return funcTutor
        
    }
    
}

struct Class: Identifiable {
    
    var id: String
    var name: String
    var levels: String
    var sessions: [Session]
    var subject: String
    
    init(id: String,
         name: String,
         levels: String,
         sessions: [Session],
         subject: String) {
        
        self.id = id
        self.levels = levels
        self.sessions = sessions
        self.subject = subject
        
        var funcName = name.capitalized
        if funcName.contains("Iii") {
            print(funcName + "contained Iii")
            funcName = funcName.replacingOccurrences(of: "Iii", with: "III")
        } else if funcName.contains("Ii") {
            print(funcName + "contained Ii")
            funcName = funcName.replacingOccurrences(of: "Ii", with: "II")
        }
        
        self.name = funcName
        
    }
}
