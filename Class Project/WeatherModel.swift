//
//  WeatherModel.swift
//  Class Project
//
//  Created by Ethan Roldan on 11/28/24.
//

import Foundation
import Combine

class WeatherModel: ObservableObject {
    private let headers: [String: String] = [
        "x-rapidapi-key": "aae51eccebmshac18a8f2e468d43p154b63jsn4147fd2b418e",
        "x-rapidapi-host": "weatherapi-com.p.rapidapi.com"
    ]
    
    @Published var weatherData: Data?
    @Published var parsedWeatherInfo: [String: Any]?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func fetchWeatherData() {
        self.isLoading = true
        self.errorMessage = nil
        
        guard let url = URL(string: "https://weatherapi-com.p.rapidapi.com/forecast.json?q=31.3289%2C%20-113.4044&days=3") else {
            self.errorMessage = "Invalid URL"
            self.isLoading = false
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: request) { [weak self] (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    self?.errorMessage = "Error: \(error.localizedDescription)"
                    self?.isLoading = false
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    if let data = data {
                        self?.weatherData = data
                        self?.parseWeatherData(data)
                    }
                } else {
                    self?.errorMessage = "Failed to load data."
                }
                
                self?.isLoading = false
            }
        }
        
        dataTask.resume()
    }
    
    private func parseWeatherData(_ data: Data) {
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                self.parsedWeatherInfo = json
            }
        } catch {
            self.errorMessage = "Error parsing weather data: \(error.localizedDescription)"
        }
    }
}
