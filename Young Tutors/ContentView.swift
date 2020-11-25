//
//  ContentView.swift
//  Young Tutors
//
//  Created by Kendall Easterly on 11/18/20.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var model = ClassModel()
    var subject: Subject
    @State var classes = [Class]()
    
    init(subject: Subject) {
        
        self.subject = subject
//        model.getClasses(for: subject)
        print("content view for \(subject.id) was initialized)")
    }
    
    var body: some View {
        
        VStack {
            Text("hello hello")
            
            ForEach(self.classes) {course in
                
                Text(course.name)
                
            }
        }.onAppear {
            model.getClasses(for: subject) { (classes) in
                self.classes = classes
                print("were done")
            }
        }
        
    }
}

