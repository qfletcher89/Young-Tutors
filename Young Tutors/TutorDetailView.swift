//
//  TutorDetailView.swift
//  Young Tutors
//
//  Created by Kendall Easterly on 11/29/20.
//

import SwiftUI

struct TutorDetailView: View {
    
    @Environment (\.self.presentationMode) var presentationMode
    var tutor: Tutor
    
    var body: some View {
        
        GeometryReader { proxy in
            
            //container for top bar with name and rest of content
            ZStack(alignment: .top) {
                
                //all content
                VStack {
                    
                    ZStack(alignment: .top){
                       
                        RoundedRectangle(cornerRadius: 30)
                            .foregroundColor(.red)
                            .frame(height: proxy.size.height * getBakcgroundHeight(proxy: proxy))
                            .edgesIgnoringSafeArea(.all)
                        
                        //profile pic
                        VStack {
                            ZStack{
                                Circle()
                                    .frame(width: 150, height: 150)
                                    .foregroundColor(Color(UIColor.tertiarySystemBackground))
                                
                                Text(getInitals(for: tutor).uppercased())
                                    .font(.system(size: 67, weight: .regular, design: .rounded))
                                    .foregroundColor(Color(UIColor.label))
                                
                            }.padding(.vertical, getImagePadding(proxy: proxy))
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                
                                HStack(alignment: .top) {
                                    
                                    VStack(alignment: .leading, spacing: 10) {
                                        Text("Info:")
                                            .font(.title3)
                                            .fontWeight(.semibold)
                                            .foregroundColor(Color(UIColor.label))
                                            .padding(.bottom, 10)
                                        
                                        if tutor.pronouns != nil {
                                            Text(tutor.pronouns!)
                                        }
                                        
                                        if tutor.grade != nil {
                                            Text(tutor.grade!)
                                        }
                                        
                                        if tutor.email != nil {
                                            Text(tutor.email!)
                                        }
                                        
                                        if tutor.pronouns == nil &&
                                            tutor.grade == nil &&
                                            tutor.email == nil {
                                            Text("Sorry, there is no information available for this tutor")
                                                .italic()
                                        }
                                    }.padding(.vertical, 30)
                                    .padding(.horizontal, 30)
                                    .frame(width: proxy.size.width - 60, alignment: .leading)
                                    .background(
                                    RoundedRectangle(cornerRadius: 30)
                                        .foregroundColor(Color(UIColor.secondarySystemBackground))
                                    )
                                    .padding(.leading, 20)
                                    
                                    
                                    VStack(alignment: .leading, spacing: 10) {
                                        Text("Bio:")
                                            .font(.title3)
                                            .fontWeight(.semibold)
                                            .foregroundColor(Color(UIColor.label))
                                            .padding(.bottom, 10)
                                        
                                        if tutor.bio != nil {
                                            ScrollView {
                                            Text(tutor.bio!)
                                                .lineLimit(.none)
                                            }
                                        } else {
                                            Text("Sorry, there is no bio available for this tutor")
                                                .italic()
                                        }
                                        
                                    }.padding(.vertical, 30)
                                    .padding(.horizontal, 30)
                                    .frame(width: proxy.size.width - 60, alignment: .leading)
                                    .background(
                                    RoundedRectangle(cornerRadius: 30)
                                        .foregroundColor(Color(UIColor.secondarySystemBackground))
                                    )
                                    .padding(.leading, 20)
                                    .padding(.bottom, 20)
                                    
                                    VStack(alignment: .leading, spacing: 10) {
                                        Text("Subject Strengths:")
                                            .font(.title3)
                                            .fontWeight(.semibold)
                                            .foregroundColor(Color(UIColor.label))
                                            .padding(.bottom, 10)
                                        
                                        if tutor.strengths != nil {
                                            Text(tutor.strengths!)
                                                .lineLimit(.none)
                                        } else {
                                            Text("Sorry, there are no subject strengths available for this tutor")
                                                .italic()
                                        }
                                        
                                    }.padding(.vertical, 30)
                                    .padding(.horizontal, 30)
                                    .frame(width: proxy.size.width - 60, alignment: .leading)
                                    .background(
                                    RoundedRectangle(cornerRadius: 30)
                                        .foregroundColor(Color(UIColor.secondarySystemBackground))
                                    )
                                    .padding(.leading, 20)
                                    
                                    VStack(alignment: .leading, spacing: 10) {
                                        Text("Awards:")
                                            .font(.title3)
                                            .fontWeight(.semibold)
                                            .foregroundColor(Color(UIColor.label))
                                            .padding(.bottom, 10)
                                        
                                        if tutor.awards != nil {
                                            Text(tutor.awards!)
                                                .lineLimit(.none)
                                        } else {
                                            Text("Sorry, there are no awards available for this tutor")
                                                .italic()
                                        }
                                        
                                    }.padding(.vertical, 30)
                                    .padding(.horizontal, 30)
                                    .frame(width: proxy.size.width - 60, alignment: .leading)
                                    .background(
                                    RoundedRectangle(cornerRadius: 30)
                                        .foregroundColor(Color(UIColor.secondarySystemBackground))
                                    )
                                    .padding(.horizontal, 20)
                                    
                                }.foregroundColor(Color(UIColor.secondaryLabel))
                                
                            }
                        }
                        
                        
                    }
                    
                    
                    
                }
                
                //top bar
                HStack {
                    Button {
                        self.presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image("left")
                            .renderingMode(.template)
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    Button {
                        //more options
                    } label: {
                        Image(systemName: "circle")
                    }


                }.overlay(Text(tutor.id).font(.title2).bold())
                .padding([.horizontal, .top])
                
            }
            
        }.navigationTitle(Text(""))
        .navigationBarHidden(true)
    }
    
