//
//  ContentView.swift
//  Young Tutors
//
//  Created by Kendall Easterly on 11/18/20.
//

import SwiftUI


struct ContentView: View {
    
    @State var isShowing = false
    @State var type: TTProgressHUDType = .Loading
    
    var body: some View {
        
        
        Button(action: {isShowing.toggle()}) {
            Text("show")
        }//.fullScreenCover(isPresented: $isShowing, content: {TestSubView()})
        
    }
    
    func executable() {
        
        let array = [String]()
        let dictionary = [String:String]()
        
        let arrayValue = array[0]
        let dictionaryValue = dictionary["Me"]
        
        
        
    }
    
}


//struct TestSubView: View {
//
//
//    var body: some View {
//
//        Slider
//
//
//
//    }
//
//}
