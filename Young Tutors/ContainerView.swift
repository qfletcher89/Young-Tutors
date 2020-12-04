//
//  ContainerView.swift
//  Young Tutors
//
//  Created by Kendall Easterly on 11/21/20.
//

import SwiftUI

struct ContainerView: View {
    
    @State var selection = 3
    var subjectsViewModel = SubjectsModel()
    var tutorsModel = TutorsModel()
    var studentModel = StudentModel()
    
    var body: some View {

            
            
            TabView(selection: $selection) {
                
                AdditionalDivider(content: HomeView())
                    .tabItem {
                        Image(selection == 0 ? "home-red" : "home")
                            
                    }
                    .tag(0)
                
                AdditionalDivider(content: SubjectsView(model: subjectsViewModel).environmentObject(tutorsModel))
                    .tabItem {
                        Image(selection == 1 ? "classes-red" : "classes")
                    }
                    .tag(1)
                
                AdditionalDivider(content:TutorsView(model: tutorsModel))
                    .tabItem {
                        Image(selection == 2 ? "tutors-red" : "tutors")
                    }
                    .tag(2)
                
                
                AdditionalDivider(content: CalendarView(tutorsModel: tutorsModel)
                                    .environmentObject(studentModel))
                    .tabItem {
                        Image(selection == 3 ? "calendar-red" : "calendar")
                    }
                    .tag(3)
                
                AdditionalDivider(content: NotificationsView())
                    .tabItem {
                        Image(selection == 4 ? "notifications-red" : "notifications")
                    }
                    .tag(4)
                
            }.onAppear {
                
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
