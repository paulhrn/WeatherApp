//
//  WeatherPresenter.swift
//  WeatherApp
//
//  Created by p h on 09.09.2022.
//

import Foundation

protocol WeatherPresenterOutput: AnyObject {
    func setDataToUI(entity: WeatherEntity)
    func setBackground(nodes: [String], gradient: [String])
}

class WeatherPresenter {
    
    var model: GeoModel?
    
    weak var presenterOutput: WeatherPresenterOutput?
    var coreDataService: CoreDataService?
    var interactor: WeatherInteractor!
    var router: WeatherRouter!
    
    // MARK: - Protocol Funcs
    func viewDidLoad() {
        interactor.locationAccessRequest()
        interactor.checkConnection()
    }
    
    func showFavourites() {
        router.showFavourites(output: self)
    }
}

// MARK: - Extensions
extension WeatherPresenter: WeatherInteractorOutput {
    
    func updateBackground(nodes: [String], gradient: [String]) {
        presenterOutput?.setBackground(nodes: nodes, gradient: gradient)
    }
    
    func updateWeather(entity: WeatherEntity) {
        presenterOutput?.setDataToUI(entity: entity)
    }
}

extension WeatherPresenter: ModuleOutput {
    func didUpdateModel(model: GeoModel) {
        interactor.getWeatherData(geoModel: model)
    }
}
