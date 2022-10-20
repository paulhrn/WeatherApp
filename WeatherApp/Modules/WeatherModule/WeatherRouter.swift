//
//  WeatherRouter.swift
//  WeatherApp
//
//  Created by p h on 07.09.2022.
//

import Foundation
import UIKit

class WeatherRouter: NSObject {
    
    weak var view: UIViewController?
    
    func showFavourites(output: ModuleOutput?) {
        guard let view = view else { return }
        guard let viewController = FavouritesAssembly.setupFavouritesModule(output: output) else { return }
        viewController.modalPresentationStyle = UIModalPresentationStyle.custom
        viewController.transitioningDelegate = self
        view.present(viewController, animated: true)
    }
}

extension WeatherRouter: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        WeatherPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
