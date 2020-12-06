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
    @Published var isTutor = false
    @Published var error = ""
    @Published var step: SignUpStep = .landing
    
    var db: Firestore!
    
    init() {
        
        if let user = Auth.auth().currentUser {
            if user.displayName == "tutor" {
                isTutor = true
            }
            
            step = .container
            
        } else {
            step = .landing
        }
        
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        
    }
    
    func signInTutor() {
        let actionCodeSettings = ActionCodeSettings()
        actionCodeSettings.url = URL(string: "https://kendalleasterly.page.link")
        actionCodeSettings.handleCodeInApp = true
        actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)
        
        Auth.auth().sendSignInLink(toEmail: email, actionCodeSettings: actionCodeSettings) { error in
            
            if let err = error {
                print("there was an error signing in tutor \(err) ")
            } else {
                print("successful")
                withAnimation {
                self.step = .complete
                }
            }
            
        }
    }
    
    func signIn() {
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            if let err = error {
                
                print("ther was an error signing in \(err.localizedDescription)")
                self.error = err.localizedDescription
                
            } else {
                withAnimation {
                self.step = .complete
                }
            }
            
        }
        
    }
    
    func signUp() {
        
        
            Auth.auth().createUser(withEmail: email, password: password) { (result, erorr) in
            
                if let err = erorr {
                    
                    print("error signing up user \(err.localizedDescription)")
                    self.error = err.localizedDescription
                } else {
                    if let result = result {
                        
//                        let changeRequest = result.user.createProfileChangeRequest()

//                        changeRequest.displayName = self.name
//                        changeRequest.commitChanges { (error) in

//                            if let err = error {
//                                print("there was error commitign chages \(err)")
//                            } else {
                        withAnimation {
                                self.step = .complete
                        }
                                self.db.collection("students")
                                    .document(result.user.uid)
                                    .setData(["name":self.name,
                                              "email":self.email])
//                            }
//                        }
                    }
                }
            }
        
        
    }
}

enum SignUpStep {
    
    case landing
    
    case studentName
    case studentEmailPassword
    
    case tutorSignIn
    
    case logIn
    
    case complete
    case container
    
}
