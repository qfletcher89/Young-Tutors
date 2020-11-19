//
//  ContentView.swift
//  Young Tutors
//
//  Created by Kendall Easterly on 11/18/20.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        
        NavigationView {
            
            ScrollView {
                
                VStack {
                    ForEach(1..<100) { index in
                        Text("\(index)")
                        
                        
                    }
                    
                    
                }
                
            }
            
        }
    }
}

