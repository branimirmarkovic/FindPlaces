//
//  DefaultNotificationService.swift
//  FindPlaces
//
//  Created by Branimir Markovic on 19.4.22..
//

import Foundation

class DefaultNotificationService: NotificationService {

    var spinner: Spinner = SystemSpinner()
    var dropdownNotification: DropdownNotification = DefaultDropdownNotification()

}
