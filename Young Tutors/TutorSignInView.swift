//
//  TutorSignInView.swift
//  Young Tutors
//
//  Created by Kendall Easterly on 12/4/20.
//

import SwiftUI

struct TutorSignInView: View {
    
    @ObservedObject var model: SignUpModel
    @ObservedObject var tutorModel = TutorsModel()
    @State var searchFieldText = ""
    @State var customSearchText = ""
    @State var selectedTutor = ""
    var tutorArray = ["kjeasterly@cps.edu","kjeasterly31@gmail.com"]
    var body: some View {
        GeometryReader {reader in
            VStack {
                //Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(Color(UIColor.tertiaryLabel))
                    
                    TextField("Search", text: $searchFieldText) { (changing) in } onCommit: {
                        self.hideKeyboard()
                        self.searchFieldText = ""
                    }.onChange(of: searchFieldText) { (value) in
                        withAnimation {
                            customSearchText = value
                        }
                    }
                    
                    Spacer()
                    
                    Button {
                        self.searchFieldText = ""
                        self.hideKeyboard()
                    } label: {
                        Image(systemName: "xmark.circle")
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
                .background(RoundedRectangle(cornerRadius: 15)
                                .foregroundColor(Color(UIColor.tertiarySystemFill)))
                .padding(.horizontal)
                .padding(.vertical)
                
                ScrollView {
                    ForEach(decideData()) { tutor in
                        Button {
                            self.selectedTutor = tutor.id
                            if let email = tutor.email {
                                model.email = email
                            }
                            
                        } label: {
                            VStack {
                                Text(tutor.id)
                                    .leading()
                                
                                if let email = tutor.email {
                                    Text(email)
                                        .foregroundColor(Color(UIColor.secondaryLabel))
                                        .font(.subheadline)
                                        .leading()
                                }
                                
                            }
                        }

                        
                        
                        Divider()
                        
                    }
                }.padding(.horizontal)
               
                Spacer()
                
                Button(action: {
                    model.isTutor = true
                    model.signInTutor()
                }, label: {
                    
                    HStack {
                        
                        Spacer()
                        
                        Image("check-plain")
                    }.overlay(Text("Complete")
                                .fontWeight(.semibold)
                                .foregroundColor(selectedTutor == "" ? Color(UIColor.quaternaryLabel) : .white))
                    .padding([.vertical, .trailing], 10)
                    .frame(width: reader.size.width - 40)
                    .background(RoundedRectangle(cornerRadius: 30)
                                    .foregroundColor(selectedTutor == "" ? self.cs().darkGrey.opacity(0.5) : self.cs().watermelon))
                    
                }).padding(.bottom, 30)
                .disabled(selectedTutor == "")
                
                
                Text("We’re sorry, but new tutors are not available yet. Please email")
                    .font(.footnote)
                    .multilineTextAlignment(.center)
                
                HStack {
                    Button {
                            if let url = URL(string: "mailto:support@kendalleasterly.com") {
                                UIApplication.shared.open(url) { (result) in
                                    if result {
                                        print("successful")
                                    }
                                }
                            } else {
                                print("url was invalid")
                            }
                    } label: {
                        Text("support@kendalleasterly.com")
                            .foregroundColor(Color(UIColor.label))
                            .font(.footnote)
                            .multilineTextAlignment(.center)
                    }

                    Text("to be added.")
                        .font(.footnote)
                        .multilineTextAlignment(.center)
                }
               
                
            }.onAppear {
                tutorModel.getTutors()
            }
            .customNavBar(proxy: reader, title: "Which Tutor are You?", leading: Button(action: {
                withAnimation {
                model.step = .landing
                }
            }, label: {
                AnyView(Image("left"))
            }))
        }
        
        
    }
    
    func decideData() -> [Tutor] {
        
        if customSearchText == "" {
            return tutorModel.tutors
        } else {
            
            var resultArray = [Tutor]()
            
            for tutor in tutorModel.tutors {
                
                if tutor.id.contains(customSearchText)  {
                    
                    resultArray.append(tutor)
                    
                }
                
            }
            
            return resultArray
            
        }
    }
    
}
