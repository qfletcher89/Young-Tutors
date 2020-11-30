//
//  TutorContainerView.swift
//  Young Tutors
//
//  Created by Kendall Easterly on 11/27/20.
//

import SwiftUI
import FirebaseAuth

struct TutorContainerView: View {
    
    let model = TutorDataModel()
    let subjectsModel = SubjectsModel()
    @State var selection = 0
    
    var body: some View {
        
        if Auth.auth().currentUser != nil {
            TabView(selection: $selection) {
                
                AdditionalDivider(content: TutorSubjectsView(subjectsModel: subjectsModel).environmentObject(model))
                    .tabItem {
                        Image("classes")
                    }
                    .tag(0)
                
            }.onAppear {
                model.getData()
                subjectsModel.getSubjects()
            }
        } else {
            
            LandingScreen()
            
        }
        
        
    }
}

struct TutorContainerView_Previews: PreviewProvider {
    static var previews: some View {
        TutorContainerView()
    }
}
