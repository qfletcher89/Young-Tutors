//
//  Image+Extension.swift
//  Young Tutors
//
//  Created by Kendall Easterly on 12/24/20.
//

import SwiftUI

extension Image {
    //rendering mode and add color shortcut
    func renderedColor(_ color: Color) -> some View {
        return self
            .renderingMode(.template)
            .foregroundColor(color)
    }
    
    func renderedColor() -> some View {
        return self
            .renderingMode(.template)
            .foregroundColor(.cswatermelon)
    }
    
}

//struct RenderedColor: ViewModifier {
//
//    func body(content: Content) -> some View {
//
//        content
//
//
//    }
//
//}
