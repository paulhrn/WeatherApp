//
//  AlertService.swift
//  WeatherApp
//
//  Created by p h on 01.09.2022.
//

import UIKit
import SPIndicator

class AlertService {
    func noSearchResult(title: String, message: String, preset: SPIndicatorIconPreset, haptic: SPIndicatorHaptic) {
        SPIndicator.present(title: title, message: message, preset: preset, haptic: haptic)
    }
}
