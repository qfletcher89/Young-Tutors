//
//  TutorCard.swift
//  Young Tutors
//
//  Created by Kendall Easterly on 11/27/20.
//

import SwiftUI

//Differences between this card and the student one. This one has the ability to be selected, it doesn't have a disabled look.

//somewhere I need to keep a collection of the original values. when the button is pressed, see whether or not it was originally selected. If it wasn't, added it to the newlySelected binding array from our parent view. Vice versa for the other. I have two seperate values related to the selection. An original value, and then a state value. i compare the orignal value for the adding to the array, and use the state to change it.

struct TutorCard: View {
    
    @State var selection: Bool
    @Binding var removedClasses: [Class]
    @Binding var newClasses: [Class]
    
    var originalSelection: Bool?
    var boxWidth: CGFloat
    var color: Color
    var mainText: String
    var number: Int
    var course: Class?
    
    var body: some View {
        
        Button  {
            
            self.selection.toggle()
            update()
        } label: {
            
        HStack {
            
            VStack(alignment: .leading) {
                
                HStack(alignment: .bottom) {
                    
                    if let course = course {
                        
                        Text(course.levels)
                            .foregroundColor(color)
                            .opacity(0.5)
                        
                        //selection
                        Spacer()
                        
                        if selection {

                            ZStack {
                                Circle()
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(color)
                                
                                Image("check-plain")
                                    .renderingMode(.template)
                                    .foregroundColor(Color(UIColor.secondarySystemBackground))
                            }
                            
                        } else {
                            ZStack {
                                Circle()
                                    .stroke(lineWidth: 2)
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(color)
                            }
                        }
                        

                    } else {
                        
                        decideImage()
                            .renderingMode(.template)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .font(.system(size: 22, weight: .semibold))
                            .frame(width: 24, height: 24)
                            .foregroundColor(color)
                            .opacity(0.5)
                        Spacer()
                        Text("\(number)")
                            .foregroundColor(color)
                            .font(.title3)
                            .fontWeight(.semibold)
                    }
                    
                }.frame(width: (boxWidth -  40))
                .padding(.bottom, 5)
                .padding(.horizontal)
                
                Text("\(mainText.capitalized)")
                    .foregroundColor(color)
                    .font(.body)
                    .fontWeight(.semibold)
                    .frame(width: (boxWidth -  40), alignment: .leading)
                    .padding(.horizontal)
            }
            
        }
    }
        .padding(.vertical, 20)
        .background(RoundedRectangle(cornerRadius: 30)
                        .frame(width: boxWidth)
                        .foregroundColor(self.cs().background6))
    }
}

extension TutorCard {
    
    ///to be called after we toggle the selection
    func update() {
        print("update was called")
        if originalSelection == true {
            //it was orignally set to true
            print("original selection was true")
            if selection == originalSelection {
                
                var index = 0
                
                for course in removedClasses {
                    
                    if course.id == self.course!.id {
                        
                        removedClasses.remove(at: index)
                        
                    }
                    
                    index = index + 1
                    
                }
                
            } else {
                //else if it wasn't different, then remove it from the removed
                
                
                
                
                print("selection was the same as the original")
                //if the new value is difffernt than the original, it is not in any array. that means that we can add it to the removed.
                
                removedClasses.append(course!)
                print(removedClasses)
                
            }
            
        } else {
            print("original selection was false")
            //it was orignally set to false
            if selection == originalSelection! {
                
                
                var index = 0
                
                for course in newClasses {
                    
                    if course.id == self.course!.id {
                        
                        newClasses.remove(at: index)
                        
                    }
                    
                    index = index + 1
                    
                }
                
            } else {
                //else if it wasn't different, then remove it from the newly added.
                
                print("selection was the same as the original")
                //if the new value is difffernt than the original, it is not in any array. that means that we can add it to the newly added.
                newClasses.append(course!)
                print(newClasses)
            }
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
