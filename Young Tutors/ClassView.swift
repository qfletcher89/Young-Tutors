//
//  ClassView.swift
//  Young Tutors
//
//  Created by Kendall Easterly on 11/18/20.
//

import SwiftUI

struct ClassView: View {
    
    @Environment (\.self.presentationMode) var presentationMode
    @ObservedObject var model = ClassModel()
    @State var searchFieldText = ""
    @State var customSearchText = ""
    @State var classes = [Class]()
    
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
                        
                        VStack {
                            ForEach(splitClasses()[0]) {course in
                                
                                NavigationLink(destination: SessionView(subject: subject, course: course)) {
                                    Card(boxWidth: boxWidth,
                                         color: color,
                                         mainText: course.name,
                                         number: getSessionsCount(course: course),
                                         course: course)
                                }.disabled(getSessionsCount(course: course) == 0 ? true : false)
                            }
                        }.padding(.leading, 20)
                        
                        Spacer()
                        
                        VStack {
                            
                            ForEach(splitClasses()[1]) {course in
                                
                                NavigationLink(destination: SessionView(subject: subject, course: course)) {
                                    Card(boxWidth: boxWidth,
                                         color: color,
                                         mainText: course.name,
                                         number: getSessionsCount(course: course),
                                         course: course)
                                }.disabled(getSessionsCount(course: course) == 0 ? true : false)
                            }
                        }.padding(.trailing, 20)
                    }
                }
                
                Spacer()
                
            }
            .navigationBarHidden(true)
            .onAppear {
                
                model.getClasses(for: subject) { (classes) in
                    self.classes = classes
                }
            }.customNavBar(proxy: geometry, title: subject.id.capitalized, Button(action: {
                self.presentationMode.wrappedValue.dismiss()
                
            }, label: {
                AnyView(Image("left"))
            }), nil)
        }
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
