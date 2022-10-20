//
//  UIExtensions.swift
//  WeatherApp
//
//  Created by p h on 01.09.2022.
//

import UIKit

extension StringProtocol {
    var firstUppercased: String {
        return prefix(1).uppercased() + dropFirst()
    }
}

extension Double {
    func toInt() -> Int {
        if self >= Double(Int.min) && self < Double(Int.max) {
            return Int(self)
        } else {
            return 0
        }
    }
    
    func kelvinToCelsius() -> Double {
       return self - 273.15
    }
    
    func kelvinToFahrenheit() -> Double {
        return kelvinToCelsius() * 9/5 + 32
    }
}

extension UIView {
    func fadeIn(_ duration: TimeInterval? = 0.5, onCompletion: (() -> Void)? = nil) {
        self.alpha = 0
        self.isHidden = false
        UIView.animate(withDuration: duration!,
                       animations: { self.alpha = 1 },
                       completion: { (value: Bool) in
            if let complete = onCompletion { complete() }
        })
    }
    
    func makeGradient(color1: UIColor, color2: UIColor) {
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = [color1.cgColor, color2.cgColor]
        gradient.opacity = 1
        layer.insertSublayer(gradient, at: 0)
    }
}

extension UIColor {
    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0
        
        let length = hexSanitized.count
        
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }
        
        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0
            
        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0
            
        } else {
            return nil
        }
        
        self.init(red: r, green: g, blue: b, alpha: a)
    }
    
    var rgbComponents:(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        if getRed(&r, green: &g, blue: &b, alpha: &a) {
            return (r,g,b,a)
        }
        return (0,0,0,0)
    }
    
    var htmlRGBColor:String {
        return String(format: "#%02x%02x%02x",
                      Int(rgbComponents.red * 255),
                      Int(rgbComponents.green * 255),
                      Int(rgbComponents.blue * 255))
    }
}
