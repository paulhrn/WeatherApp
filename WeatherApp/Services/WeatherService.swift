//
//  WeatherService.swift
//  WeatherApp
//
//  Created by p h on 02.09.2022.
//

import Foundation
import CoreLocation

class WeatherService {
    
    func loadWeatherData(lat: CLLocationDegrees, lon: CLLocationDegrees, completion: @escaping (WeatherRawEntity) -> ()) {
        let session: URLSession = URLSession.shared
        guard let url = prepareRequest(lat: lat, lon: lon) else { return }
        let request: URLRequest = URLRequest(url: url)
        session.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                guard let parsedData = self?.parseWeatherData(
                    data: data as NSData?,
                    response: response as URLResponse?,
                    error: error as NSError?) else { return }
                completion(parsedData)
            }
        }.resume()
    }
    
    // MARK: - Private funcs
    private func prepareRequest(lat: CLLocationDegrees, lon: CLLocationDegrees) -> URL? {
        var components = URLComponents(string: ApiEnum.url)
        components?.queryItems = [URLQueryItem(name: QueryItemsEnum.lat, value: String(lat)),
                                  URLQueryItem(name: QueryItemsEnum.lon, value: String(lon)),
                                  URLQueryItem(name: QueryItemsEnum.exclude, value: QueryItemsEnum.exclude),
                                  URLQueryItem(name: QueryItemsEnum.units, value: QueryItemsEnum.units),
                                  URLQueryItem(name: QueryItemsEnum.appid, value: ApiEnum.apiKey)
        ]
        return components?.url
    }
    
    private func parseWeatherData(data: NSData?, response: URLResponse?, error: NSError?) -> WeatherRawEntity? {
        if error == nil && data != nil {
            let decoder = JSONDecoder()
            guard let unwrapData = data else { return nil }
            if let jsonData = try? decoder.decode(WeatherRawEntity.self, from: unwrapData as Data) {
                return jsonData
            }
        }
        return nil
    }
}

