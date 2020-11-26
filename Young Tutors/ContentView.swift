//
//  ContentView.swift
//  Young Tutors
//
//  Created by Kendall Easterly on 11/18/20.
//

import SwiftUI

struct ContentView: View {
   
    
    var body: some View {
        NavigationView{
            
            NavigationLink(destination: Text("destinaiot")) {
                Text("line")
            }
            
        }
    }
}

struct DestinationView: View {
    
    var body: some View {
    Text("DestinationView")
        .navigationBarHidden(true)
    }
}
