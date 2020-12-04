//
//  SignUpModel.swift
//  Young Tutors
//
//  Created by Kendall Easterly on 11/22/20.
//

import SwiftUI
import FirebaseAuth
import Firebase

class SignUpModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var name = ""
    @Published var didFinish = false
    @Published var isTutor = false
    @Published var step: SignUpStep = .landing
    
    var db: Firestore!
    
    init() {
        if Auth.auth().currentUser != nil {
            step = .container
            Auth.auth().currentUser?.displayName
        } else {
            step = .landing
        }
        
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        
    }
    
    func signUp() {
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, erorr) in
            
            if let err = erorr {
                
                print("error signing up user \(err)")
                
            } else {
                if let result = result {
                    
                    let changeRequest = result.user.createProfileChangeRequest()

                    changeRequest.displayName = self.name
                    changeRequest.commitChanges { (error) in

                        if let err = error {
                            print("there was error commitign chages \(err)")
                        } else {
                            self.didFinish = true
                            self.step = .done
                            self.db.collection("students")
                                .document(result.user.uid)
                                .setData(["name":self.name,
                                          "email":self.email])
                        }
                    }
                }
            }
        }
    }
}
