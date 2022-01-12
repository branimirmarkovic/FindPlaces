//
//  TriposoPathProvider.swift
//  App
//
//  Created by Branimir Markovic on 12.1.22..
//

import Foundation
import CoreLocation


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
// TODO: - fix this default value
    func tags(cityLabelName: String ) -> String {
        "tag.json?location_id=\(cityLabelName)&order_by=-score&count=25&fields=name,poi_count,score,label"

    }

     func places(tagLabel: String, latitude: Double, longitude: Double, distance: Int, orderBy: OrderOptions) -> String {
        "poi.json?tag_labels=\(tagLabel)&count=25&fields=id,name,score,price_tier,coordinates,intro,tags,images&order_by=\(orderBy.rawValue)&annotate=distance:\(latitude),\(longitude)&distance=<\(distance)"
    }
}
