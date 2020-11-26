//
//  Color+Extension.swift
//  Young Tutors
//
//  Created by Kendall Easterly on 11/18/20.
//

import SwiftUI

extension View {
    
    func cs() -> Colors {
        return Colors()
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func centered() -> some View {
        
        return self.modifier(Centered())
        
    }
    
    func customNavBar(proxy: GeometryProxy,
                      title: String,
                      _ leading: Button<Image>?,
                      _ trailing: Button<Image>?) -> some View {
        
        return self.modifier(CustomNavBar(title: title, leading: leading, trailing: trailing, proxy: proxy))
        
    }
    
}

struct Centered: ViewModifier {
    
    func body(content: Content) -> some View {
        
        HStack {
            
            Spacer()
            
            content
            
            Spacer()
            
        }
    }
}

struct CustomNavBar: ViewModifier {
    
    var title: String
    var leading: Button<Image>?
    var trailing: Button<Image>?
    var proxy: GeometryProxy
    
    func body(content: Content) -> some View {
        
        ZStack(alignment: .top) {
            
            content
                .padding(.top, proxy.safeAreaInsets.top)
                .padding(.top)
//                .padding(.top)
            
            VStack {
                VStack {
                    
                    HStack {
                        
                        if let leadingItem = leading {
                            
                            leadingItem
                            
                        }
                        
                        Spacer()
                        
                        if let trailingItem = trailing {
                            
                            trailingItem
                            
                        }
                    }.overlay(Text(title)
                                .font(.title2)
                                .fontWeight(.bold))
                    
                    .padding()
                    
                    Divider()
                    
                }
                .padding(.top, proxy.safeAreaInsets.top)
                .background(Rectangle().foregroundColor(Color(UIColor.systemBackground)))
                .edgesIgnoringSafeArea(.top)
                
                Spacer()
                
            }
            
        }
        
    }
    
}


class Colors {
    
    let black = Color(#colorLiteral(red: 0.16862745583057404, green: 0.16862745583057404, blue: 0.16862745583057404, alpha: 1))
    let darkGrey = Color(#colorLiteral(red: 0.501960813999176, green: 0.5490196347236633, blue: 0.5529412031173706, alpha: 1))
    let grey = Color(#colorLiteral(red: 0.7450980544090271, green: 0.7686274647712708, blue: 0.7843137383460999, alpha: 1))
    let sand = Color(#colorLiteral(red: 0.9411764740943909, green: 0.8705882430076599, blue: 0.7176470756530762, alpha: 1))
    
    let red  = Color(#colorLiteral(red: 0.9019607901573181, green: 0.30588236451148987, blue: 0.25882354378700256, alpha: 1))
    let maroon = Color(#colorLiteral(red: 0.47058823704719543, green: 0.1921568661928177, blue: 0.1725490242242813, alpha: 1))
    let brown = Color(#colorLiteral(red: 0.3686274588108063, green: 0.2705882489681244, blue: 0.21176470816135406, alpha: 1))
    let coffe = Color(#colorLiteral(red: 0.6392157077789307, green: 0.5254902243614197, blue: 0.45098039507865906, alpha: 1))
    
    let watermelon = Color(#colorLiteral(red: 0.929411768913269, green: 0.45098039507865906, blue: 0.4901960790157318, alpha: 1))
    let orange = Color(#colorLiteral(red: 0.8980392217636108, green: 0.49803921580314636, blue: 0.1921568661928177, alpha: 1))
    let yellow = Color(#colorLiteral(red: 0.9960784314, green: 0.6588235294, blue: 0.1607843137, alpha: 1))
    let lime = Color(#colorLiteral(red: 0.6509804129600525, green: 0.7764706015586853, blue: 0.27450981736183167, alpha: 1))
    
    let teal = Color(#colorLiteral(red: 0.23529411852359772, green: 0.43921568989753723, blue: 0.501960813999176, alpha: 1))
    let mint = Color(#colorLiteral(red: 0.16470588743686676, green: 0.7372549176216125, blue: 0.615686297416687, alpha: 1))
    let green = Color(#colorLiteral(red: 0.2235294133424759, green: 0.7960784435272217, blue: 0.4588235318660736, alpha: 1))
    let forestGreen = Color(#colorLiteral(red: 0.21176470816135406, green: 0.37254902720451355, blue: 0.25882354378700256, alpha: 1))
    
    let navyBlue = Color(#colorLiteral(red: 0.48627451062202454, green: 0.5529412031173706, blue: 0.7215686440467834, alpha: 1))
    let skyBlue = Color(#colorLiteral(red: 0.23137255012989044, green: 0.6039215922355652, blue: 0.8509804010391235, alpha: 1))
    let ice = Color(#colorLiteral(red: 0.7254902124404907, green: 0.7921568751335144, blue: 0.9411764740943909, alpha: 1))
    let pink = Color(#colorLiteral(red: 0.9529411792755127, green: 0.49803921580314636, blue: 0.7647058963775635, alpha: 1))
    
    let plum = Color(#colorLiteral(red: 0.364705890417099, green: 0.21176470816135406, blue: 0.364705890417099, alpha: 1))
    let blue = Color(#colorLiteral(red: 0.3176470696926117, green: 0.40392157435417175, blue: 0.6274510025978088, alpha: 1))
    let purple = Color(#colorLiteral(red: 0.4588235318660736, green: 0.3803921639919281, blue: 0.7647058963775635, alpha: 1))
    let magenta = Color(#colorLiteral(red: 0.6078431606292725, green: 0.364705890417099, blue: 0.7098039388656616, alpha: 1))
    
    let white = Color(#colorLiteral(red: 0.929411768913269, green: 0.9450980424880981, blue: 0.9490196108818054, alpha: 1))
    let background = Color(UIColor.systemBackground)
    
    let background6 = Color(UIColor.secondarySystemBackground)
    let card = Color(red: 142 / 255, green: 142 / 255, blue: 147 / 255)
    
}