    func getInitals(for tutor: Tutor) -> String {
        
        let first = tutor.id.split(separator: " ").first!
        let last = tutor.id.split(separator: " ").last!
        
        let firstInitial = String(first)[0]
        let lastInitial = String(last)[0]
        
        let initials = firstInitial + lastInitial
        
        return initials
        
    }
    
    func getBakcgroundHeight(proxy: GeometryProxy) -> CGFloat {
        
        let topInsets = proxy.safeAreaInsets.top
        let height = proxy.frame(in: .global).size.height
        let percent = topInsets / height
        return percent + 0.5
        
    }
    
    func getImagePadding(proxy: GeometryProxy) -> CGFloat {
        
        // half of the view minus 150 for the image divided by two since its applied to both top and bottom
        let height = proxy.size.height
        let halfOfView = height * 0.5
        let percent = 150 / height
        let total = halfOfView - percent
        return total / 4
        
    }
    
//    func getCardWidth(proxy: GeometryProxy) -> CGFloat {
//
//        //give me sixty les than the width of the frame
//
//        let width = proxy.size.width
//        let percent = 60 / width
//        return width - percent
//
//    }
    
}

//Text(tutor.id)
//
//if tutor.awards != nil {
//    Text(tutor.awards!)
//}
//
//if tutor.bio != nil {
//    Text(tutor.bio!)
//}
//
//if tutor.pronouns != nil {
//    Text(tutor.pronouns!)
//}
//
//if tutor.email != nil {
//    Text(tutor.email!)
//}
//
//if tutor.strengths != nil {
//    Text(tutor.strengths!)
//}
//
//if tutor.grade != nil {
//    Text(tutor.grade!)
//}
//
//if tutor.classes != nil {
//    ForEach(tutor.classes!, id: \.self) {course in
//        Text(course)
//    }
//}
//
//if tutor.times != nil {
//    ForEach(tutor.times!, id: \.self) {time in
//        Text(time)
//    }
//}
