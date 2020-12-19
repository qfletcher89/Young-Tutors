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
        
        ZStack {
            HStack {
                TestSubView(string: "loading", type: .Loading, globalType: $type, isLoading: $isShowing)
                
                TestSubView(string: "success", type: .Success, globalType: $type, isLoading: $isShowing)
                
                TestSubView(string: "error", type: .Error, globalType: $type, isLoading: $isShowing)
                
                TestSubView(string: "warning", type: .Warning, globalType: $type, isLoading: $isShowing)
            }
            
            TTProgressHUD($isShowing, config: getConfig())
            
            
        }
    }
    
    func getConfig() -> TTProgressHUDConfig {
        
        TTProgressHUDConfig(type: type, lineWidth: 1, imageViewSize: CGSize(width: 100, height: 100), shouldAutoHide: true, autoHideInterval: 1.5)
        
    }
    
}


struct TestSubView: View {
    
    
    var string: String
    var type: TTProgressHUDType
    @Binding var globalType: TTProgressHUDType
    @Binding var isLoading: Bool
    
    
    var body: some View {
        
        Button {
            globalType = type
            isLoading.toggle()
        } label: {
            VStack {
                Text(String(string))
                
                
                Spacer()
            }
            
        }

        
        
    }
    
}
