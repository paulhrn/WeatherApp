//
//  LocationService.swift
//  WeatherApp
//
//  Created by p h on 02.09.2022.
//

import Foundation
import CoreLocation
import MapKit

class LocationService: NSObject, CLLocationManagerDelegate {
    
    private var currentCityName: String = ""
    private let locationManager = CLLocationManager()
    private let geoCoder = CLGeocoder()
    
    // MARK: - Funcs
    func getPosition(currentLocation: CLLocation, completion: @escaping (String?, CLLocationDegrees?, CLLocationDegrees?, Error?) -> ()) {
        let lat = currentLocation.coordinate.latitude
        let lon = currentLocation.coordinate.longitude
        let location = CLLocation(latitude: lat, longitude: lon)
        geoCoder.reverseGeocodeLocation(location, completionHandler: { placemarks, error in
            guard let placemark = placemarks?.first else {
                completion(nil, nil, nil, error)
                return
            }
            guard let cityName = placemark.locality else { return }
            if self.currentCityName != cityName {
                self.currentCityName = cityName
                completion(cityName, lat, lon, nil)
            } else {
                completion(nil, nil, nil, error)
            }
        })
    }
    
    func getCityGeo(city: String, completion: @escaping (CLLocation?, Error?) -> ()) {
        geoCoder.geocodeAddressString(city) { geo, error in
            if error == nil {
                guard let location = geo?.first?.location else { return }
                completion(location, nil)
            } else {
                completion(nil, error)
            }
        }
    }
}
