//
//  Card.swift
//  Young Tutors
//
//  Created by Kendall Easterly on 11/18/20.
//

import SwiftUI

struct Card: View {
    
    var boxWidth: CGFloat
    var color: Color
    var mainText: String
    var number: Int
    var course: Class?
    
    init(boxWidth: CGFloat,
    color: Color,
    mainText: String,
    number: Int,
    course: Class?) {
        
        self.boxWidth = boxWidth
        self.color = color
        self.mainText = mainText
        self.number = number
        self.course = course
        
        if course != nil {
            if number == 0 {
                self.color = .quatrentaryLabel
            }
        }
        
    }
    
    
    var body: some View {
        
        HStack {
            
            VStack(alignment: .leading) {
                
                HStack(alignment: .bottom) {
                    
                    if let course = course {
                        
                        Text(course.levels)
                            .foregroundColor(color)
                            .opacity(0.5)
                        
                    } else {
                        
                        decideImage()
                            .renderingMode(.template)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .font(.system(size: 22, weight: .semibold))
                            .frame(width: 24, height: 24)
                            .foregroundColor(color)
                            .opacity(0.5)
                    }
                    Spacer()
                    
                    Text("\(number)")
                        .foregroundColor(color)
                        .font(.title3)
                        .fontWeight(.semibold)
                }.frame(width: (boxWidth -  40))
                .padding(.bottom, 5)
                .padding(.horizontal)
                
//                Text("\(capitalizeMainText())")
                Text(mainText)
                    .foregroundColor(color)
                    .font(.body)
                    .fontWeight(.semibold)
                    .frame(width: (boxWidth -  40), alignment: .leading)
                    .padding(.horizontal)
            }
            
        }
        .padding(.vertical, 20)
        .background(RoundedRectangle(cornerRadius: 30)
                        .frame(width: boxWidth)
                        .foregroundColor(.secondaryBackground))
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
        case "times":
            return Image("clock")
        default:
            return Image("book")
        }
    }
    
//    func capitalizeMainText() -> String {
//
//        var funcName = self.mainText.capitalized
//
//        if funcName.contains("Ii") {
//            funcName = funcName.replacingOccurrences(of: "Ii", with: "II")
//        } else if funcName.contains("Iii") {
//            funcName = funcName.replacingOccurrences(of: "Iii", with: "III")
//        }
//
//        return funcName
//
//    }
    
}
