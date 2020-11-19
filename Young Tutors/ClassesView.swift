//
//  ClassesView.swift
//  Young Tutors
//
//  Created by Kendall Easterly on 11/18/20.
//

import SwiftUI

struct ClassesView: View {
    
    @EnvironmentObject var testModel: TestModel
    var subject: Subject
    
    var body: some View {
        
        
        VStack {
            
            ForEach(testModel.classes) {course in
                Section(header: Text("\(course.levels) \(course.name)")) {
                    List{
                        ForEach(course.sessions) {session in
                            
                            ForEach(session.tutors, id: \.self ) {tutor in
                                
                                HStack {
                                    Text(tutor)
                                    
                                    Spacer()
                                    
                                    Text(session.id)
                                }
                            }
                        }
                    }
                }
            }
            
        }.onAppear {
            
            testModel.getClasses(for: subject)
            
        }
        
    }
}
