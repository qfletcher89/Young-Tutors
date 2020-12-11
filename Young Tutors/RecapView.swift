//
//  RecapView.swift
//  Young Tutors
//
//  Created by Kendall Easterly on 12/10/20.
//

import SwiftUI

struct RecapView: View {
    
    @Environment (\.presentationMode) var presentationMode
    //we're gonna break out the nav model ;)
    var course: Class
    var date: String
    var time: String
    var tutor: Tutor
    
    var body: some View {
        
        GeometryReader { proxy in
            VStack {
                
                Text("Your session has been booked.")
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                //class
                VStack(alignment: .leading, spacing: 0) {
                    
                    HStack(spacing: 10){
                        getClassImage()
                            .renderingMode(.template)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24, height: 24)
                            .foregroundColor(Color(UIColor.secondaryLabel))
                        
                        Text("Class")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(Color(UIColor.secondaryLabel))
                        
                    }
                    Text(course.levels + " " + course.name.capitalized)
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.leading, 24 + 10)
                }.leading()
                
                //date
                VStack(alignment: .leading, spacing: 0) {
                    
                    HStack(spacing: 10){
                        Image("calendar")
                            .renderingMode(.template)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24, height: 24)
                            .foregroundColor(Color(UIColor.secondaryLabel))
                        
                        Text("Date")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(Color(UIColor.secondaryLabel))
                        
                    }
                    Text(date)
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.leading, 24 + 10)
                }.leading()
                
                //time
                VStack(alignment: .leading, spacing: 0) {
                    
                    HStack(spacing: 10){
                        Image("clock")
                            .renderingMode(.template)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24, height: 24)
                            .foregroundColor(Color(UIColor.secondaryLabel))
                        
                        Text("Time")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(Color(UIColor.secondaryLabel))
                        
                    }
                    Text(time)
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.leading, 24 + 10)
                }.leading()
                
                //tutor
                VStack(alignment: .leading, spacing: 0) {
                    
                    HStack(spacing: 10){
                        Image("profile")
                            .renderingMode(.template)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24, height: 24)
                            .foregroundColor(Color(UIColor.secondaryLabel))
                        
                        Text("Tutor")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(Color(UIColor.secondaryLabel))
                        
                    }
                    Text(tutor.id)
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.leading, 24 + 10)
                }.leading()
                
                Spacer()
                
                Button {
                    //view profile
                } label: {
                    Text("View Profile")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity)
                        .background(RoundedRectangle(cornerRadius: 30)
                                        .foregroundColor(self.cs().watermelon))
                        .padding(.horizontal)
                }
                
                Button {
                    //cancel
                } label: {
                    Text("Cancel")
                        .fontWeight(.semibold)
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity)
                        .background(RoundedRectangle(cornerRadius: 30)
                                        .stroke()
                        )
                        .padding()
                }
                .accentColor(Color(UIColor.label))
                
            }.padding()
            .customNavBar(proxy: proxy, title: "Recap", trailing: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                AnyView(Text("Done")
                            .fontWeight(.semibold)
                            .foregroundColor(self.cs().watermelon))
            }))
        }
    }
    
    func getClassImage() -> Image {
        
        switch course.subject {
        
        case "computer science":
            return Image("laptop")
        case "math":
            return Image("math-percent")
        case "english":
            return Image("book")
        case "science":
            return Image(systemName: "staroflife")
        case "social science":
            return Image("globe")
        case "performing arts":
            return Image("music-note")
        case "world languages":
            return Image("globe-alt")
        case "pe":
            return Image("gym")
        case "visual arts":
            return Image("color-bucket")
        case "times":
            return Image("clock")
        default:
            return Image("book")
        }
    }
    
}

