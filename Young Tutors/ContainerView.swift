//
//  ContainerView.swift
//  Young Tutors
//
//  Created by Kendall Easterly on 11/21/20.
//

import SwiftUI

struct ContainerView: View {
    
    
    @State var selection = 0
    @ObservedObject var subjectsViewModel = SubjectsModel()
    var tutorsModel = TutorsModel()
    var studentModel = StudentModel()
    @ObservedObject var classModel = ClassModel()
    
    var body: some View {
        
            TabView(selection: $selection) {
                
//                AdditionalDivider(content: HomeView())
//                    .tabItem {
//                        Image(selection == 0 ? "home-red" : "home")
//
//                    }
//                    .tag(0)
                
                AdditionalDivider(content: SubjectsView(model: subjectsViewModel).environmentObject(tutorsModel).environmentObject(classModel))
                    .tabItem {
                        Image(selection == 0 ? "classes-red" : "classes")
                    }
                    .tag(0)
                
                AdditionalDivider(content:TutorsView(model: tutorsModel))
                    .tabItem {
                        Image(selection == 1 ? "tutors-red" : "tutors")
                    }
                    .tag(1)
                
                
                AdditionalDivider(content: CalendarView(tutorsModel: tutorsModel)
                                    .environmentObject(studentModel))
                    .tabItem {
                        Image(selection == 2 ? "calendar-red" : "calendar")
                    }
                    .tag(2)
                
                AdditionalDivider(content: ProfileView())
                    .tabItem {
                        Image(selection == 3 ? "profile-red" : "profile")
                    }
                    .tag(3)
                
            }.hud(isActive: $subjectsViewModel.hudIsActive, type: subjectsViewModel.hudType)
            .hud(isActive: $classModel.hudIsActive, type: classModel.hudType)
            .onAppear {
                
                subjectsViewModel.getSubjects()
                tutorsModel.getTutors()
                studentModel.getEvents()
                
            }
        
    }
}

struct AdditionalDivider<Content: View>: View {
    
    var content: Content
    
    @ViewBuilder var body: some View {
        
        ZStack(alignment: .bottom) {
            
            content
            
            Divider()
            
        }
        
    }
    
}
