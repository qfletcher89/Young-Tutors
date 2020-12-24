//
//  Color+Extension.swift
//  Young Tutors
//
//  Created by Kendall Easterly on 12/23/20.
//

import SwiftUI

enum SystemColor {
    
    case label
    case secondaryLabel
    case tertiaryLabel
    case quatrentaryLabel
    
    case background
    case secondaryBackground
    case tertiaryBackground
    
    case tertiarySystemFill
    case quatrentarySystemFill
    
}

extension Color {
    
    
    public static var label: Color {
        return Color(UIColor.label)
    }
    public static var secondaryLabel: Color {
        return Color(UIColor.secondaryLabel)
    }
    public static var tertiaryLabel: Color {
        return Color(UIColor.tertiaryLabel)
    }
    public static var quatrentaryLabel: Color {
        return Color(UIColor.quaternaryLabel)
    }
    public static var background: Color {
        return Color(UIColor.systemBackground)
    }
    public static var secondaryBackground: Color {
        return Color(UIColor.secondarySystemBackground)
    }
    public static var tertiaryBackground: Color {
        return Color(UIColor.tertiarySystemBackground)
    }
    public static var tertiarySystemFill: Color {
        return Color(UIColor.tertiarySystemFill)
    }
    
    public static var quatrentarySystemFill: Color {
        return Color(UIColor.quaternarySystemFill)
    }
    
    public static var csblack: Color {
        return Colors().black
    }
    public static var csdarkGrey: Color {
        return Colors().darkGrey
    }
    public static var csgrey: Color {
        return Colors().grey
    }
    public static var cssand: Color {
        return Colors().sand
    }
    public static var csred: Color {
        return Colors().red
    }
    public static var csmaroon: Color {
        return Colors().maroon
    }
    public static var csbrown: Color {
        return Colors().brown
    }
    public static var cscoffe: Color {
        return Colors().coffe
    }
    public static var cswatermelon: Color {
        return Colors().watermelon
    }
    public static var csorange: Color {
        return Colors().orange
    }
    public static var csyellow: Color {
        return Colors().yellow
    }
    public static var cslime: Color {
        return Colors().lime
    }
    public static var csteal: Color {
        return Colors().teal
    }
    public static var csmint: Color {
        return Colors().mint
    }
    public static var csgreen: Color {
        return Colors().green
    }
    public static var csforestGreen: Color {
        return Colors().forestGreen
    }
    public static var csnavyBlue: Color {
        return Colors().navyBlue
    }
    public static var csskyBlue: Color {
        return Colors().skyBlue
    }
    public static var csice: Color {
        return Colors().ice
    }
    public static var cspink: Color {
        return Colors().pink
    }
    public static var csplum: Color {
        return Colors().plum
    }
    public static var csblue: Color {
        return Colors().blue
    }
    public static var cspurple: Color {
        return Colors().purple
    }
    public static var csmagenta: Color {
        return Colors().magenta
    }
    
}
