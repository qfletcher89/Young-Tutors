//
//  ProgressHUD.swift
//  Young Tutors
//
//  Created by Kendall Easterly on 12/10/20.
//

import SwiftUI

struct ProgressHUD: View {
    
    var placeholder: String
    @Binding var show: Bool
    @State var animate = false
    
    var body: some View {
        
        VStack {
            Circle()
                .stroke(AngularGradient(gradient: .init(colors: [Color.primary, Color.primary.opacity(0)]), center: .center))
                .frame(width: 80, height: 80, alignment: .center)
                .rotationEffect(.init(degrees: animate ? 360 : 0))
            
            Text(placeholder)
                .fontWeight(.semibold)
            
        }
        .padding(.vertical, 25)
        .padding(.horizontal, 35)
        .background(BlurView())
        .cornerRadius(15)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            
            Color.clear
                .onTapGesture {
                    withAnimation {
                        show.toggle()
                    }
                }
            
        )
        .onAppear {
            withAnimation(Animation
                            .linear(duration: 1.5)
                            .repeatForever(autoreverses: false)) {
                animate.toggle()
            }
        }
    }
}

struct BlurView: UIViewRepresentable {
    
    
    func makeUIView(context: Context) -> some UIView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemThinMaterial))
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
}
