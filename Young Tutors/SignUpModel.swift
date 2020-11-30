//
//  SignUpModel.swift
//  Young Tutors
//
//  Created by Kendall Easterly on 11/22/20.
//

import SwiftUI
import FirebaseAuth

class SignUpModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var name = ""
    @Published var didFinish = false
    @Published var isTutor = false
    
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
                        }
                    }
                }
            }
        }
    }
}
