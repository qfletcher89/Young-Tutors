//
//  LandingScreen.swift
//  Young Tutors
//
//  Created by Kendall Easterly on 11/22/20.
//

import SwiftUI

struct LandingScreen: View {
    //make a series of if step is da, do da. no more navigation view with these guys. make an enumeration for which step we're on
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
            }.navigationBarTitle(Text(""))
            .navigationBarHidden(true)
            
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
            
        }.navigationBarTitle(Text(""))
        .navigationBarHidden(true)
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
            
        }.navigationBarTitle(Text(""))
        .navigationBarHidden(true)
    }

}


struct DoneView: View {
    
    @State var containerViewActive = false
    
    var body: some View {
        
        if !containerViewActive {
            Text("You're all set!")
                .font(.largeTitle)
                .bold()
                .navigationBarTitle(Text(""))
                .navigationBarHidden(true)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        withAnimation{
                        containerViewActive = true
                        }
                    }
                    
                }
        } else {
            //here, you would do a conditonal property asking wheter or not this is a tutor signing up or a student. conteinre view or tutorn contonter viwe
            ContainerView()
                
        }
        
        
    }
    
}
