//
//  TutorProfileView.swift
//  Young Tutors
//
//  Created by Kendall Easterly on 12/17/20.
//

import SwiftUI

struct TutorProfileView: View {
    
    @EnvironmentObject var tutorDataModel: TutorDataModel
    @EnvironmentObject var signUpModel: SignUpModel
    
    var body: some View {
        
        Button(action: {
            
            tutorDataModel.signOut({
                signUpModel.setStep(.landing, .disappear)
                //made sure when ur in a modal to dismiss presentation mode
            })
            
        }, label: {
            /*@START_MENU_TOKEN@*/Text("Button")/*@END_MENU_TOKEN@*/
        })
        
    }
}

struct TutorProfileView_Previews: PreviewProvider {
    static var previews: some View {
        TutorProfileView()
    }
}
