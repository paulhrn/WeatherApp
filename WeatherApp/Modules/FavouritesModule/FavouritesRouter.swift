//
//  FavouritesRouter.swift
//  WeatherApp
//
//  Created by p h on 09.09.2022.
//

import Foundation
import UIKit

class FavouritesRouter {
    weak var view: UIViewController?
    
    func dismissScreen(output: ModuleOutput) {
        guard let view = view else { return }
        view.dismiss(animated: true)
    }
}
