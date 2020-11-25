//
//  ClassView.swift
//  Young Tutors
//
//  Created by Kendall Easterly on 11/18/20.
//

import SwiftUI

struct ClassView: View {
    
    @ObservedObject var model = ClassModel()
    @State var searchFieldText = ""
    @State var customSearchText = ""
    @State var classes = [Class]()
    var subject: Subject
    var boxWidth: CGFloat
    var color: Color
    
    var body: some View {
        
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
                                .foregroundColor(self.cs().black))
                .padding(.horizontal)
                .padding(.vertical, 10)
                
                HStack(alignment: .top) {
                    
                    VStack {
                        ForEach(splitClasses()[0]) {course in
                            
                            NavigationLink(destination: SessionView(course: course)) {
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
                            
                            NavigationLink(destination: SessionView(course: course)) {
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
            .onAppear {
                
                model.getClasses(for: subject) { (classes) in
                    self.classes = classes
                }
            }
            Spacer()
            
        }//.navigationTitle(Text(subject.id.capitalized))
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack {
                    Image("gym")
                    Text(subject.id.capitalized)
                }
            }
        }
        .background(self.cs().background.edgesIgnoringSafeArea(.all))
        
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
            
            count = count + session.tutors.count
            
        }
        
        return count
        
    }
    
}
