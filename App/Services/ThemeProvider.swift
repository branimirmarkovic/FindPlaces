//
//  ThemeProvider.swift
//  App
//
//  Created by Branimir Markovic on 17.12.21..
//

import UIKit

protocol ThemeManager {
    var mainColor: UIColor {get}
    var backgroundColor: UIColor {get}
    var tintColor: UIColor {get}

    static var main: ThemeManager {get}
}


class ThemeProvider: ThemeManager {
    
    var backgroundColor: UIColor {
        UIColor(hex: "EBEDF3")!
    }

    var mainColor: UIColor {
        UIColor(hex: "6699CC")!
    }

    var tintColor: UIColor {
        UIColor(hex: "003B6D")!
    }

    static var main:ThemeManager = ThemeProvider()

}
