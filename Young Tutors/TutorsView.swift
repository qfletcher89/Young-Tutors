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
                            
                            NavigationLink(destination: TutorDetailView(tutor: tutor, isFromModal: false)) {
                                
                                HStack {
                                    
                                    //Picture
                                    
                                    ZStack {
                                        
                                        Circle()
                                            .frame(width: 45, height: 45)
                                            .foregroundColor(Color(UIColor.tertiarySystemBackground))
                                        
                                        Text(getInitals(for: tutor).uppercased())
                                            .font(.system(size: 20, weight: .regular, design: .rounded)).gradientForeground(colors: getGradientColors(for: tutor))
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
                                            Text("Sorry, no strengths available yet.")
                                                .foregroundColor(Color(UIColor.secondaryLabel))
                                                .italic()
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
                }.padding()
                .navigationTitle(Text(""))
                .navigationBarHidden(true)
                .customNavBar(proxy: proxy, title: "Tutors", trailing:  Button(action: {
                    model.getTutors()
                    
                }, label: {
                    AnyView(Image("reload"))
                }))
            }
            
        }
    }
    
    func getGradientColors(for tutor: Tutor) -> [Color] {
        
        let gradientStrings = ["watermelon-magenta",
                               "skyBlue-magenta",
                               "mint-skyBlue",
                               "watermelon-orange"]
        
        switch tutor.gradient {
        case gradientStrings[0]:
            return [Color(#colorLiteral(red: 0.929411768913269, green: 0.45098039507865906, blue: 0.4901960790157318, alpha: 1)), Color(#colorLiteral(red: 0.6078431606292725, green: 0.364705890417099, blue: 0.7098039388656616, alpha: 1))]
            
        case gradientStrings[1]:
            return [Color(#colorLiteral(red: 0.23137255012989044, green: 0.6039215922355652, blue: 0.8509804010391235, alpha: 1)), Color(#colorLiteral(red: 0.4588235318660736, green: 0.3803921639919281, blue: 0.7647058963775635, alpha: 1))]
            
        case gradientStrings[2]:
            return [Color(#colorLiteral(red: 0.16470588743686676, green: 0.7372549176216125, blue: 0.615686297416687, alpha: 1)), Color(#colorLiteral(red: 0.23137255012989044, green: 0.6039215922355652, blue: 0.8509804010391235, alpha: 1))]
            
        case gradientStrings[3]:
            return [Color(#colorLiteral(red: 0.929411768913269, green: 0.45098039507865906, blue: 0.4901960790157318, alpha: 1)), Color(#colorLiteral(red: 0.8980392217636108, green: 0.49803921580314636, blue: 0.1921568661928177, alpha: 1))]
            
        default:
            return [Color(#colorLiteral(red: 0.929411768913269, green: 0.45098039507865906, blue: 0.4901960790157318, alpha: 1)), Color(#colorLiteral(red: 0.6078431606292725, green: 0.364705890417099, blue: 0.7098039388656616, alpha: 1))]
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
