//
//  DataCachePolicy.swift
//  FindPlaces
//
//  Created by Branimir Markovic on 14.1.22..
//

import Foundation

enum TimePolicyLimits: TimeInterval{
    case seconds30 = 30
    case oneMinute = 60
    case twoMinutes = 120
    case fiveMinutes = 300
    case tenMinutes = 600
}

protocol TimeValidable {
    var timeStamp: Date {get set}
}

protocol DataCachePolicy {
    var timeLimit: TimeInterval {get set}
    func isDataValid(of object:TimeValidable) -> Bool
}

class DefaultCachePolicy: DataCachePolicy {
     var timeLimit: TimeInterval

    init(_ timeLimit: TimePolicyLimits) {
        self.timeLimit = timeLimit.rawValue
    }

    func isDataValid(of object: TimeValidable) -> Bool {
        let maximumDate = object.timeStamp + timeLimit
        let referenceDate = Date()
        return referenceDate <= maximumDate
    }
}

