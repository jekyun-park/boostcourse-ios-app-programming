//
//  City.swift
//  WeatherToday
//
//  Created by 박제균 on 2022/01/26.
//

import UIKit

// MARK: - 도시 정보
struct City: Codable {

    let cityName: String
    let state: Int
    let celsius: Double
    let rainFallProbability: Int

    enum Weather: Int {
        case sunny = 10
        case cloudy = 11
        case rainy = 12
        case snowy = 13
    }

    var fahrenheit: Double {
        return (self.celsius * 1.8 + 32)
    }

    var temperatureString: String {
        let fahrenheitString: String = String(format: "%.1f", self.fahrenheit)
        return "섭씨 \(self.celsius)도 / 화씨 \(fahrenheitString)도"
    }

    var rainFallProbabilityString: String {
        return "강수확률 \(self.rainFallProbability)%"
    }

    enum CodingKeys: String, CodingKey {
        case state, celsius
        case cityName = "city_name"
        case rainFallProbability = "rainfall_probability"
    }
}

extension City: CustomStringConvertible {
    var description: String {
        switch self.state {
        case 10:
            return "sunny"
        case 11:
            return "cloudy"
        case 12:
            return "rainy"
        case 13:
            return "snowy"
        default:
            return "cannot Found weather"
        }
    }
}
