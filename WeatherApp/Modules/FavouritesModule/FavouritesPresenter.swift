//
//  FavouritesPresenter.swift
//  WeatherApp
//
//  Created by p h on 08.09.2022.
//

import Foundation

protocol FavouritesPresenterOutput: AnyObject {
    func setLocations()
    func setBackground()
    func noCityResult()
    
}

class FavouritesPresenter {
    
    var locationsEntity: [LocationModel] = []
    var animationsEntity: [CellsAnimationModel] = []
    
    weak var presenterOutput: FavouritesPresenterOutput?
    var interactor: FavouritesInteractor!
    var router: FavouritesRouter!
    var output: ModuleOutput?
    
    // MARK: - Protocol Funcs
    func viewDidLoad() {
        interactor.loadEntity()
    }
    
    func addCity(city: String) {
        interactor.addNewCity(city: city)
    }
    
    func getWeatherForCity(city: String, lat: Double, lon: Double) {
        interactor.setupGeoModel(city: city, lat: lat, lon: lon)
    }
    
    func removeCity(index: Int) {
        interactor.removeCity(index: index)
    }
}

// MARK: - Extensions
extension FavouritesPresenter: FavouritesInteractorOutput {
    func noCityResult() {
        presenterOutput?.noCityResult()
    }
    
    func updateBackground(animations: [CellsAnimationModel]) {
        animationsEntity = animations
        presenterOutput?.setBackground()
    }
    
    
    func updateLocations(locations: [LocationModel]) {
        locationsEntity = locations
        presenterOutput?.setLocations()
    }
    
    func updateGeoModel(model: GeoModel) {
        output?.didUpdateModel(model: model)
    }
}
