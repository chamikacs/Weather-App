//
//  WeatherDataModel.swift
//  CWK2Template
//
//  Created by girish lukka on 29/10/2023.
//

import Foundation
// MARK: - WeatherData
struct WeatherDataModel: Codable, Identifiable {
    
    let id=UUID()
    let lat, lon: Double
    let timezone: String
    let timezoneOffset: Int
    let current: Current
    let minutely: [Minutely]?
    let hourly: [Hourly]
    let daily: [Daily]


    enum CodingKeys: String, CodingKey {
        case lat, lon, timezone
        case timezoneOffset = "timezone_offset"
        case current,hourly,daily,minutely
    }
}

struct Hourly: Codable, Identifiable{
    let id=UUID()
    let dt: Int
    let temp, feelsLike: Double
    let pressure, humidity: Int
    let dewPoint: Double
    let uvi: Double
    let clouds: Int
    let visibility: Int?
    let windSpeed: Double
    let windDeg: Int
    let weather: [Weather]
    let windGust, pop: Double?

    enum CodingKeys: String, CodingKey {
        case dt, temp
        case feelsLike = "feels_like"
        case pressure, humidity
        case dewPoint = "dew_point"
        case uvi, clouds, visibility
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case weather
        case windGust = "wind_gust"
        case pop
    }
}

struct Current: Codable, Identifiable {
    let id=UUID()
    let dt: Int
    let sunrise, sunset: Int?
    let temp, feelsLike: Double
    let pressure, humidity: Int
    let dewPoint, uvi: Double
    let clouds, visibility: Int
    let windSpeed: Double
    let windDeg: Int
    let weather: [Weather]
    let windGust, pop: Double?

    enum CodingKeys: String, CodingKey {
        case dt, sunrise, sunset, temp
        case feelsLike = "feels_like"
        case pressure, humidity
        case dewPoint = "dew_point"
        case uvi, clouds, visibility
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case weather
        case windGust = "wind_gust"
        case pop
    }
}

struct Weather: Codable, Identifiable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

enum Description: String, Codable {
    case brokenClouds = "broken clouds"
    case clearSky = "clear sky"
    case fewClouds = "few clouds"
    case lightRain = "light rain"
    case moderateRain = "moderate rain"
    case overcastClouds = "overcast clouds"
    case scatteredClouds = "scattered clouds"
    case thunderstormWithLightRain = "thunderstorm with light rain"
    case thunderstormWithRain = "thunderstorm with rain"
    case thunderstormWithHeavyRain = "thunderstorm with heavy rain"
    case lightThunderstorm = "light thunderstorm"
    case thunderstorm = "thunderstorm"
    case heavyThunderstorm = "heavy thunderstorm"
    case raggedThunderstorm = "ragged thunderstorm"
    case thunderstormWithLightDrizzle = "thunderstorm with light drizzle"
    case thunderstormWithDrizzle = "thunderstorm with drizzle"
    case thunderstormWithHeavyDrizzle = "thunderstorm with heavy drizzle"
    case heavyIntensityDrizzle = "heavy intensity drizzle"
    case lightIntensityDrizzleRain = "light intensity drizzle rain"
    case drizzleRain = "drizzle rain"
    case heavyIntensityDrizzleRain = "heavy intensity drizzle rain"
    case showerRainAndDrizzle = "shower rain and drizzle"
    case heavyShowerRainAndDrizzle = "heavy shower rain and drizzle"
    case showerDrizzle = "shower drizzle"
    case heavyIntensityRain = "heavy intensity rain"
    case veryHeavyRain = "very heavy rain"
    case extremeRain = "exteme rain"
    case freezingRain = "freezing rain"
    case lightIntensityShowerRain = "light intensity shower rain"
    case showerRain = "shower rain"
    case heavyIntensityShowerRain = "heavy intensity shower rain"
    case raggedShowerRain = "ragged shower rain"
    case lightSnow = "light snow"
    case Snow = "snow"
    case HeavySnow = "heavy snow"
    case Sleet = "hleet"
    case LightShowerSleet = "Light shower sleet"
    case ShowerSleet = "Shower sleet"
    case LightRainAndSnow = "Light rain and snow"
    case RainAndSnow = "rain and snow"
    case LightShowerSnow = "Light shower snow"
    case ShowerSnow = "Shower snow"
    case HeavyShowerSnow = "Heavy shower snow"
    case mist = "mist"
    case Smoke = "Smoke"
    case Haze = "Haze"
    case sandDustWhirls = "sand/dust whirls"
    case fog = "fog"
    case sand = "sand"
    case dust = "dXust"
    case volcanicAsh = "volcanic ash"
    case squalls = "squalls"
    case tornado = "tornado"
    case fewClouds1125 = "few clouds: 11-25%"
    case scatteredClouds2550 = "scattered clouds: 25-50%"
    case brokenClouds5184 = "broken clouds: 51-84%"
    case overcastClouds85100 = "overcast clouds: 85-100%"
}

struct Daily: Codable, Identifiable {
    let id=UUID()
    let dt, sunrise, sunset, moonrise: Int
    let moonset: Int
    let moonPhase: Double
    let summary: String
    let temp: Temp
    let feelsLike: FeelsLike
    let pressure, humidity: Int
    let dewPoint, windSpeed: Double
    let windDeg: Int
    let windGust: Double
    let weather: [Weather]
    let clouds: Int
    let pop, uvi: Double
    let rain: Double?

    enum CodingKeys: String, CodingKey {
        case dt, sunrise, sunset, moonrise, moonset
        case moonPhase = "moon_phase"
        case summary, temp
        case feelsLike = "feels_like"
        case pressure, humidity
        case dewPoint = "dew_point"
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case windGust = "wind_gust"
        case weather, clouds, pop, uvi, rain
    }
}

struct FeelsLike: Codable {
    let day, night, eve, morn: Double
}

struct Temp: Codable {
    let day, min, max, night: Double
    let eve, morn: Double
}

struct Minutely: Codable {
    let dt, precipitation: Double
}
