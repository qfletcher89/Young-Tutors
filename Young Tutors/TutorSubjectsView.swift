//
//  TutorSubjectsView.swift
//  Young Tutors
//
//  Created by Kendall Easterly on 11/27/20.
//

import SwiftUI

//Differences between this and the subjects view. The souce of the number is different. The destination is different. When we reload, I need to to do multiple things. The classes don't get disabled

struct TutorSubjectsView: View {
    
    @EnvironmentObject var model: TutorDataModel
    @ObservedObject var subjectsModel: SubjectsModel
    @State var searchFieldText = ""
    //I do a custom value so I can animate the changing of the text in search field
    @State var customSearchText = ""
    
    var body: some View {
        
        NavigationView{
            GeometryReader { geometry in
                let boxWidth = geometry.frame(in: .global).width * 0.43
                
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
                                withAnimation(Animation.easeInOut(duration: 0.2)) {
                                    
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
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                        .background(RoundedRectangle(cornerRadius: 15)
                                        .foregroundColor(.tertiarySystemFill))
                        .padding(.horizontal)
                        .padding(.vertical)             
                        
                        HStack(alignment: .top) {
                            
                            ForEach(0..<2) { index in
                                
                                VStack {
                                    ForEach(splitSubjects()[index]) {subject in
                                        
                                        NavigationLink(destination: subject.id != "times" ?
                                                        AnyView(TutorClassesView(subject: subject, boxWidth: boxWidth, color: decideColor(for: subject))) : AnyView(TutorTimesView())) {
                                            
                                            
                                            Card(boxWidth: boxWidth,
                                                 color: decideColor(for: subject),
                                                 mainText: subject.id.capitalized,
                                                 number: decideNumber(subject: subject),
                                                 course: nil)
                                                .padding(.bottom)
                                        }
                                    }
                                    
                                    Spacer()
                                    
                                }.padding(index == 0 ? .leading : .trailing, 20)
                                
                                if index == 0 {
                                    Spacer()
                                }
                            }
                        }
                    }
                }.customNavBar(proxy: geometry, title: "Select Classes", trailing: Button(action: {
                    self.model.getData()
                }, label: {
                    AnyView(Image("reload"))
                }))
            }//.navigationBarTitle("")
//            .navigationBarHidden(true)
            .background(Color.background.edgesIgnoringSafeArea(.all))
        }
        
    }
}

//all of our functinons
extension TutorSubjectsView {
    
    func decideNumber(subject: Subject) -> Int {
        
        var count = 0
        
        if subject.id != "times" {
            for course in model.classes {
                
                if course.subject == subject.id {
                    
                    count = count + 1
                    
                }
                
            }
        } else {
            
            count = model.times.count
            
        }
        
        return count
        
    }
    
    func decideData() -> [Subject] {
        
        if customSearchText == "" {
            
            return subjectsModel.subjects
        } else {
            
            var resultArray = [Subject]()
            
            for subject in subjectsModel.subjects {
                
                if subject.id.contains(customSearchText.lowercased()) {
                    
                    resultArray.append(subject)
                }
            }
            return resultArray
            
        }
    }
    
    func splitSubjects() -> [[Subject]] {
        
        var leftSubjects = [Subject]()
        var rightSubjects = [Subject]()
        
        var left = false
        
        if !subjectsModel.subjects.isEmpty {
            rightSubjects.append((Subject(id: "times", count: 0)))
            left.toggle()
        }
        
        
        for subject in decideData() {
            
            if left {
                
                leftSubjects.append(subject)
                
                left.toggle()
            } else {
                
                rightSubjects.append(subject)
                
                left.toggle()
            }
        }
        
        let splitSubjectsArray = [leftSubjects, rightSubjects]
        
        return splitSubjectsArray
    }
    
    func decideColor(for subject: Subject) -> Color {
        
        switch subject.id {
        
        case "computer science":
            return .csorange
        case "math":
            return .csskyBlue
        case "english":
            return .csnavyBlue
        case "science":
            return .csmint
        case "social science":
            return .csred
        case "performing arts":
            return .csmagenta
        case "world languages":
            return .csyellow
        case "pe":
            return .cscoffe
        case "visual arts":
            return .csteal
        case "times":
            return .cswatermelon
        default:
            return .csblack
        }
    }
}

//For the main view in the classes, you can get all the information since its already in our object. We just format it later on. That main call comes from the container view appearing, and it can be refreshed.
//when I set or remove a class, inject or take out all my available sessions from that class. Also update to our object in tutors firebase
//You save when you exit. The back button is intentionally called SAVE. You can also have a cancel button to the top right of your custom nav bar and it will say cancel.
//keep a list of all the classes that you've deselected and selected. When you hit the save button, put all the newly selected ones into the save function, and the deselected ones into the delete function
