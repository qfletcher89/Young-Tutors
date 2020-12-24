//
//  LogInView.swift
//  Young Tutors
//
//  Created by Kendall Easterly on 12/4/20.
//

import SwiftUI

struct LogInView: View {
    
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
                
                Text(model.error)
                    .foregroundColor(.red)
                    .font(.footnote)
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                Button(action: {
                    
                        model.signIn()
                    
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
                    
                }).padding(.bottom, 30)
                .disabled(model.email == "" || model.password == "")
                
            }.onAppear {
                email = model.email
                password = model.password
            }
            .customNavBar(proxy: reader, title: "Enter Credentials", leading: Button(action: {
//                withAnimation(Animation.easeInOut(duration: 0.2)) {
                    model.error = " "
                    model.password = ""
//                model.step = .landing
//
//                }
                model.setStep(.landing, .disappear)
            }, label: {
                AnyView(Image("left"))
            }))
        }
        
    }
}
