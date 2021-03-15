//
//  SubjectsView.swift
//  Young Tutors
//
//  Created by Kendall Easterly on 11/18/20.
//

import SwiftUI

struct SubjectsView: View {
    
    
    @ObservedObject var model: SubjectsModel
    @State var searchFieldText = ""
    //I do a custom value so I can animate the changing of the text in search field
    @State var customSearchText = ""
    @State var settingsIsShowing = false
    
    var body: some View {
        
        NavigationView{
            GeometryReader { geometry in
                let boxWidth = geometry.frame(in: .global).width * 0.43
                
                ScrollView {
                    VStack {
                        
                        //Search bar
                        SearchBar(searchFieldText: $searchFieldText, customSearchText: $customSearchText)
                            .padding()
                        HStack(alignment: .top) {
                            
                            ForEach(0..<2) {i in
                                
                                VStack {
                                    ForEach(splitSubjects()[i]) {subject in
                                        
                                        
                                        NavigationLink(destination: ClassView(subject: subject, boxWidth: boxWidth, color: decideColor(for: subject))) {
                                            Card(boxWidth: boxWidth,
                                                 color: decideColor(for: subject),
                                                 mainText: subject.id.capitalized,
                                                 number: subject.count,
                                                 course: nil)
                                                .padding(.bottom)
                                        }.disabled(subject.count == 0 ? true : false)
                                    }
                                    
                                    Spacer()
                                    
                                }.padding(i == 0 ? .leading : .trailing, 20)
                                
                                if i == 0 {
                                    Spacer()
                                }
                                
                            }
                        }
                    }
                }.customNavBar(proxy: geometry, title: "Subjects",
                               Button(action: {
                                self.settingsIsShowing = true
                               }, label: {
                                AnyView(
                                    Image("gear")
                                )
                               }) , Button(action: {
                                self.model.getSubjects()
                            }, label: {
                                AnyView(Image("reload"))
                            }))
                .fullScreenCover(isPresented: $settingsIsShowing, content: {
                    SettingsView()
                })
            }
            .background(Color.background.edgesIgnoringSafeArea(.all))
        }
    }
    
    func decideData() -> [Subject] {
        
        if customSearchText == "" {
            return model.subjects
        } else {
            
            var resultArray = [Subject]()
            
            for subject in model.subjects {
                
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
        
        var left = true
        
        for subject in decideData() {
            
            if left {
                
                leftSubjects.append(subject)
                
                left.toggle()
            } else {
                
                rightSubjects.append(subject)
                
                left.toggle()
            }
        }
        
        let subjectsArray = [leftSubjects, rightSubjects]
        
        return subjectsArray
    }
    
    func decideColor(for subject: Subject) -> Color {
        
        if subject.count != 0 {
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
            default:
                return .csblack
            }
        } else {
            return .quatrentaryLabel
        }
        
    }
    
    
    
}

