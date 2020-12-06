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
                TextField("Email", text: $model.email).onChange(of: email, perform: { value in
                    withAnimation {
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
                
                SecureField("Password", text: $model.password).onChange(of: password, perform: { value in
                    withAnimation {
                        model.password = value
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
                                    .foregroundColor(model.email != "" && model.password != "" ? self.cs().watermelon : self.cs().darkGrey.opacity(0.5)))
                    
                }).padding(.bottom, 30)
                .disabled(model.email == "" || model.password == "")
                
            }.onAppear {
                email = model.email
                password = model.password
            }
            .customNavBar(proxy: reader, title: "Enter Credentials", leading: Button(action: {
                withAnimation {
                model.step = .landing
                }
            }, label: {
                AnyView(Image("left"))
            }))
        }
        
    }
}
