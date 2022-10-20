//
//  FavouritesModel(Raw).swift
//  WeatherApp
//
//  Created by p h on 03.09.2022.
//

import Foundation

struct RawFavouritesModel: Codable {
    var name: String
    var country: String
    var coord: Coord
}

struct Coord: Codable {
    var lat: Double
    var lon: Double
}
