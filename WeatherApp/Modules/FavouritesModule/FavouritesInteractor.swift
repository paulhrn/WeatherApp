//
//  FavouritesInteractor.swift
//  WeatherApp
//
//  Created by p h on 09.09.2022.
//

import Foundation
import CoreLocation

protocol FavouritesInteractorOutput: AnyObject {
    func updateLocations(locations: [LocationModel])
    func updateGeoModel(model: GeoModel)
    func updateBackground(animations: [CellsAnimationModel])
    func noCityResult()
}

class FavouritesInteractor {
    
    weak var output: FavouritesInteractorOutput?
    
    var coreDataService: CoreDataService!
    var backgroundService: BackgroundService!
    var dateFormatterService: DateFormatterService!
    var locationService: LocationService!
    var weatherService: WeatherService!
    
    var locationsGeo: [GeoModel] = []
    var locationsList: [LocationModel] = []
    var animations: [CellsAnimationModel] = []
    
    //MARK: - Protocol funcs
    func loadEntity() {
        loadCitiesData()
    }
    
    func addNewCity(city: String) {
        locationService.getCityGeo(city: city) { [weak self] geo, error in
            if error == nil {
                guard let geo else { return }
                self?.locationService.getPosition(currentLocation: geo) { [weak self] city, lat, lon, error in
                    guard let city,
                          let lat,
                          let lon else { return }
                    let geoModel = GeoModel.init(city: city, lat: lat, lon: lon)
                    if (self?.loadGeoModels().firstIndex(where: { $0.lat == lat && $0.lon == lon }) != nil) {
                        return
                    }
                    self?.locationsGeo.append(geoModel)
                    self?.weatherService.loadWeatherData(lat: geoModel.lat, lon: geoModel.lon) { [weak self] jsonData in
                        guard let newCity = self?.setupModel(jsonData: jsonData, geoModel: geoModel)  else { return }
                        self?.locationsList.append(newCity)
                        self?.saveLocations()
                        guard let nodes = self?.backgroundService.searchResultsAnimations(entity: newCity) else { return }
                        guard let gradient = self?.backgroundService.searchResultsGradient(entity: newCity) else { return }
                        self?.animations.append(CellsAnimationModel.init(nodes: nodes, gradient: gradient))
                        self?.output?.updateLocations(locations: self!.locationsList)
                        self?.output?.updateBackground(animations: self!.animations)
                    }
                }
            } else {
                self?.noCityResult()
            }
        }
    }
    
    func setupGeoModel(city: String, lat: Double, lon: Double) {
        let geoModel = GeoModel.init(city: city, lat: lat, lon: lon)
        output?.updateGeoModel(model: geoModel)
    }
    
    func removeCity(index: Int) {
        locationsGeo.remove(at: index)
        saveLocations()
        loadCitiesData()
    }
    
    //MARK: - Private funcs
    private func setupModel(jsonData: WeatherRawEntity, geoModel: GeoModel) -> LocationModel {
        let cityName = geoModel.city
        let lat = geoModel.lat
        let lon = geoModel.lon
        let subTitle = dateFormatterService.dateToString(date: Date(), format: "HH:mm")
        let weatherDesc = jsonData.current.weather[0].description
        let temp = jsonData.current.temp
        let minTemp = jsonData.daily[0].temp.min
        let maxTemp = jsonData.daily[0].temp.max
        let icon = jsonData.current.weather[0].icon
        let model = LocationModel.init(
            cityName: cityName,
            lat: lat,
            lon: lon,
            subTitle: subTitle,
            weatherDesc: weatherDesc,
            temp: temp,
            minTemp: minTemp,
            maxTemp: maxTemp,
            icon: icon)
        return model
    }
    
    private func loadCitiesData() {
        animations = []
        locationsList = []
        locationsGeo = loadGeoModels()
        DispatchQueue.global().sync {
            DispatchQueue.global().sync {
                self.setupCurrentLocation()
            }
            DispatchQueue.global().sync {
                locationsGeo.forEach { geoModel in
                    self.weatherService.loadWeatherData(lat: geoModel.lat, lon: geoModel.lon) { jsonData in
                        let newCity = self.setupModel(jsonData: jsonData, geoModel: geoModel)
                        let nodes = self.backgroundService.searchResultsAnimations(entity: newCity)
                        let gradient = self.backgroundService.searchResultsGradient(entity: newCity)
                        self.locationsList.append(newCity)
                        self.animations.append(CellsAnimationModel.init(nodes: nodes, gradient: gradient))
                    }
                }
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.7) {
                self.output?.updateLocations(locations: self.locationsList)
                self.output?.updateBackground(animations: self.animations)
            }
        }
    }
    
    private func noCityResult() {
        output?.noCityResult()
    }
    
    private func loadGeoModels() -> [GeoModel] {
        let decoder = JSONDecoder()
        let data = coreDataService.getData(key: StorageEnum.favouritesStorageKey)
        guard let locations = try? decoder.decode([GeoModel].self, from: data) else { return [] }
        return locations
    }
    
    private func loadCurrentGeoModel() -> GeoModel? {
        let loadedModel = coreDataService.getWeatherModel()
        guard let city = loadedModel?.city,
              let lat = loadedModel?.lat,
              let lon = loadedModel?.lon else { return nil }
        return GeoModel.init(city: city, lat: lat, lon: lon)
    }
    
    private func setupCurrentLocation() {
        guard let currentGeoModel = loadCurrentGeoModel() else { return }
        self.weatherService.loadWeatherData(lat: currentGeoModel.lat, lon: currentGeoModel.lon) { jsonData in
            let current = self.setupModel(jsonData: jsonData, geoModel: currentGeoModel)
            let nodes = self.backgroundService.searchResultsAnimations(entity: current)
            let gradient = self.backgroundService.searchResultsGradient(entity: current)
            self.locationsList.insert(current, at: 0)
            self.animations.insert(CellsAnimationModel.init(nodes: nodes, gradient: gradient), at: 0)
        }
    }
    
    private func saveLocations() {
        let data = try? JSONEncoder().encode(locationsGeo)
        coreDataService.setData(key: StorageEnum.favouritesStorageKey, value: data)
    }
    
    private func setupCurrentModel() -> LocationModel? {
        let data = coreDataService.getData(key: StorageEnum.weatherStorageKey)
        let decoder = JSONDecoder()
        guard let entity = try? decoder.decode(WeatherEntity.self, from: data) else { return nil }
        let current = LocationModel.init(
            cityName: entity.city,
            lat: entity.lat,
            lon: entity.lon,
            subTitle: dateFormatterService.dateToString(date: Date(), format: "HH:mm"),
            weatherDesc: entity.desc,
            temp: entity.currentTemp,
            minTemp: entity.minTemp,
            maxTemp: entity.maxTemp,
            icon: entity.icon)
        return current
    }
}
