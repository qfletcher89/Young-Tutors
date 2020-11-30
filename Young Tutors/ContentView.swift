//
//  ContentView.swift
//  Young Tutors
//
//  Created by Kendall Easterly on 11/18/20.
//

import SwiftUI

struct ContentView: View {
    
    @State var view = ""
    
    var body: some View {
        
        if view == "" {
            VStack {
                
                Button(action: {
                    view = "student"
                }, label: {
                    Text("student")
                })
                
                Button(action: {
                    view = "tutor"
                }, label: {
                    Text("tutor")
                })
                
            }
        } else if view == "student" {
            
            ContainerView()
            
        } else if view == "tutor" {
            TutorContainerView()
        }
        
        
    }
}
