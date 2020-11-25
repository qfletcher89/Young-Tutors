//
//  Card.swift
//  Young Tutors
//
//  Created by Kendall Easterly on 11/18/20.
//

import SwiftUI

struct Card: View {
    
    @State var destinationIsActive = false
    var boxWidth: CGFloat
    var color: Color
    var mainText: String
    var number: Int
    var course: Class?
    
    var body: some View {
        
        HStack {
            
            VStack(alignment: .leading) {
                
                HStack(alignment: .bottom) {
                    
                    if let course = course {
                        
                        Text(course.levels)
                            .foregroundColor(.white)
                            .opacity(0.5)
                        
                    } else {
                        
                        decideImage()
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .font(.system(size: 22, weight: .semibold))
                            .frame(width: 24, height: 24)
                            .opacity(mainText == "science" ? 0.5 : 1)
                            .foregroundColor(.white)
                    }
                    Spacer()
                    
                    Text("\(number)")
                        .foregroundColor(.white)
                        .font(.system(.title3, design: .rounded))
                        .fontWeight(.semibold)
                }.frame(width: (boxWidth -  40))
                .padding(.bottom, 5)
                .padding(.horizontal)
                
                Text("\(mainText.capitalized)")
                    .foregroundColor(.white)
                    .font(.system(.body, design: .rounded))
                    .fontWeight(.semibold)
                    .frame(width: (boxWidth -  40), alignment: .leading)
                    .padding(.horizontal)
            }
            
        }
        .padding(.vertical, 20)
        .background(RoundedRectangle(cornerRadius: 30)
                        .frame(width: boxWidth)
                        .foregroundColor(number == 0 ? self.cs().darkGrey : color))
        .shadow(color: number == 0 ? color.opacity(0) : color.opacity(course == nil ? 0.4 : 0),
                radius: 40, x: 0, y: 20)
    }
    
    func decideColor() -> Color {
        
        switch mainText {
        
        case "computer science":
            return self.cs().orange
        case "math":
            return self.cs().skyBlue
        case "english":
            return self.cs().navyBlue
        case "science":
            return self.cs().mint
        case "social science":
            return self.cs().red
        case "performing arts":
            return self.cs().magenta
        case "world languages":
            return self.cs().yellow
        case "pe":
            return self.cs().coffe
        case "visual arts":
            return self.cs().teal
        default:
            return self.cs().black
        }
    }
    
    func decideImage() -> Image {
        
        switch mainText {
        
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
        default:
            return Image("book")
        }
    }
}
