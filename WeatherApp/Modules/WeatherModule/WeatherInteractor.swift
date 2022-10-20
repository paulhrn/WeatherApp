//
//  WeatherInteractor.swift
//  WeatherApp
//
//  Created by p h on 09.09.2022.
//

import Foundation
import CoreLocation

protocol WeatherInteractorOutput: AnyObject {
    func updateWeather(entity: WeatherEntity)
    func updateBackground(nodes: [String], gradient: [String])
}

class WeatherInteractor: NSObject {
    weak var output: WeatherInteractorOutput?
    
    var locationService: LocationService!
    var coreDataService: CoreDataService?
    var weatherService: WeatherService!
    var backgroundService: BackgroundService!
    
    var locationManager = CLLocationManager()
    var currentLocation = CLLocation()
    
    var isConnected: Bool = false
    
    // MARK: - Protocol funcs
    func locationAccessRequest() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func checkConnection() {
        if !isConnected {
            guard let entity = loadEntity() else { return }
            output?.updateWeather(entity: entity)
        }
    }
    
    func getWeatherData(geoModel: GeoModel) {
        weatherService.loadWeatherData(lat: geoModel.lat, lon: geoModel.lon, completion: { [weak self] jsonData in
            self?.setupEntity(jsonData: jsonData, geoModel: geoModel)
        })
    }
    
    // MARK: - Private funcs
    private func saveEntity(entity: WeatherEntity) {
        let encoder = JSONEncoder()
        let data = try? encoder.encode(entity)
        coreDataService?.setData(key: StorageEnum.weatherStorageKey, value: data)
    }
    
    private func loadEntity() -> WeatherEntity? {
        let decoder = JSONDecoder()
        guard let data = coreDataService?.getData(key: StorageEnum.weatherStorageKey) else { return try? decoder.decode(WeatherEntity.self, from: Data()) }
        let entity = try? decoder.decode(WeatherEntity.self, from: data)
        return entity
    }
    
    private func entity(jsonData: WeatherRawEntity, geoModel: GeoModel, currentTemp: Int, minTemp: Int, maxTemp: Int, feelsLike: Int) {
        let city = geoModel.city
        let lat = geoModel.lat
        let lon = geoModel.lon
        let desc = jsonData.current.weather[0].description
        let humidity = jsonData.current.humidity
        let windSpeed = jsonData.current.wind_speed
        let sunrise = jsonData.current.sunrise
        let sunset = jsonData.current.sunset
        let icon = jsonData.current.weather.first?.icon ?? ""
        let entity = WeatherEntity(
            city: city,
            lat: lat,
            lon: lon,
            currentTemp: Double(currentTemp),
            minTemp: Double(minTemp),
            maxTemp: Double(maxTemp),
            desc: desc,
            feelsLike: Double(feelsLike),
            humidity: humidity,
            windSpeed: windSpeed,
            sunrise: sunrise,
            sunset: sunset,
            hourlyForecast: jsonData.hourly,
            dailyForecast: jsonData.daily,
            icon: icon)
        saveEntity(entity: entity)
        output?.updateWeather(entity: entity)
        output?.updateBackground(
            nodes: backgroundService.backgroundAnimations(entity: entity),
            gradient: backgroundService.backgroundGradient(entity: entity))
    }
    
    private func setupEntity(jsonData: WeatherRawEntity, geoModel: GeoModel) {
        if #available(iOS 16, *) {
            if "\(UnitTemperature(forLocale: Locale.current))".contains("F") {
                entity(jsonData: jsonData, geoModel: geoModel,
                       currentTemp: jsonData.current.temp.kelvinToFahrenheit().toInt(),
                       minTemp: Double(jsonData.daily[0].temp.min).kelvinToFahrenheit().toInt(),
                       maxTemp: Double(jsonData.daily[0].temp.max).kelvinToFahrenheit().toInt(),
                       feelsLike: Double(jsonData.current.feels_like).kelvinToFahrenheit().toInt())
            } else {
                entity(jsonData: jsonData, geoModel: geoModel,
                       currentTemp: jsonData.current.temp.kelvinToCelsius().toInt(),
                       minTemp: Double(jsonData.daily[0].temp.min).kelvinToCelsius().toInt(),
                       maxTemp: Double(jsonData.daily[0].temp.max).kelvinToCelsius().toInt(),
                       feelsLike: Double(jsonData.current.feels_like).kelvinToCelsius().toInt())
            }
        } else {
            entity(jsonData: jsonData, geoModel: geoModel,
                   currentTemp: jsonData.current.temp.kelvinToCelsius().toInt(),
                   minTemp: Double(jsonData.daily[0].temp.min).kelvinToCelsius().toInt(),
                   maxTemp: Double(jsonData.daily[0].temp.max).kelvinToCelsius().toInt(),
                   feelsLike: Double(jsonData.current.feels_like).kelvinToCelsius().toInt())
        }
    }
    
    private func saveCurrentLocation(geoModel: GeoModel) {
        coreDataService?.saveWeatherModel(model: geoModel)
    }
    
}

// MARK: - Extensions
extension WeatherInteractor: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty {
            self.currentLocation = locations.first ?? CLLocation()
            locationService.getPosition(currentLocation: currentLocation, completion: { [weak self] city, lat, lon, error in
                if error == nil {
                    guard let city = city else { return }
                    guard let lat = lat else { return }
                    guard let lon = lon else { return }
                    let newGeoData = GeoModel.init(city: city, lat: lat, lon: lon)
                    self?.getWeatherData(geoModel: newGeoData)
                    self?.saveCurrentLocation(geoModel: newGeoData)
                    self?.isConnected = true
                }
            })
        }
    }
}
