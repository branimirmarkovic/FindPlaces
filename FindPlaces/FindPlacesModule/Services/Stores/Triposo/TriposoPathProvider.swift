//
//  TriposoPathProvider.swift
//  App
//
//  Created by Branimir Markovic on 12.1.22..
//

import Foundation


enum OrderOptions: String{
    case distance = "distance"
    case score = "-score"
}


class TriposoPathProvider {

    static let main = TriposoPathProvider()

    private init() {}

    var basePath: String {
        "https://www.triposo.com/api/20211011/"
    }

    func locations(latitude: Double, longitude: Double) -> String {
        "location.json?type=city&order_by=distance&annotate=distance:\(latitude),\(longitude)&distance=50000"
    }
    
    func tags(cityLabelName: String ) -> String {
        "tag.json?location_id=\(cityLabelName)&order_by=-score&count=25&fields=name,poi_count,score,label"

    }

     
}
