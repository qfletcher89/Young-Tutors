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
                            
                            VStack {
                                ForEach(splitSubjects()[0]) {subject in
                                    
                                    
                                    NavigationLink(destination: ClassView(subject: subject, boxWidth: boxWidth, color: decideColor(for: subject))) {
                                        Card(boxWidth: boxWidth,
                                             color: decideColor(for: subject),
                                             mainText: subject.id,
                                             number: subject.count,
                                             course: nil)
                                            .padding(.bottom)
                                    }.disabled(subject.count == 0 ? true : false)
                                }
                                
                                Spacer()
                                
                            }.padding(.leading, 20)
                            
                            Spacer()
                            
                            VStack {
                                ForEach(splitSubjects()[1]) {subject in
                                    
                                    NavigationLink(destination: ClassView(subject: subject, boxWidth: boxWidth, color: decideColor(for: subject))) {
                                        Card(boxWidth: boxWidth,
                                             color: decideColor(for: subject),
                                             mainText: subject.id,
                                             number: subject.count,
                                             course: nil)
                                            .padding(.bottom)
                                    }.disabled(subject.count == 0 ? true : false)
                                }
                                
                                Spacer()
                                
                            }.padding(.trailing, 20)
                            
                        }
                    }
                }//.addProgressHUD(isAnimating: $model.hudShowing)
                .customNavBar(proxy: geometry, title: "Subjects", trailing: Button(action: {
                    self.model.getSubjects()
                  }, label: {
                    AnyView(Image("reload"))
                  }))
            }//.navigationBarTitle("")
//            .navigationBarHidden(true)
            .background(self.cs().background.edgesIgnoringSafeArea(.all))
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
        } else {
            return Color(UIColor.quaternaryLabel)
        }
        
    }
    
    
    
}

