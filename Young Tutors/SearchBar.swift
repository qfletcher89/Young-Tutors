//
//  SearchBar.swift
//  Young Tutors
//
//  Created by Kendall Easterly on 12/10/20.
//

import SwiftUI

struct SearchBar: View {
    
    @Binding var searchFieldText: String
    @Binding var customSearchText: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.tertiaryLabel)
            
            TextField("Search", text: $searchFieldText) { (changing) in } onCommit: {
                self.hideKeyboard()
                self.searchFieldText = ""
            }.onChange(of: searchFieldText) { (value) in
                withAnimation(Animation.easeInOut(duration: 0.4)) {
                    
                    self.customSearchText = value
                    
                }
            }
            
            Spacer()
            
            Button {
                self.searchFieldText = ""
                self.hideKeyboard()
            } label: {
                Image(systemName: "xmark.circle")
                    .foregroundColor(.secondaryLabel)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(RoundedRectangle(cornerRadius: 15)
                        .foregroundColor(.tertiarySystemFill))
    }
}
