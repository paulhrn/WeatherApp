//
//  GeoModel.swift
//  WeatherApp
//
//  Created by p h on 06.09.2022.
//

import Foundation
import CoreLocation

struct GeoModel: Codable {
    var city: String
    var lat: CLLocationDegrees
    var lon: CLLocationDegrees
}
