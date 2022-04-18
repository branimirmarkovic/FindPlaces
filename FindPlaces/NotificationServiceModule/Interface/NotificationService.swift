//
//  NotificationService.swift
//  App
//
//  Created by Branimir Markovic on 18.12.21..
//

import Foundation
import UIKit

protocol NotificationService {
    var spinner: Spinner {get set}
    var dropdownNotification: DropdownNotification {get set}
    func showSpinner(on caller: UIView)
    func stopSpinner()
    func showDropdownNotification(message: String)
}

extension NotificationService {
    func showSpinner(on caller: UIView) {
        self.spinner.startAnimating(on: caller)
    }
    func stopSpinner() {
        self.spinner.stopAnimating()
    }
    func showDropdownNotification(message: String) {
        dropdownNotification.showNotification(message: message)
    }

}


protocol Spinner {
    func startAnimating(on caller: UIView)
    func stopAnimating()
}



protocol DropdownNotification {
    var showTime: TimeInterval {get set}
    func showNotification(message: String)
}







