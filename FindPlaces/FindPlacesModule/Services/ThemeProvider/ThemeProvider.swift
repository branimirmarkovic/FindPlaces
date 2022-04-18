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
}


class ThemeProvider: ThemeManager {
    
    var backgroundColor: UIColor {
        UIColor(hexString: "#EBEDF3")
    }

    var mainColor: UIColor {
        UIColor(hexString: "#6699CC")
    }

    var tintColor: UIColor {
        UIColor(hexString: "#003B6D")
    }

    static let main: ThemeProvider = ThemeProvider()
    
    private init() {}

}
