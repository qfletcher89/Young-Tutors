//
//  TutorClassesModel.swift
//  Young Tutors
//
//  Created by Kendall Easterly on 11/27/20.
//

import Foundation
import Firebase

class TutorDataModel: ObservableObject {
    
    @Published var classes = [Class]()
    @Published var times = [String]()
    @Published var events = [Event]()
    
    var db: Firestore!
    var tutor = "kendall"
    
    init() {
        
        let settings = FirestoreSettings()
        
        Firestore.firestore().settings = settings
        
        db = Firestore.firestore()
        
    }
    
    ///To be called in the on appear of the container view
    func getData() {
        
        //get the firebase object for this tutor
        db.collection("tutors").document(tutor).getDocument { (snapshot, error) in
            if let err = error {
                print("there was error getting data \(err.localizedDescription)")
            }
            
            if let data = snapshot?.data() {
                
                if let times = data["times"] as? [String] {
                    
                    self.times = times
                    self.objectWillChange.send()
                    
                }
                
                if let classes = data["classes"] as? [String] {
                    
                    var classArray = [Class]()
                    
                    for course in classes {
                        
                        let id = String(course.split(separator: "-").last!)
                        let subject = String(course.split(separator: "-").first!)
                        
                        if id.starts(with: "RH") {
                            
                            let name = id.replacingOccurrences(of: "RH", with: "")
                            
                            classArray.append(Class(id: id, name: name.capitalized, levels: "R & H", sessions: [Session](), subject: subject))
                            
                        } else if id.starts(with: "AP") {
                            
                            let name = id.replacingOccurrences(of: "AP", with: "")
                            
                            classArray.append(Class(id: id, name: name.capitalized, levels: "AP", sessions: [Session](), subject: subject))
                            
                        } else if id.starts(with: "H") {
                            
                            let name = id.replacingOccurrences(of: "H", with: "")
                            
                            classArray.append(Class(id: id, name: name.capitalized, levels: "H", sessions: [Session](), subject: subject))
                        } else if id.starts(with: "KAMI") {
                            
                            let name = id.replacingOccurrences(of: "KAMI", with: "")
                            
                            classArray.append(Class(id: id, name: name.capitalized, levels: "KAMI", sessions: [Session](), subject: subject))
                        } else if id.starts(with: "KAMII") {
                            
                            let name = id.replacingOccurrences(of: "KAMII", with: "")
                            
                            classArray.append(Class(id: id, name: name.capitalized, levels: "KAMII", sessions: [Session](), subject: subject))
                        }
                    }
                    
                    self.classes = classArray
                }
                
            } else {
                print("there was no data")
            }
        }
        //Update our values in this class
        
        self.getBookedTimes()
        
    }
    
    ///To be called in the on appeaer of the times view
    func getBookedTimes() {
        
        //Filter all the events, only the ones where the tutor field is our tutor. Then, extract the time and put it in our bookedTimes value.
        
        db.collection("events")
            .whereField("tutor", isEqualTo: tutor)
            .getDocuments { (snapshot, erorr) in
                
                if let err = erorr {
                    
                    print("ther was an error getting the booked times \(err)")
                    
                } else {
                    
                    if let documents = snapshot?.documents {
                        
                        var eventsArray = [Event]()
                        
                        for document in documents {
                            
                            let data = document.data()
                            
                            let student = data["student"] as! String
                            let time = data["time"] as! String
                            let studentID = data["studentID"] as! String
                            let studentEmail = data["studentEmail"] as! String
                            let course = data["class"] as! String
                            
                            let event = Event(id: document.documentID, time: time, student: student, studentID: studentID, course: course, tutor: self.tutor, email: studentEmail)
                            
                            eventsArray.append(event)
                            
                        }
                        
                        eventsArray.sort()
                        
                        self.events = eventsArray
                        
                    }
                }
            }
    }
    
    func saveClasses(classes: [Class]) {
        if !classes.isEmpty {
            //inject it into my account
            
            var classStrings = [String]()
            
            for course in classes {
                
                let id = course.subject + "-" + course.id
                classStrings.append(id)
            }
            
            db.collection("tutors")
                .document(tutor)
                .setData(["classes":FieldValue.arrayUnion(classStrings)], merge: true)
            
            var sessions = [String:FieldValue]()
            
            for time in self.times {
                
                sessions[time] = FieldValue.arrayUnion([tutor])
                //              sessions[time] = FieldValue.arrayRemove([tutor])
                
            }
            
            //inject my name into the sessions for these classes
            for course in classes {
                db.collection("subjects")
                    .document(course.subject)
                    .collection("classes")
                    .document(course.id)
                    .setData(sessions, merge: true)
            }
            
        }
    }
    
    func deleteClasses(classes: [Class]) {
        
        
        if !classes.isEmpty {
            //update my account
            var classStrings = [String]()
            
            for course in classes {
                
                let id = course.subject + "-" + course.id
                classStrings.append(id)
            }
            
            db.collection("tutors")
                .document(tutor)
                .setData(["classes":FieldValue.arrayRemove(classStrings)], merge: true)
            
            var sessions = [String:FieldValue]()
            
            for time in self.times {
                
                sessions[time] = FieldValue.arrayRemove([tutor])
                //              sessions[time] = FieldValue.arrayUnion([tutor])
                
            }
            
            //remove my name from the sessions in these classes
            for course in classes {
                db.collection("subjects")
                    .document(course.subject)
                    .collection("classes")
                    .document(course.id)
                    .setData(sessions, merge: true)
            }
            
        }
        
    }
    
    func saveTimes(times: [String]) {
        
        //inject my name for the new time into all of my classes
        //inject it into my account
        
        if !times.isEmpty {
            
            db.collection("tutors")
                .document(tutor)
                .setData(["times":FieldValue.arrayUnion(times)], merge: true)
            
            var sessions = [String:FieldValue]()
            
            for time in times {
                
                sessions[time] = FieldValue.arrayUnion([tutor])
                //              sessions[time] = FieldValue.arrayRemove([tutor])
                
            }
            
            
            for course in classes {
                
                db.collection("subjects")
                    .document(course.subject)
                    .collection("classes")
                    .document(course.id)
                    .setData(sessions, merge: true)
                
            }
            
        }
        
    }
    
    func removeTimes(times: [String]) {
        
        db.collection("tutors")
            .document(tutor)
            .setData(["times":FieldValue.arrayRemove(times)], merge: true)
        
        var sessions = [String:FieldValue]()
        
        for time in times {
            
            sessions[time] = FieldValue.arrayRemove([tutor])
            
            
        }
        
        for course in classes {
            
            db.collection("subjects")
                .document(course.subject)
                .collection("classes")
                .document(course.id)
                .setData(sessions, merge: true)
            
        }
    }
    
    func signOut(_ completion: @escaping ()-> Void) {
        
        do {
            try Auth.auth().signOut()
            completion()
        } catch {
            print("there was an issue signing out")
        }
    }
    
}

struct Event: Identifiable, Comparable {
    
    static func < (lhs: Event, rhs: Event) -> Bool {
        return lhs.time < rhs.time
    }
    
    var id: String
    var time: String
    var student: String
    var studentID: String
    var course: String
    var tutor: String
    var email: String
    
}
