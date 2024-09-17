//
//  WeatherView.swift
//  Weather-assignment
//
//  Created by Tulasi Yenumula on 9/17/24.
//

import Foundation
import SwiftUI

struct WeatherView: View {
    @StateObject private var viewModel = WeatherViewModel()
    @State private var cityName: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter city name", text: $cityName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button(action: {
                    viewModel.fetchWeather(for: cityName)
                }) {
                    Text("Search")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                if viewModel.isLoading {
                    ProgressView()
                } else if let weather = viewModel.weather {
                    WeatherDetailView(weather: weather)
                } else if let error = viewModel.error {
                    Text(error)
                        .foregroundColor(.red)
                }
                
                Spacer()
            }
            .navigationTitle("Weather App")
        }
        .onAppear {
            viewModel.loadLastSearchedCity()
        }
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView()
    }
}
