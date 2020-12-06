//
//  TutorContainerView.swift
//  Young Tutors
//
//  Created by Kendall Easterly on 11/27/20.
//

import SwiftUI

struct TutorContainerView: View {
    
    let model = TutorDataModel()
    let subjectsModel = SubjectsModel()
    @State var selection = 0
    
    var body: some View {
        
        
            TabView(selection: $selection) {
                
                AdditionalDivider(content: TutorSubjectsView(subjectsModel: subjectsModel).environmentObject(model))
                    .tabItem {
                        Image(selection == 1 ? "classes-red" : "classes")
                    }
                    .tag(0)
                
                AdditionalDivider(content: EventsView().environmentObject(model))
                    .tabItem {
                        Image(selection == 1 ? "calendar-red" : "calendar")
                    }
                    .tag(1)
                
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
