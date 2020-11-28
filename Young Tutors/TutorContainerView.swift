//
//  TutorContainerView.swift
//  Young Tutors
//
//  Created by Kendall Easterly on 11/27/20.
//

import SwiftUI

struct TutorContainerView: View {
    
    @EnvironmentObject var model: TutorDataModel
    let subjectsModel = SubjectsModel()
    @State var selection = 1
    
    var body: some View {
        
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
        
    }
}

struct TutorContainerView_Previews: PreviewProvider {
    static var previews: some View {
        TutorContainerView()
    }
}
