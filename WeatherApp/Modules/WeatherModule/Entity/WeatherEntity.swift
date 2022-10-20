//
//  WeatherEntity.swift
//  WeatherApp
//
//  Created by p h on 03.09.2022.
//

import Foundation

struct WeatherEntity: Codable {
    var city: String
    var lat: Double
    var lon: Double
    var currentTemp: Double
    var minTemp: Double
    var maxTemp: Double
    var desc: String
    var feelsLike: Double
    var humidity: Int
    var windSpeed: Double
    var sunrise: Int
    var sunset: Int
    var hourlyForecast: [Hourly]
    var dailyForecast: [Daily]
    var icon: String
}
