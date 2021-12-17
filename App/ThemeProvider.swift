//
//  ThemeProvider.swift
//  App
//
//  Created by Branimir Markovic on 17.12.21..
//

import UIKit

protocol ThemeManager {
    var mainColor: UIColor {get}
    var tintColor: UIColor {get}
    var textColor: UIColor {get}

    static var shared: ThemeManager {get}
}


class ThemeProvider: ThemeManager {
    var mainColor: UIColor {
        UIColor()
    }

    var tintColor: UIColor {
        UIColor()
    }

    var textColor: UIColor {
        UIColor()
    }

    static var shared:ThemeManager = ThemeProvider()

}
