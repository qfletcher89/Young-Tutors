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
    @Published var error = " "
    @Published var step: SignUpStep = .landing
    
    var db: Firestore!
    
    init() {
        
        if let user = Auth.auth().currentUser {
            
            if let displayName = user.displayName {
                if displayName.contains("@YOUNGTUTOR:") {
                    isTutor = true
                }
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
                withAnimation(Animation.easeOut(duration: 0.3)) {
                    self.step = .complete
                }
            }
            
        }
    }
    
    func signIn() {
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            if let err = error {
                
                print("ther was an error signing in \(err.localizedDescription)")
                self.error = self.editError(error: err.localizedDescription)
                
            } else {
                withAnimation(Animation.easeOut(duration: 0.3)) {
                    self.step = .complete
                }
            }
            
        }
        
    }
    
    func signUp() {
        
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, erorr) in
            
            if let err = erorr {
                
                print("error signing up user \(err)")
                self.error = self.editError(error: err.localizedDescription)
                
                
            } else {
                if let result = result {
                    
                    let changeRequest = result.user.createProfileChangeRequest()
                    
                    changeRequest.displayName = self.name
                    changeRequest.commitChanges { (error) in
                        
                        if let err = error {
                            print("there was error commitign chages \(err)")
                        } else {
                            withAnimation(Animation.easeOut(duration: 0.3)) {
                                self.step = .complete
                            }
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
    
    private func editError(error: String) -> String {
        
        switch error {
        
        case "There is no user record corresponding to this identifier. The user may have been deleted.":
            return "Couldn't find an account with that email."
        case "The password is invalid or the user does not have a password.":
            return "Wrong password, try again."
        case "The email address is badly formatted.":
            return "Couldn't find an account with that email."
        default:
            return error
        
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
