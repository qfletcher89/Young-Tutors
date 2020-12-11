//
//  ContentView.swift
//  Young Tutors
//
//  Created by Kendall Easterly on 11/18/20.
//

import SwiftUI

struct ContentView: View {
    
    @State var isShowing = false
    
    var body: some View {
        
        VStack {
            Button(action: {
                isShowing.toggle()
            }, label: {
                Text("animate")
            })
        }
        .addProgressHUD(placeholder: "lookame", isAnimating: $isShowing)
        
    }
}
