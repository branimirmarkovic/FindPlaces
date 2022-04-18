//
//  LocationManager.swift
//  App
//
//  Created by Branimir Markovic on 18.12.21..
//

import Foundation
import CoreLocation


typealias LocationResult = Result<CLLocation, Error>

protocol LocationManager {
    func currentLocation(completion: @escaping(LocationResult) -> Void)
}

