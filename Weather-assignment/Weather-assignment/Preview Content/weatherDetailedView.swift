//
//  weatherDetailedView.swift
//  Weather-assignment
//
//  Created by Tulasi Yenumula on 9/17/24.
//

import Foundation
import SwiftUI

struct WeatherDetailView: View {
    let weather: WeatherData
    
    var body: some View {
        VStack(spacing: 20) {
            Text(weather.name)
                .font(.largeTitle)
            
            Text("\(Int(weather.main.temp))°C")
                .font(.system(size: 70, weight: .bold))
            
            AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(weather.weather[0].icon)@2x.png")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
            } placeholder: {
                ProgressView()
            }
            
            Text(weather.weather[0].description.capitalized)
                .font(.title2)
            
            HStack(spacing: 40) {
                VStack {
                    Text("Humidity")
                        .font(.headline)
                    Text("\(weather.main.humidity)%")
                }
                
                VStack {
                    Text("Wind Speed")
                        .font(.headline)
                    Text("\(Int(weather.wind.speed)) m/s")
                }
            }
        }
        .padding()
    }
}
