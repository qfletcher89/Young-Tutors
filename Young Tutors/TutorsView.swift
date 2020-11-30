//
//  TutorsView.swift
//  Young Tutors
//
//  Created by Kendall Easterly on 11/25/20.
//

import SwiftUI

struct TutorsView: View {
    
    @ObservedObject var model: TutorsModel
    
    var body: some View {
        NavigationView {
            GeometryReader { proxy in
                ScrollView {
                    VStack(alignment: .leading) {
                        
                        ForEach(model.tutors) { tutor in
                            
                            NavigationLink(destination: TutorDetailView(tutor: tutor)) {
                                
                                HStack {
                                    
                                    //Picture
                                    
                                    ZStack {
                                        
                                        Circle()
                                            .frame(width: 45, height: 45)
                                            .foregroundColor(Color(UIColor.tertiarySystemBackground))
                                        
                                        Text(getInitals(for: tutor).uppercased())
                                            .font(.system(size: 20, weight: .regular, design: .rounded)).gradientForeground(colors: [Color(#colorLiteral(red: 0.929411768913269, green: 0.45098039507865906, blue: 0.4901960790157318, alpha: 1)), Color(#colorLiteral(red: 0.6078431606292725, green: 0.364705890417099, blue: 0.7098039388656616, alpha: 1))])
                                        
                                        
                                        
                                        
                                    }
                                    
                                    VStack(alignment: .leading) {
                                        //name
                                        Text(tutor.id)
                                            .foregroundColor(Color(UIColor.label))
                                        
                                        //subject strengths
                                        if tutor.strengths != nil {
                                            Text(tutor.strengths!)
                                                .font(.subheadline)
                                                .foregroundColor(Color(UIColor.secondaryLabel))
                                                .lineLimit(1)
                                        } else {
                                            Text(" ")
                                                .font(.subheadline)
                                        }
                                    }
                                    
                                    Spacer()
                                    
                                }
                                
                            }
                            
                            Divider()
                                .padding(.leading, 45)
                            
                        }
                        
                    }
                }.padding(.horizontal)
                .navigationTitle(Text(""))
                .navigationBarHidden(true)
                .customNavBar(proxy: proxy, title: "Tutors", nil, Button(action: {
                    model.getTutors()
                }, label: {
                    AnyView(Image("reload"))
                }))
            }
            
        }
    }
    
    func getInitals(for tutor: Tutor) -> String {
        
        let first = tutor.id.split(separator: " ").first!
        let last = tutor.id.split(separator: " ").last!
        
        let firstInitial = String(first)[0]
        let lastInitial = String(last)[0]
        
        let initials = firstInitial + lastInitial
        
        return initials
        
    }
}
