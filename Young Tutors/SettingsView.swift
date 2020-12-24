//
//  NotificationsView.swift
//  Young Tutors
//
//  Created by Kendall Easterly on 11/25/20.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var studentModel: StudentModel
    @EnvironmentObject var signUpModel: SignUpModel
    @Environment (\.presentationMode) var presentationMode
    @State var name = ""
    @State var pushIsEnabled = true
    @State var emailIsEnabled = true
    
    var body: some View {
        
        GeometryReader{ reader in
            //main scroll view for all content here
            ScrollView {
                //main vstack for all content here
                VStack(spacing: 30) {
                    
                    SettingSection(title: "Account",
                                   setting1: AnyView(
                                    
                                    HStack{
                                        Image("profile-circle")
                                            .renderedColor(.secondaryLabel)
                                        
                                        TextField("Name", text: $name, onEditingChanged: {changing in}) {
                                            print("change name")
                                        }
                                    }
                                   ),
                                   setting2: AnyView(SettingBar(image: Image("key"),
                                                                name: "Change Password",
                                                                action: {
                                                                    print("change password")
                                                                })),
                                   setting3: AnyView(SettingBar(image: Image("left-circle"), name: "Log Out", action: {
                                    presentationMode.wrappedValue.dismiss()
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                                        studentModel.signOut({
//                                            signUpModel.step = .landing
                                            signUpModel.setStep(.landing, .disappear)
                                        })
                                    }
                                   })))
                    
                    SettingSection(title: "Notification Settings",
                                   setting1: AnyView(
                                    HStack {
                                        
                                        Image("phone")
                                            .renderedColor(.secondaryLabel)
                                        
                                        Toggle(isOn: $pushIsEnabled, label: {
                                            Text("Push Notifications")
                                        })
                                    }
                                   ), setting2: AnyView(
                                    HStack {
                                        
                                        Image("mail")
                                            .renderedColor(.secondaryLabel)
                                        
                                        Toggle(isOn: $emailIsEnabled, label: {
                                            Text("Email Notifications")
                                        })
                                    }
                                   ))
                    
                    SettingSection(title: "Contact Us",
                                   setting1: AnyView(SettingBar(image: Image("upload"),
                                                                name: "Submit Feedback/Bug",
                                                                action: {
                                                                    print("submit feedback")
                                                                })),
                                   setting2: AnyView(SettingBar(image: Image("mail"), name: "Email Us", action: {
                                    print("email us")
                                   })))
                    
                    SettingSection(title: "Follow Us",
                                   setting1: AnyView(SettingBar(image: Image("instagram"),
                                                                name: "WYoungTutors",
                                                                action: {
                                                                    print("wyoungtutors")
                                                                })),
                                   setting2: AnyView(SettingBar(image: Image("instagram"), name: "kendalleasterly", action: {
                                    print("kendalleasterly")
                                   })))
                    
                    SettingSection(title: "About",
                                   setting1: AnyView(SettingBar(image: Image("link"),
                                                                name: "Website Link",
                                                                action: {
                                                                    print("website link")
                                                                })),
                                   setting2: AnyView(SettingBar(image: Image("link"), name: "Privacy Policy", action: {
                                    print("privacy policy")
                                   })))
                    
                    Text("Made with 🧡💙 by the Whitney Young community")
                        .font(.caption)
                    
                }.padding([.horizontal, .top])
            }
            .customNavBar(proxy: reader,
                          title: "Settings",
                          leading: Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                          }, label: {
                            
                            AnyView(
                                Image("x")
                                    .renderedColor(.cswatermelon)
                            )
                            
                          }))
        }
    }
}

fileprivate struct SettingBar: View {
    
    var image: Image
    var name: String
    var action: ()-> Void
    
    var body: some View {
        
        Button(action: {
            
            action()
            
        }, label: {
            HStack {
                image
                    .renderedColor()
                
                Text(name)
                    .foregroundColor(Color(UIColor.label))
            }
        })
    }
}

fileprivate struct SettingSection: View {
    
    var title: String
    var setting1: AnyView
    var setting2: AnyView
    var setting3: AnyView?
    
    init(title: String,
         setting1: AnyView,
         setting2: AnyView,
         setting3: AnyView? = nil) {
        
        self.title = title
        self.setting1 = setting1
        self.setting2 = setting2
        self.setting3 = setting3
        
    }
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            Text(title)
                .font(.title3)
                .fontWeight(.semibold)
            
            VStack(alignment: .leading, spacing: 0) {
                
                setting1
                    .padding()
                //                    .padding(5)
                
                Divider()
                
                setting2
                    .padding()
                //                    .padding(5)
                
                if let thirdSetting = setting3 {
                    
                    Divider()
                    
                    thirdSetting
                        .padding()
                    //                        .padding(5)
                }
            }//.padding(.vertical)
            .background(RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.secondaryBackground))
        }
    }
}
