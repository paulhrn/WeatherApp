//
//  WeatherEntity(Raw).swift
//  WeatherApp
//
//  Created by p h on 03.09.2022.
//

import Foundation

struct WeatherRawEntity: Codable {
    let lat: Double
    let lon: Double
    let current: Current
    let hourly: [Hourly]
    let daily: [Daily]
}

struct Current: Codable {
    let temp: Double
    var feels_like: Double
    let humidity: Int
    let wind_speed: Double
    let sunrise: Int
    let sunset: Int
    let weather: [Weather]
}

struct Weather: Codable {
    let main: String
    let description: String
    let icon: String
}

struct Hourly: Codable {
    let dt: Double
    let temp: Double
    let weather: [WeatherHourlyIcons]
}

struct WeatherHourlyIcons: Codable {
    let icon: String
}

struct Daily: Codable {
    let dt: Double
    let temp: Temp
    let weather: [WeatherDailyIcons]
}

struct Temp: Codable {
    let min: Double
    let max: Double
}

struct WeatherDailyIcons: Codable {
    let icon: String
}
