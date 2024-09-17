//
//  weatherData.swift
//  Weather-assignment
//
//  Created by Tulasi Yenumula on 9/17/24.
//

import Foundation
import Foundation

struct WeatherData: Codable {
    let name: String
    let main: MainWeather
    let weather: [WeatherDescription]
    let wind: Wind
}

struct MainWeather: Codable {
    let temp: Double
    let humidity: Int
}

struct WeatherDescription: Codable {
    let description: String
    let icon: String
}

struct Wind: Codable {
    let speed: Double
}
