//
//  WeatherMapViewModel.swift
//  CWK2Template
//
//  Created by girish lukka on 29/10/2023.
//

import Foundation
import SwiftUI
import CoreLocation
import MapKit
class WeatherMapViewModel: ObservableObject {
    // MARK:   published variables
    @Published var weatherDataModel: WeatherDataModel?
    @Published var city = "London"
    @Published var searchedCity = ""
    @Published var formattedDate: String = ""
    @Published var formattedTime: String = ""
    @Published var formattedSunrise: String = ""
    @Published var formattedSunset: String = ""
    @Published var cordinates: CLLocationCoordinate2D?
    @Published var region: MKCoordinateRegion = MKCoordinateRegion()
    @Published var showCountryNotFound: Bool = false
    @Published var somethingWentWrong = false
    @Published var isLoading: Bool = false
    
    init() {
        loadData()
    }
    
    
    func loadData() {
        Task {
            do {
                try await getCoordinatesForCity()
                try await featchWeatherData(lat: cordinates?.latitude ?? 51.503300, lon: cordinates?.longitude ?? -0.079400)
                
            } catch {
                // Handle errors if necessary
                print("Error loading weather data: \(error)")
            }
        }
    }
    
    
    // Get cordinate for given city
    func getCoordinatesForCity() async throws {
        let geocoder = CLGeocoder()
        if let placemarks = try? await geocoder.geocodeAddressString(city),
           let location = placemarks.first?.location?.coordinate {
            
            DispatchQueue.main.async {
                self.searchedCity = placemarks.first?.name ?? ""
                self.cordinates = location
                self.region = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            }
        } else {
            // Handle error here if geocoding fails
            print("Error: Unable to find the coordinates for the club.")
                        DispatchQueue.main.async {
            self.showCountryNotFound = true
                        }
            
        }
    }
    
    
    // Fetch weather data from API
    func featchWeatherData(lat: Double, lon: Double) async throws  {
        
        if let url = URL(string: "https://api.openweathermap.org/data/3.0/onecall?lat=\(lat)&lon=\(lon)&units=metric&appid=b3fc0ed125de946fbcfcbca5018d43fb") {
            let session = URLSession(configuration: .default)
            
            do {
                let (data, _) = try await session.data(from: url)
                let weatherDataModel = try JSONDecoder().decode(WeatherDataModel.self, from: data)
                
                DispatchQueue.main.async {
                    self.weatherDataModel = weatherDataModel
                    self.updateDateTime(weatherDataModel.current.dt, sunrise: weatherDataModel.current.sunrise!, sunset: weatherDataModel.current.sunset!)
                    //                    print("weatherDataModel loaded")
                }
                
            } catch {
                somethingWentWrong = true
                if let decodingError = error as? DecodingError {
                    
                    print("Decoding error: \(decodingError)")
                } else {
                    //  other errors
                    print("Error: \(error)")
                }
                throw error // Re-throw the error to the caller
            }
        } else {
            throw NetworkError.invalidURL
        }
    }
    
    enum NetworkError: Error {
        case invalidURL
    }
    
    
    // Load location data from json file
    func loadLocationsFromJSONFile(cityName: String) -> [Location]? {
        if let fileURL = Bundle.main.url(forResource: "places", withExtension: "json") {
            do {
                let data = try Data(contentsOf: fileURL)
                let decoder = JSONDecoder()
                let allLocations = try decoder.decode([Location].self, from: data)
                
                return allLocations
            } catch {
                print("Error decoding JSON: \(error)")
            }
        } else {
            print("File not found")
        }
        return nil
    }
    
    
    
    private func updateDateTime(_ timestamp: Int, sunrise: Int, sunset: Int) {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let sunrise = Date(timeIntervalSince1970: TimeInterval(sunrise))
        let sunset = Date(timeIntervalSince1970: TimeInterval(sunset))
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: weatherDataModel?.timezone ?? "UTC")
        dateFormatter.dateFormat = "E dd"
        self.formattedDate = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "HH:mm"
        self.formattedTime = dateFormatter.string(from: date)
        self.formattedSunrise = dateFormatter.string(from: sunrise)
        self.formattedSunset = dateFormatter.string(from: sunset)
        //        print("WeatherViewModel - Date and time updated to: \(formattedDate) \(formattedTime)")
    }
}


