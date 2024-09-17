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

// ViewModel
class WeatherViewModel: ObservableObject {
    @Published var weather: WeatherData?
    @Published var isLoading = false
    @Published var error: String?
    
    private let apiKey = "YOUR_API_KEY"
    
    func fetchWeather(for city: String) {
        isLoading = true
        error = nil
        
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)&units=metric") else {
            error = "Invalid URL"
            isLoading = false
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
                
                if let error = error {
                    self.error = error.localizedDescription
                    return
                }
                
                guard let data = data else {
                    self.error = "No data received"
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let weather = try decoder.decode(WeatherData.self, from: data)
                    self.weather = weather
                    self.saveLastSearchedCity(city)
                } catch {
                    self.error = "Failed to decode weather data"
                }
            }
        }.resume()
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

// Model
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
