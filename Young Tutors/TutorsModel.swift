//
//  TutorsModel.swift
//  Young Tutors
//
//  Created by Kendall Easterly on 11/28/20.
//

import Foundation
import Firebase

class TutorsModel: ObservableObject {
    
    @Published var tutors = [Tutor]()
    var db: Firestore!
    
    init() {
        
        let settings = FirestoreSettings()
        
        Firestore.firestore().settings = settings
        
        db = Firestore.firestore()
        
    }
    
    func getTutors() {
        //when you're retreiving these tutors, you need to have two different versions of each picture that they upload. A small one for the rows in the tutors view, and then the full one or at least bigger for the detail view.
        db.collection("tutors").getDocuments { (snapshot, error) in
            
            if let err = error {
                
                print("there was an error getting tutors \(err.localizedDescription)")
                
            } else {
                
                if let documents = snapshot?.documents {
                    var tutorsArray = [Tutor]()
                    
                    for document in documents {
                        
                        let data = document.data()
                        
                        let name = document.documentID
                        let grade = data["grade"] as? String
                        let email = data["email"] as? String
                        let awards = data["awards"] as? String
                        let bio = data["bio"] as? String
                        let strengths = data["strengths"] as? String
                        let prnouns = data["pronouns"] as? String
                        let gradient = data["gradient"] as! String
                        let times = data["times"] as? [String]
                        let classes = data["classes"] as? [String]
                        
                        
                        let tutor = Tutor(id: name,
                                          grade: grade,
                                          email: email,
                                          bio: bio,
                                          awards: awards,
                                          strengths: strengths,
                                          pronouns: prnouns,
                                          gradient: gradient,
                                          times: times,
                                          classes: classes)
                        
                        tutorsArray.append(tutor)
                    }
                    
                    self.tutors = tutorsArray
                    self.objectWillChange.send()
                    
                } else {
                    print("there was an error retrieving documents")
                }
            }
        }
    } 
}

struct Tutor: Identifiable, Equatable {
    
    var id: String
    var grade: String?
    var email: String?
    var bio: String?
    var awards: String?
    var strengths: String?
    var pronouns: String?
    var gradient: String
    var times: [String]?
    var classes: [String]?
    
    
}
