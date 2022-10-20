//
//  FavouritesAssembly.swift
//  WeatherApp
//
//  Created by p h on 07.09.2022.
//

import Foundation
import UIKit

class FavouritesAssembly {
    static func setupFavouritesModule(output: ModuleOutput?) -> UIViewController? {
        let storyboard = UIStoryboard(name: "FavouritesView", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "FavouritesView") as? FavouritesViewController else { return UIViewController() }
        
        let presenter = FavouritesPresenter()
        let interactor = FavouritesInteractor()
        let router = FavouritesRouter()
        
        let dateFormatterService = DateFormatterService()
        let backgroundService = BackgroundService()
        let coreDataService = CoreDataService()
        let locationService = LocationService()
        let weatherService = WeatherService()
        let alertService = AlertService()
        
        presenter.interactor = interactor
        presenter.presenterOutput = viewController
        presenter.router = router
        presenter.output = output
        
        interactor.dateFormatterService = dateFormatterService
        interactor.coreDataService = coreDataService
        interactor.locationService = locationService
        interactor.weatherService = weatherService
        interactor.output = presenter
        interactor.backgroundService = backgroundService
        
        viewController.presenter = presenter
        viewController.locationService = locationService
        viewController.dateFormatterService = dateFormatterService
        viewController.alertService = alertService
        
        router.view = viewController
        
        return viewController
    }
}

