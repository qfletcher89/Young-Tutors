//
//  StudentSignUp.swift
//  Young Tutors
//
//  Created by Kendall Easterly on 12/4/20.
//

import SwiftUI

struct StudentName: View {
    
    @ObservedObject var model: SignUpModel
    @State var name = ""
    
    var body: some View {
        
        GeometryReader {reader in
            
            VStack {
                
                Spacer()
                
                TextField("Michelle Obama", text: $name).onChange(of: name, perform: { value in
                    
                    withAnimation(Animation.easeInOut(duration: 0.2)) {
                        model.name = value
                    }
                })
                .font(.system(size: 20, weight: .semibold))
                .multilineTextAlignment(.center)
                .padding(.vertical)
                .background(RoundedRectangle(cornerRadius: 30)
                                .stroke())
                .padding(.horizontal)
                
                Spacer()
                
                Button(action: {
//                    withAnimation(Animation.easeOut(duration: 0.3)) {
//                        model.step = .studentEmailPassword
//                    }
                    model.setStep(.studentEmailPassword, .appear)
                }, label: {
                    
                    HStack {
                        
                        Spacer()
                        
                        Image("right")
                    }.overlay(Text("Next")
                                .fontWeight(.semibold)
                                .foregroundColor(model.name == "" ? Color(UIColor.quaternaryLabel) : .white))
                    .padding([.vertical, .trailing], 10)
                    .frame(width: reader.size.width - 40)
                    .background(RoundedRectangle(cornerRadius: 30)
                                    .foregroundColor(model.name == "" ? Color.csdarkGrey.opacity(0.5) : .cswatermelon))
                    
                }).disabled(model.name == "")
                .padding(.bottom, 30)
                
            }.padding(.top)
            .onAppear {
                name = model.name
            }
            .customNavBar(proxy: reader,
                          title: "What's Your Name?", leading:
                            
                            Button(action: {
//                                withAnimation(Animation.easeInOut(duration: 0.2)) {
                                    model.error = " "
                                    model.password = ""
//                                    model.step = .landing
//
//                                }
                                
                                model.setStep(.landing, .disappear)
                                
                            }, label: {
                                AnyView(Image("left"))
                            }))
        }
    }
}

struct StudentEmailPassword: View {
    
    @ObservedObject var model: SignUpModel
    @State var email = ""
    @State var password = ""
    
    var body: some View {
        
        GeometryReader {reader in
            
            VStack {
                
                Spacer()
                
                TextField("Email", text: $email).onChange(of: email, perform: { value in
                    
                    withAnimation(Animation.easeInOut(duration: 0.2)) {
                        model.email = value
                    }
                    
                })
                .font(.system(size: 20, weight: .semibold))
                .multilineTextAlignment(.center)
                .padding(.vertical)
                .background(RoundedRectangle(cornerRadius: 30)
                                .stroke())
                .padding(.horizontal)
                .padding(.bottom, 20)
                
                SecureField("Password", text: $password).onChange(of: password, perform: { value in
                    withAnimation(Animation.easeInOut(duration: 0.2)) {
                        model.password = value
                    }
                })
                .font(.system(size: 20, weight: .semibold))
                .multilineTextAlignment(.center)
                .padding(.vertical)
                .background(RoundedRectangle(cornerRadius: 30)
                                .stroke())
                .padding(.horizontal)
                .padding(.bottom)
                
                Text(model.error)
                    .foregroundColor(.red)
                    .font(.footnote)
                    .multilineTextAlignment(.center)
                
                
                Spacer()
                
                Button(action: {
                    model.signUp()
                }, label: {
                    
                    HStack {
                        
                        Spacer()
                        
                        Image("check-plain")
                    }.overlay(Text("Complete")
                                .fontWeight(.semibold)
                                .foregroundColor(model.email != "" && model.password != "" ? .white : Color(UIColor.quaternaryLabel)))
                    .padding([.vertical, .trailing], 10)
                    .frame(width: reader.size.width - 40)
                    .background(RoundedRectangle(cornerRadius: 30)
                                    .foregroundColor(model.email != "" && model.password != "" ? .cswatermelon : Color.csdarkGrey.opacity(0.5)))
                    
                }).disabled(model.email == "" || model.password == "")
                .padding(.bottom, 30)
                
            }.padding(.top)
            .onAppear {
                email = model.email
                password = model.password
            }
            .customNavBar(proxy: reader,
                          title: "Email & Password", leading:
                            
                            Button(action: {
//                                withAnimation(Animation.easeInOut(duration: 0.2)) {
                                    model.error = " "
                                    model.password = ""
//                                    model.step = .studentName
//                            }
                                model.setStep(.studentName, .disappear)
                                
                            }, label: {
                                AnyView(Image("left"))
                            }))
        }
    }
    
}
