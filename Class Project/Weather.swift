//
//  Weather.swift
//  Class Project
//
//  Created by Ethan Roldan on 11/28/24.
//

import SwiftUI

struct Weather: View {
    @StateObject var weatherModel = WeatherModel()

    var body: some View {
        VStack {
            if weatherModel.isLoading {
                ProgressView("Loading...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
            }
            else if let errorMessage = weatherModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
            else if let weatherInfo = weatherModel.parsedWeatherInfo {
                ScrollView {
                    VStack(spacing: 16) {
                        if let current = weatherInfo["current"] as? [String: Any] {
                            VStack(spacing: 8) {
                                Text("Current Temperature in Puerto Peñasco")
                                    .font(.title)
                                    .fontWeight(.bold)
                                Text("\(String(format: "%.1f", current["temp_c"] as? Double ?? 0))°C / \(String(format: "%.1f", current["temp_f"] as? Double ?? 0))°F")
                                    .font(.title2)
                                Text("Condition: \((current["condition"] as? [String: Any])?["text"] as? String ?? "Unknown")")
                                    .font(.subheadline)
                                    .italic()
                            }
                            .padding()
                        }

                        if let forecast = weatherInfo["forecast"] as? [String: Any],
                           let forecastDays = forecast["forecastday"] as? [[String: Any]] {
                            Text("3-Day Forecast:")
                                .font(.headline)
                                .padding(.top)
                            
                            ForEach(forecastDays.indices, id: \.self) { index in
                                let day = forecastDays[index]
                                
                                if let date = day["date"] as? String,
                                   let dayTemp = day["day"] as? [String: Any],
                                   let maxTempC = dayTemp["maxtemp_c"] as? Double,
                                   let maxTempF = dayTemp["maxtemp_f"] as? Double,
                                   let minTempC = dayTemp["mintemp_c"] as? Double,
                                   let minTempF = dayTemp["mintemp_f"] as? Double,
                                   let condition = dayTemp["condition"] as? [String: Any],
                                   let weatherText = condition["text"] as? String {
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text(date)
                                            .font(.headline)
                                            .bold()
                                        
                                        HStack {
                                            VStack(alignment: .leading) {
                                                Text("Max Temp:")
                                                    .font(.subheadline)
                                                Text("\(String(format: "%.1f", maxTempC))°C / \(String(format: "%.1f", maxTempF))°F")
                                                    .font(.subheadline)
                                            }
                                            
                                            VStack(alignment: .leading) {
                                                Text("Min Temp:")
                                                    .font(.subheadline)
                                                Text("\(String(format: "%.1f", minTempC))°C / \(String(format: "%.1f", minTempF))°F")
                                                    .font(.subheadline)
                                            }
                                        }

                                        Text("Condition: \(weatherText)")
                                            .font(.subheadline)
                                            .italic()
                                    }
                                    .padding(.vertical, 8)
                                    .background(RoundedRectangle(cornerRadius: 8).fill(Color.gray.opacity(0.1)))
                                }
                            }
                            .listStyle(InsetGroupedListStyle())
                        }
                    }
                    .padding()
                }
            } else {
                Text("No weather data available.")
                    .padding()
            }
        }
        .onAppear {
            weatherModel.fetchWeatherData()
        }
        .navigationTitle("Encantame Weather Information")
    }
}
