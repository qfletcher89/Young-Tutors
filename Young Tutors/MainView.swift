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
        case .studentEmailPassword:
            StudentEmailPassword(model: model)
        case .tutorSignIn:
            TutorSignInView(model: model)
        case .logIn:
            LogInView(model: model)
        case .complete:
            CompleteView(model: model)
        case .container:
            if !model.isTutor {
                ContainerView().environmentObject(model)
            } else {
                TutorContainerView().environmentObject(model)
            }
        }
        
    }
}

struct LandingScreen: View {
    //make a series of if step is da, do da. no more navigation view with these guys. make an enumeration for which step we're on
    var model: SignUpModel
    
    var body: some View {
        
        GeometryReader{ reader in
            VStack {
                
                Spacer()
                
                Image("logo-with-words")
                
                Spacer()
                
                Text("Tutoring Made Simple.")
                    
                    .font(.system(size: 32, weight: .thin, design: .rounded))
                    .padding(.bottom, 50)
                
                Button(action: {
                    withAnimation {
                    model.step = .studentName
                    }
                }, label: {
                    
                    HStack {
                        
                        Spacer()
                        
                        Image("right")
                    }.overlay(Text("I'm a Student")
                                .fontWeight(.semibold)
                                .foregroundColor(.white))
                    .padding([.vertical, .trailing], 10)
                    .frame(width: reader.size.width - 40)
                    .background(RoundedRectangle(cornerRadius: 30)
                                    .foregroundColor(self.cs().watermelon))
                    
                }).padding(.bottom, 20)
                
                Button(action: {
                    withAnimation {
                    model.step = .tutorSignIn
                    }
                }, label: {
                    
                    HStack {
                        
                        Spacer()
                        
                        Image("right")
                    }.overlay(Text("I'm a Tutor")
                                .fontWeight(.semibold)
                                .foregroundColor(Color(UIColor.label)))
                    .padding([.vertical, .trailing], 10)
                    .frame(width: reader.size.width - 40)
                    .background(RoundedRectangle(cornerRadius: 30)
                                    .stroke()
                                    .foregroundColor(Color(UIColor.label)))
                    
                }).padding(.bottom, 30)
                
                HStack {
                    
                    Text("Already a member?")
                    
                    Button(action: {
                        withAnimation {
                        model.step = .logIn
                        }
                    }, label: {
                        Text("Sign in.")
                            .foregroundColor(self.cs().watermelon)
                    })
                    
                }
                
                Spacer()
                
                HStack(spacing: 5) {
                    Text("By signing up, you agree to our")
                    Button(action: {
                        //open webview to terms of sevice
                    }, label: {
                        Text("Terms of Service")
                            .foregroundColor(self.cs().watermelon)
                    })
                    Text("and")
                }.font(.footnote)
                
                HStack(spacing: 5) {
                    Text("acknowledge that our")
                    Button(action: {
                        //navigate to privacy policy
                    }, label: {
                        Text("Privacy Policy")
                            .foregroundColor(self.cs().watermelon)
                    })
                    Text("applies to you.")
                }.padding(.bottom, 30)
                .font(.footnote)
                
            }.centered()
        }
        
    }
}


struct CompleteView: View {
    
    @ObservedObject var model: SignUpModel
    
    var body: some View {
        
        Text("You're all set!")
            .font(.largeTitle)
            .bold()
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation{
                        withAnimation {
                        model.step = .container
                        }
                    }
                }
            }
    }
}
