//
//  DateFormatterService.swift
//  WeatherApp
//
//  Created by p h on 01.09.2022.
//

import Foundation

class DateFormatterService {
    
    func dateToString(date: Date, format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let string = dateFormatter.string(from: date as Date)
        return string
    }
    
    func dailyDateFormatter(date: Double) -> String {
        let format = "EEEE"
        let givenDate = dateToString(date: Date(timeIntervalSince1970: TimeInterval(date)), format: format)
        let currentDate = dateToString(date: Date(), format: format)
        if givenDate != currentDate {
            return givenDate
        }
        return "Today"
    }
    
    func hourlyDateFormatter(date: Double) -> String {
        let format = "HH:mm"
        let givenDate = dateToString(date: Date(timeIntervalSince1970: TimeInterval(date)), format: format)
        let currentDate = dateToString(date: Date(), format: format)
        if givenDate.components(separatedBy: ":")[0] != currentDate.components(separatedBy: ":")[0] {
            return givenDate
        }
        return "Now"
    }
}
