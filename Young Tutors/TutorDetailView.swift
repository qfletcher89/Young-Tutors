//
//  TutorDetailView.swift
//  Young Tutors
//
//  Created by Kendall Easterly on 11/29/20.
//

import SwiftUI

struct TutorDetailView: View {
    
    @Environment (\.self.presentationMode) var presentationMode
    @State var moreIsShowing = false
    var tutor: Tutor
    var isFromModal: Bool
    
    var body: some View {
        
        if tutor.id != "not-found" {
            GeometryReader { proxy in
                
                //container for top bar with name and rest of content
                ZStack(alignment: .top) {
                    
                    //all content
                    VStack {
                        
                        ZStack(alignment: .top){
                            
                            Rectangle()
                                .fill(LinearGradient(gradient: Gradient(colors: getGradientColors()),
                                                     startPoint: UnitPoint(x: 0.5, y: 0),
                                                     endPoint: UnitPoint(x: 1, y: 1)))
                                .frame(height: proxy.size.height * getBakcgroundHeight(proxy: proxy))
                                .cornerRadius(radius: 30, corners: [.bottomLeft, .bottomRight])
                                .edgesIgnoringSafeArea(.all)
                            
                            //profile pic
                            VStack {
                                ZStack{
                                    Circle()
                                        .frame(width: 150, height: 150)
                                        .foregroundColor(.tertiaryBackground)
                                    
                                    Text(getInitals(for: tutor).uppercased())
                                        .font(.system(size: 67, weight: .regular, design: .rounded))
                                        .foregroundColor(.label)
                                    
                                }.padding(.vertical, getImagePadding(proxy: proxy))
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    
                                    HStack(alignment: .top) {
                                        
                                        VStack(alignment: .leading, spacing: 10) {
                                            Text("Info:")
                                                .font(.title3)
                                                .fontWeight(.semibold)
                                                .foregroundColor(.label)
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
                                                .foregroundColor(.secondaryBackground)
                                        )
                                        .padding(.leading, 20)
                                        
                                        
                                        VStack(alignment: .leading, spacing: 10) {
                                            Text("Bio:")
                                                .font(.title3)
                                                .fontWeight(.semibold)
                                                .foregroundColor(.label)
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
                                                .foregroundColor(.secondaryBackground)
                                        )
                                        .padding(.leading, 20)
                                        .padding(.bottom, 20)
                                        
                                        
                                        VStack(alignment: .leading, spacing: 10) {
                                            Text("Subject Strengths:")
                                                .font(.title3)
                                                .fontWeight(.semibold)
                                                .foregroundColor(.label)
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
                                                .foregroundColor(.secondaryBackground)
                                        )
                                        .padding(.leading, 20)
                                        
                                        VStack(alignment: .leading, spacing: 10) {
                                            Text("Awards:")
                                                .font(.title3)
                                                .fontWeight(.semibold)
                                                .foregroundColor(.label)
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
                                                .foregroundColor(.secondaryBackground)
                                        )
                                        .padding(.horizontal, 20)
                                        
                                    }.foregroundColor(.secondaryLabel)
                                    
                                }
                            }
                        }
                    }
                    
                    //top bar
                    HStack {
                        Button {
                            self.presentationMode.wrappedValue.dismiss()
                        } label: {
                            Image(isFromModal ? "x": "left")
                                .renderingMode(.template)
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        Button {
                            
                            if let email = tutor.email {
                                if let url = URL(string: "mailto:\(email)"){
                                    UIApplication.shared.open(url) { (result) in
                                        if result {
                                            print("successful")
                                        }
                                    }
                                } else {
                                    print("url was invalid")
                                }
                            }
                            
                        } label: {
                            Image("mail")
                                .renderingMode(.template)
                                .foregroundColor(tutor.email != nil && tutor.email != "not-found" ? .white : .quatrentaryLabel)
                        }
                        
                    }.overlay(Text(tutor.id)
                                .font(.title2)
                                .bold()
                                .foregroundColor(.white))
                    .padding([.horizontal, .top])
                    .padding(.top, isFromModal ? 10 : 0)
                    
                }
                
            }.navigationTitle(Text(""))
            .navigationBarHidden(true)
            .background(isFromModal ? Color("ModalColor")
                            .edgesIgnoringSafeArea(.all) : Color.background
                            .edgesIgnoringSafeArea(.all))
        } else {
            Text("Sorry, this tutor was not found")
                .italic()
                .font(.title2)
                .fontWeight(.bold)
        }
        
        
    }
    
    func getGradientColors() -> [Color] {
        
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
