//
//  LandingScreen.swift
//  Young Tutors
//
//  Created by Kendall Easterly on 11/22/20.
//

import SwiftUI

struct MainView: View {
    
    @ObservedObject var model = SignUpModel()
    
    var body: some View {
        
        switch model.step {
        
        case .landing:
            LandingScreen(model: model)
        case .studentName:
            StudentName(model: model)
        case .tutor:
            TutorSignUpView(model: model)
        case .studentEmailPassword:
            StudentEmailPassword(model: model)
        case .container:
            if model.isTutor {
                TutorContainerView()
            } else {
                ContainerView()
            }
        case .done:
            DoneView(model: model)
        }
        
    }
}

struct LandingScreen: View {
    //make a series of if step is da, do da. no more navigation view with these guys. make an enumeration for which step we're on
    var model: SignUpModel
    
    var body: some View {
        
            VStack {
                
                Text("Tutoring made simple.")
                    .bold()
                    .multilineTextAlignment(.center)
                    .font(.largeTitle)
                
                Spacer()
                
                Button {
                    model.step = .studentName
                } label: {
                    Text("I'm a student")
                }

                Button {
                    model.step = .tutor
                } label: {
                    Text("I'm a tutor")
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
            
            Button {
                model.step = SignUpStep.studentEmailPassword
            } label: {
                Text("Next")
                    .padding(.vertical)
                    .padding(.horizontal, 20)
                    .background(RoundedRectangle(cornerRadius: 30))
            }
            
            
            Spacer()
            
        }
    }
}

struct TutorSignUpView: View {
    
    @ObservedObject var model: SignUpModel
    
    var body: some View {
        
        Text("im a tutor")
        
    }
}

struct StudentEmailPassword: View {
    
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
            
            
        }.navigationBarTitle(Text(""))
        .navigationBarHidden(true)
    }

}


struct DoneView: View {
    
    @ObservedObject var model: SignUpModel
    
    
    var body: some View {
        
        
            Text("You're all set!")
                .font(.largeTitle)
                .bold()
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        withAnimation{
                            model.step = .container
                        }
                    }
                    
                }
    }
    
}

enum SignUpStep {
    
    case landing
    
    case studentName
    case studentEmailPassword
    
    case tutor
    
    case done
    case container
    
}
