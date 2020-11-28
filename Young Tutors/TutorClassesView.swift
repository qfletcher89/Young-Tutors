//
//  TutorClassesView.swift
//  Young Tutors
//
//  Created by Kendall Easterly on 11/27/20.
//

import SwiftUI

struct TutorClassesView: View {
    @Environment (\.self.presentationMode) var presentationMode
    @ObservedObject var classModel = ClassModel()
    @EnvironmentObject var model: TutorDataModel
    @State var searchFieldText = ""
    @State var customSearchText = ""
    @State var classes = [Class]()
    @State var removedClasses = [Class]()
    @State var addedClasses = [Class]()
    
    var subject: Subject
    var boxWidth: CGFloat
    var color: Color
    
    init(subject: Subject,
         boxWidth: CGFloat,
         color: Color) {
        
        self.subject = subject
        self.boxWidth = boxWidth
        self.color = color
        
    }
    
    var body: some View {
        
        GeometryReader { geometry in
            ScrollView {
                
                VStack {
                    
                    //Search bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(Color(UIColor.tertiaryLabel))
                        
                        TextField("Search", text: $searchFieldText) { (changing) in } onCommit: {
                            self.hideKeyboard()
                            self.searchFieldText = ""
                        }.onChange(of: searchFieldText) { (value) in
                            withAnimation {
                                self.customSearchText = value
                                
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
                    }.padding(.horizontal)
                    .padding(.vertical, 10)
                    .background(RoundedRectangle(cornerRadius: 15)
                                    .foregroundColor(Color(UIColor.tertiarySystemFill)))
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    
                    HStack(alignment: .top) {
                        
                        ForEach(0..<2) { index in
                            
                            VStack {
                                ForEach(splitClasses()[index]) {course in
                                    
                                        
                                        TutorCard(selection: isContainedInArray(course: course),
                                                  removedClasses: $removedClasses,
                                                  newClasses: $addedClasses,
                                                  originalSelection: isContainedInArray(course: course),
                                                  boxWidth: boxWidth,
                                                  color: color,
                                                  mainText: course.name,
                                                  number: 0,
                                                  course: course)
                                }
                            }.padding(index == 0 ? .leading : .trailing, 20)
                            
                            if index == 0 {
                                Spacer()
                            }
                            
                        }
//
//
//
//                        Spacer()
//
//                        VStack {
//
//                            ForEach(splitClasses()[1]) {course in
//
//                                    TutorCard(selection: isContainedInArray(course: course),
//                                              removedClasses: $removedClasses,
//                                              newClasses: $addedClasses,
//                                              originalSelection: isContainedInArray(course: course),
//                                              boxWidth: boxWidth,
//                                              color: color,
//                                              mainText: course.name,
//                                              number: 0,
//                                              course: course)
//
//                            }
//                        }.padding(.trailing, 20)
                    }
                }
                
                Spacer()
                
            }
            .navigationBarHidden(true)
            .onAppear {
                
                classModel.getClasses(for: subject) { (classes) in
                    self.classes = classes
                }
            }.customNavBar(proxy: geometry, title: subject.id.capitalized, Button(action: {
                
                model.saveClasses(classes: addedClasses)
                model.deleteClasses(classes: removedClasses)
                model.getData()
                self.presentationMode.wrappedValue.dismiss()
                
            }, label: {
                
                AnyView(
                    HStack(spacing: 0) {
                        Image("left")
                        
                        Text("Save")
                            .foregroundColor(self.cs().watermelon)
                    }
                    
                )
            }), Button(action: {
               
                self.presentationMode.wrappedValue.dismiss()
                
            }, label: {
                AnyView(Text("Cancel").foregroundColor(self.cs().watermelon))
            }))
        }
    }
}

extension TutorClassesView {
    
    func isContainedInArray(course: Class) -> Bool {
        
        var classStrings = [String]()
        
        for course in model.classes {
            
            classStrings.append(course.id)
            
        }
        
        let isContained = classStrings.contains(course.id)
        return isContained
        
    }
    
    func decideData() -> [Class] {
        
        if customSearchText == "" {
            return self.classes
        } else {
            
            var resultArray = [Class]()
            
            for course in self.classes {
                print(course.name)
                
                if course.name.contains(customSearchText.uppercased()) {
                    print("contains text")
                    resultArray.append(course)
                }
                
            }
            
            return resultArray
        }
    }
    
    func splitClasses() -> [[Class]] {
        
        var leftClasses = [Class]()
        var rightClasses = [Class]()
        
        var left = true
        
        for course in decideData() {
            
            if left {
                
                leftClasses.append(course)
                
                left.toggle()
            } else {
                
                rightClasses.append(course)
                
                left.toggle()
            }
        }
        
        let classesArray = [leftClasses, rightClasses]
        
        return classesArray
        
    }
    
    func getSessionsCount(course: Class) -> Int {
        
        var count = 0
        
        for session in course.sessions {
            
            if Int(session.day)! >= Calendar.current.component(.weekday, from: Date()) {
                count = count + session.tutors.count
            }
            
        }
        
        return count
        
    }
    
}
