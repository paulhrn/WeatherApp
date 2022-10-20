//
//  Module.swift
//  WeatherApp
//
//  Created by p h on 10.09.2022.
//

import Foundation
import UIKit

protocol ModuleOutput: AnyObject {
    func didUpdateModel(model: GeoModel)
}
