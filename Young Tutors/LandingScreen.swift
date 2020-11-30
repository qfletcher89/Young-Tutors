//
//  LandingScreen.swift
//  Young Tutors
//
//  Created by Kendall Easterly on 11/22/20.
//

import SwiftUI

struct LandingScreen: View {
    
    var model = SignUpModel()
    
    var body: some View {
        NavigationView {
            VStack {
                
                Text("Tutoring made simple.")
                    .bold()
                    .multilineTextAlignment(.center)
                    .font(.largeTitle)
                
                Spacer()
                
                NavigationLink(destination: StudentName(model: model)) {
                    Text("I'm a student")
                }
                
                NavigationLink(destination: Text("i'm a tutor")) {
                    Text("I'm a tutor")
                    //make sure to set the property in your sign up model to true saying that this is a tutor.
                }.padding(.bottom, 20)
            }
            
        }
    }
}

struct StudentName: View {
    
    @ObservedObject var model: SignUpModel
    @State var name = ""
    
    var body: some View {
        
        VStack {
            Text("First, lets start off with your name")
                .bold()
                .multilineTextAlignment(.center)
                .font(.largeTitle)
            
            
            Spacer()
            
            
            TextField("Michelle Obama", text: $model.name)
            
            NavigationLink(destination: StudentEmail(model: model)) {
                
                Text("Next")
                    .padding(.vertical)
                    .padding(.horizontal, 20)
                    .background(RoundedRectangle(cornerRadius: 30))
                
            }
            
            
            Spacer()
            
        }
    }
    
}

struct StudentEmail: View {
    
    @ObservedObject var model: SignUpModel
    @State var email = ""
    @State var password = ""
    var body: some View {
        
        VStack {
            Text("Email and password?")
                .bold()
                .multilineTextAlignment(.center)
                .font(.largeTitle)
            
            
            Spacer()
            
            TextField("michelleobama@cps.edu", text: $email)
            
            SecureField("obama0816", text: $password)
                
            
            Button {
                model.email = email
                model.password = password
                model.signUp()
            } label: {
                Text("Done")
                    .padding(.vertical)
                    .padding(.horizontal, 20)
                    .background(RoundedRectangle(cornerRadius: 30))
            }
            
            Spacer()
            
            
            NavigationLink(destination: DoneView(), isActive: $model.didFinish) {EmptyView()}
            
        }
    }

}


struct DoneView: View {
    
    @State var navLinkIsActive = false
    
    var body: some View {
        
        Text("You're all set!")
            .font(.largeTitle)
            .bold()
            .background(NavigationLink(destination: ContainerView(), isActive: $navLinkIsActive, label: {
                EmptyView()
            }))
            .navigationBarBackButtonHidden(true)
            .onAppear {
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    navLinkIsActive = true
                }
                
            }
        
    }
    
}
