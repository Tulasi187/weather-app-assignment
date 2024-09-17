//
//  weatherViewModel.swift
//  Weather-assignment
//
//  Created by Tulasi Yenumula on 9/17/24.
//

import Foundation
import Foundation
import Combine

class WeatherViewModel: ObservableObject {
    @Published var weather: WeatherData?
    @Published var isLoading = false
    @Published var error: String?
    
    private let apiKey = "YOUR_API_KEY"
    private var cancellables = Set<AnyCancellable>()
    
    func fetchWeather(for city: String) {
        isLoading = true
        error = nil
        
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(cdec41d467f80aa295f1355618890b4d)&units=metric") else {
            error = "Invalid URL"
            isLoading = false
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: WeatherData.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] weather in
                self?.weather = weather
                self?.saveLastSearchedCity(city)
            }
            .store(in: &cancellables)
    }
    
    func loadLastSearchedCity() {
        if let lastCity = UserDefaults.standard.string(forKey: "lastSearchedCity") {
            fetchWeather(for: lastCity)
        }
    }
    
    private func saveLastSearchedCity(_ city: String) {
        UserDefaults.standard.set(city, forKey: "lastSearchedCity")
    }
}
