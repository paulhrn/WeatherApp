//
//  FavouritesEntity.swift
//  WeatherApp
//
//  Created by p h on 08.09.2022.
//

import Foundation

struct Favourites: Codable {
    var locations: [LocationModel]
}

struct LocationModel: Codable {
    var cityName: String
    var lat: Double
    var lon: Double
    var subTitle: String
    var weatherDesc: String
    var temp: Double
    var minTemp: Double
    var maxTemp: Double
    var icon: String
}
