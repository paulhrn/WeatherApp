//
//  FavouritesModel.swift
//  WeatherApp
//
//  Created by p h on 03.09.2022.
//

import Foundation

struct FavouritesModel: Codable {
    var name: String
    var country: String
    var lat: Double
    var lon: Double
}
