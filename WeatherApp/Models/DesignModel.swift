//
//  DesignModel.swift
//  WeatherApp
//
//  Created by p h on 06.09.2022.
//

import Foundation

struct CellsAnimationModel: Codable {
    var nodes: [String]
    var gradient: [String]
}

struct WeatherIconsModel {
    var iconsDict = ["01d": "sun.max.fill",
                     "02d": "cloud.sun.fill",
                     "03d": "cloud.fill",
                     "04d": "smoke.fill",
                     "09d": "cloud.drizzle.fill",
                     "10d": "cloud.sun.rain.fill",
                     "11d": "cloud.bolt.rain.fill",
                     "13d": "snowflake",
                     "50d": "cloud.fog.fill",
                     
                     "01n": "moon.stars.fill",
                     "02n": "cloud.moon.fill",
                     "03n": "cloud.fill",
                     "04n": "smoke.fill",
                     "09n": "cloud.drizzle.fill",
                     "10n": "cloud.moon.rain.fill",
                     "11n": "cloud.bolt.rain.fill",
                     "13n": "snowflake",
                     "50n": "cloud.fog.fill"]
}

struct SpriteKitNodes {
    let nodes: [String: [String]] = ["01d": ["Sun"],
                                     "02d": ["Sun", "Clouds"],
                                     "03d": ["Clouds"],
                                     "04d": ["Clouds"],
                                     "09d": ["Rain", "Clouds"],
                                     "10d": ["Rain", "Clouds"],
                                     "11d": ["Rain", "Clouds"],
                                     "13d": ["Snow", "Clouds"],
                                     "50d": ["Fog", "Clouds"],
                                     
                                     "01n": ["Stars"],
                                     "02n": ["Stars", "Clouds"],
                                     "03n": ["Clouds"],
                                     "04n": ["Clouds"],
                                     "09n": ["Rain", "Clouds"],
                                     "10n": ["Rain", "Clouds"],
                                     "11n": ["Rain", "Clouds"],
                                     "13n": ["Stars", "Snow", "Clouds"],
                                     "50n": ["Stars", "Fog", "Clouds"]]
}

struct GradientColors {
    let colors: [String: [String]] = ["01d": ["#A2C4FD", "#C3E9FB"],
                                      "02d": ["#A2C4FD", "#C3E9FB"],
                                      "03d": ["#506083", "#424D67"],
                                      "04d": ["#506083", "#424D67"],
                                      "09d": ["#1F2631", "#313D53"],
                                      "10d": ["#1F2631", "#313D53"],
                                      "11d": ["#1F2631", "#313D53"],
                                      "13d": ["#6D7892", "#444D5F"],
                                      "50d": ["#1F2631", "#313D53"],
                                      
                                      "01n": ["#23282C", "#171A1C"],
                                      "02n": ["#23282C", "#171A1C"],
                                      "03n": ["#23282C", "#171A1C"],
                                      "04n": ["#23282C", "#171A1C"],
                                      "09n": ["#23282C", "#171A1C"],
                                      "10n": ["#23282C", "#171A1C"],
                                      "11n": ["#23282C", "#171A1C"],
                                      "13n": ["#23282C", "#171A1C"],
                                      "50n": ["#23282C", "#171A1C"]]
}
