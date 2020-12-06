//
//  NotificationsView.swift
//  Young Tutors
//
//  Created by Kendall Easterly on 11/25/20.
//

import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    
    @EnvironmentObject var signUpModel: SignUpModel
    
    var body: some View {
        
        Button(action: {
            do {
                try Auth.auth().signOut()
            } catch {
                print("there was an error signing out")
            }
            
            withAnimation {
                signUpModel.step = .landing
            }
            
        }, label: {
            Text("Log out")
        })
        
    }
}

