//
//  WeatherAssembly.swift
//  WeatherApp
//
//  Created by p h on 07.09.2022.
//

import Foundation
import UIKit

class WeatherAssembly {
    static func setupWeatherModule() -> UIViewController? {
        let storyboard = UIStoryboard(name: "Weather", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "Weather") as? WeatherViewController else { return UIViewController() }
        
        let presenter = WeatherPresenter()
        let interactor = WeatherInteractor()
        let router = WeatherRouter()
        
        let weatherService = WeatherService()
        let locationService = LocationService()
        let coreDataService = CoreDataService()
        let dateFormatterService = DateFormatterService()
        let backgroundService = BackgroundService()
        let alertService = AlertService()
        
        presenter.interactor = interactor
        presenter.presenterOutput = viewController
        presenter.router = router
        
        interactor.output = presenter
        interactor.backgroundService = backgroundService
        interactor.weatherService = weatherService
        interactor.coreDataService = coreDataService
        interactor.locationService = locationService
        
        viewController.presenter = presenter
        viewController.dateFormatterService = dateFormatterService
        viewController.alertService = alertService
        
        router.view = viewController
        
        return viewController
    }
}

