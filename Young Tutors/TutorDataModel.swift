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
    @Published var bookedTimes = [String]()
    
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
        
    }
    
    ///To be called in the on appeaer of the times view
    func getBookedTimes() {
        
        //Filter all the events, only the ones where the tutor field is our tutor. Then, extract the time and put it in our bookedTimes value.
        
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
    
    func uploadData() {
        
        let data = [
            ["awards":"N/A","pronouns":"He / Him / His","strengths":"Math and Spanish","name":"Adrian Rivera","grade":"10 / Junior","bio":"Hey, I’m Adrián. I’ve lived on the South Side of Chicago my entire life, and I’ve attended WY since 7th grade. Math has always been one of my strong suits because of the objective and procedural nature of the subject, not like being graded on writing, although I do like to write in my free time. I’ve learned Spanish also since I was a little kid since it’s most of my family’s first/preferred language. I’ve always liked helping people, and I’ve been helping my little brother with his homework for a while now, so I thought tutoring would be a good fit for me.","email":"cnrivera1@cps.edu"],
            ["awards":"I haven’t received any awards but I was recently accepted into the University of Cambridge’s creative writing summer program (though I had to defer to next year due to the pandemic). ","pronouns":"She / Her / Hers","strengths":"Math and Science","name":"Amie Kitjasateanphun ","grade":"10 / Sophomore","bio":"Amie is a sophomore who really likes math and science, especially anatomy. Currently, she is learning AP Physics and AP Biology. Her hobbies include reading, drawing, baking, and doing arts and crafts. She hopes to go into the healthcare field in the future and become a physician. She is a part of the Whitney Young Math Team, Whitney Young Science Olympiad, and a violinist in the Whitney Young Symphony Orchestra.","email":"akitjasatea@cps.edu"],
            ["awards":"N/A","pronouns":"She / Her / Hers","strengths":"English, Social Studies, PE","name":"Kimmy Vu-Smith","grade":"12 / Senior","bio":"I’m Kimmy and I’m a senior! I am a Varsity Cheerleader and also Vice-President of our school’s Best Buddies chapter. I am interested in social justice activism, reading, fashion, and other quirky things. I spend most of my time working, hanging out with my friends, and tutoring/babysitting on the side. I used to struggle when reaching out for help, but once I started to reach out, I benefited so much, so I hope to help other student’s reach that point!!","email":"kvu-smith@cps.edu"],
            ["awards":"N/A","pronouns":"She / Her / Hers","strengths":"World Language","name":"Wendy Wang","grade":"11 / Junior","bio":"Hi! I'm Wendy, a current junior and former academic center student, and I'm currently the teaching assistant (senpai-sensei as officially referred to) for J2. I have completed all four years of Japanese and passed the AP exam, and consider both teaching and Japanese as my passions, making this the perfect opportunity for me to help others and enjoy it at the same time. I love drawing and playing video games, and I promise I don't bite :). I'm very easy to talk to and will never judge any student for mistakes in their work.","email":"wwang5@cps.edu"],
            ["awards":"N/A","pronouns":"She / Her / Hers","strengths":"Math","name":"Meg Li ","grade":"12 / Senior","bio":"Hi! My name is Meg, and I’m currently a senior. In school I’m involved in AAC and Science Olympiad, and something I do outside of school is figure skating. In my free time I like to occasionally read and I’ve recently started trying to cook/bake. I love playing card games and organizing things in my spare time. I’ll do my best to be a good tutor, so feel free to ask me anything!","email":"mli7@cps.edu"]]
        
        var count = 0
        
        for tutor in data {
            
            guard let name = tutor["name"] else {
                print("there was an issue with \(count)")
                return
            }
            
            guard let awards = tutor["awards"] else {
                print("there was an issue with \(count)")
                return
            }
            
            guard let pronouns = tutor["pronouns"] else {
                print("there was an issue with \(count)")
                return
            }
            
            guard let bio = tutor["bio"] else {
                print("there was an issue with \(count)")
                return
            }
            
            guard let email = tutor["email"] else {
                print("there was an issue with \(count)")
                return
            }
            
            guard let strengths = tutor["strengths"] else {
                print("there was an issue with \(count)")
                return
            }
            
            guard let grade = tutor["grade"] else {
                print("there was an issue with \(count)")
                return
            }
            
            db.collection("tutors")
                .document(name)
                .setData(["grade":grade,
                          "pronouns":pronouns,
                          "bio":bio,
                          "strengths":strengths,
                          "email":email,
                          "awards":awards], merge: true)
            
            count = count + 1
            print(name)
        }
    }
    
}
