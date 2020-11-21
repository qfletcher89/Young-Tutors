//
//  SubjectsView.swift
//  Young Tutors
//
//  Created by Kendall Easterly on 11/18/20.
//

import SwiftUI

struct SubjectsView: View {
    
    @ObservedObject var model = SubjectsModel()
    @State var searchFieldText = ""
    //I do a custom value so I can animate the changing of the text in search field
    @State var customSearchText = ""
    
    var body: some View {
        
        NavigationView{
            GeometryReader { geometry in
                let boxWidth = geometry.frame(in: .global).width * 0.43
                
                ScrollView {
                    VStack {
                        
                        Button {
                            model.uploadData()
                        } label: {
                            Text("upload data")
                        }
                        
//                        Search Bar
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
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                        .background(RoundedRectangle(cornerRadius: 15)
                                        .foregroundColor(self.cs().black))
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                        
                        HStack {

                            VStack {
                                ForEach(splitSubjects()[0]) {subject in
                                    
                                    
                                    NavigationLink(destination: ClassView(subject: subject, boxWidth: boxWidth, color: decideColor(for: subject))) {
                                        Card(boxWidth: boxWidth,
                                             color: decideColor(for: subject),
                                             mainText: subject.id,
                                             number: subject.count,
                                             isFromSubjectView: true)
                                            .padding(.bottom)
                                    }
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
                                             isFromSubjectView: true)
                                            .padding(.bottom)
                                    }
                                }
                                
                                Spacer()
                                
                            }.padding(.trailing, 20)
                            
                        }.padding(.top)
                        
                    }
                }
                
                .onAppear {
                    model.getSubjects()
                }
            }.navigationTitle(Text("Schedule a Session"))
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
    }
    
    
    
}

