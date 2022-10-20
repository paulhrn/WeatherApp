//
//  BackgroundService.swift
//  WeatherApp
//
//  Created by p h on 01.09.2022.
//

import Foundation

class BackgroundService {
    
    func backgroundGradient(entity: WeatherEntity) -> [String] {
        let gradientColors = GradientColors().colors
        for color in gradientColors {
            if entity.icon == color.key {
                return color.value
            }
        }
        return []
    }
    
    func backgroundAnimations(entity: WeatherEntity) -> [String] {
        let nodes = SpriteKitNodes().nodes
        for animation in nodes {
            if entity.icon == animation.key {
                return animation.value
            }
        }
        return []
    }
    
    func searchResultsGradient(entity: LocationModel) -> [String] {
        let gradientColors = GradientColors().colors
        for color in gradientColors {
            if entity.icon == color.key {
                return color.value
            }
        }
        return []
    }
    
    func searchResultsAnimations(entity: LocationModel) -> [String] {
        let nodes = SpriteKitNodes().nodes
        for animation in nodes {
            if entity.icon == animation.key {
                return animation.value
            }
        }
        return []
    }
}
