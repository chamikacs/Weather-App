//
//  WeatherNowView.swift
//  CWK2Template
//
//  Created by girish lukka on 29/10/2023.
//

import SwiftUI

struct WeatherNowView: View {
    @EnvironmentObject var weatherMapViewModel: WeatherMapViewModel
    @EnvironmentObject var networkMonitor: NetworkMonitor
//    @State private var isLoading = false
    @State private var temporaryCity = ""
    
    @State var showCountryNotFound = false
    @State var displaySearchBar: Bool = false
    
    @State var textColor: Color = .white
    @State var moving = true
    
    let height = UIScreen.main.bounds.height
    let width = UIScreen.main.bounds.width
    
    var body: some View {
        
        NavigationView{
            GeometryReader { proxy in
                
                ZStack {
                    if weatherMapViewModel.weatherDataModel != nil {
                        let currentTime = Date(timeIntervalSince1970: TimeInterval(weatherMapViewModel.weatherDataModel?.current.dt ?? 0))
                        let timeOfDay = currentTime.getTimeOfDay(currentTime: weatherMapViewModel.weatherDataModel?.timezone ?? "UTC")
                        let backgroundImage = backgroundView(timeOfDay: timeOfDay)
                        
                        
                        
                        VStack {
                            
                            // Top Stack
                            VStack() {
                                Spacer()
                                
                                if displaySearchBar == false {
                                    Rectangle()
                                        .frame(height: 40)
                                        .opacity(0.0)
                                        .fixedSize(horizontal: true, vertical: true)
                                        .allowsTightening(false)
                                }
                                
                                if displaySearchBar == true {
                                    HStack {
                                        TextField("", text: $temporaryCity)
                                            .onSubmit {
                                                weatherMapViewModel.city = temporaryCity
                                                Task {
                                                    do {
                                                        try await weatherMapViewModel.getCoordinatesForCity()
                                                        try await weatherMapViewModel.featchWeatherData(lat: weatherMapViewModel.cordinates?.latitude ?? 0.0, lon: weatherMapViewModel.cordinates?.longitude ?? 0.0)
                                                        let currentTime = Date(timeIntervalSince1970: TimeInterval(weatherMapViewModel.weatherDataModel?.current.dt ?? 0))
                                                        let timeOfDay = currentTime.getTimeOfDay(currentTime: weatherMapViewModel.weatherDataModel?.timezone ?? "UTC")
                                                        selectTextColor(timeOfDay: timeOfDay)
                                                    } catch {
                                                        print("Error: \(error)")
                                                    }
                                                }
                                                displaySearchBar = false
                                            }
                                            .foregroundColor(.black)
                                            .background(.white)
                                            .cornerRadius(5)
                                            .frame(width: 300, height: 40)
                                            .fixedSize(horizontal: true, vertical: true)
                                        
                                    }
                                }
                                
                                Spacer()
                                
                                //Temp Stack
                                HStack(alignment: .bottom) {
                                    
                                    VStack {
                                        // Current temp text
                                        Text("\(Int((weatherMapViewModel.weatherDataModel?.current.temp)!))°")
                                            .foregroundColor(textColor)
                                            .font(Constants.largeText)
                                        
                                        // Feels like text
                                        Text("Feels Like \(String(format: "%.2f", weatherMapViewModel.weatherDataModel?.current.feelsLike ?? 0))°C")
                                            .font(Constants.descriptiveText)
                                            .foregroundColor(textColor)
                                            .shadow(color: .gray, radius: 10, x: 0.0, y: 8)
                                    }
                                    
                                    
                                    Spacer()
                                    
                                    VStack {
                                        
                                        // Weather status image
                                        iconForHourly(timeOfDay: timeOfDay)
                                            .resizable()
                                            .frame(width: 100, height: 100)
                                        
                                        // weather status
                                        Text("\(weatherMapViewModel.weatherDataModel?.current.weather[0].description ?? "")".capitalized)
//                                            .bold()
//                                            .font(.title3)
                                            .font(Constants.title2Text)
                                            .foregroundColor(textColor)
                                            .multilineTextAlignment(.center)
//                                            .shadow(color: .gray, radius: 10, x: 0.0, y: 8)
                                    }
                                }
                                
                                Spacer()
                                
                                //Date stack
                                HStack(alignment: .bottom) {
//                                    Spacer()
//                                    Current Date
                                    Text("\(weatherMapViewModel.formattedDate), \(weatherMapViewModel.formattedTime)")
                                        .bold()
                                        .font(Constants.normalText)
                                        .foregroundColor(textColor)
                                        .shadow(color: .gray, radius: 10, x: 0.0, y: 8)
                                    Spacer()
                                }
                                .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
                                
                                
                                
                            }// Top Stack
                            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                            .frame(minWidth: proxy.size.width, minHeight: proxy.size.height * 0.70, maxHeight: proxy.size.height * 0.70, alignment: .top)
                            .foregroundColor(.white)
                            
                            // Background image
                            .background(
                                backgroundImage
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: proxy.size.width, height: proxy.size.height * 0.70)
                                    .mask(
                                        UnevenRoundedRectangle(topLeadingRadius: 0, bottomLeadingRadius: 40, bottomTrailingRadius: 40, topTrailingRadius: 0)
                                    )
                            ) // End of Top Stack
                            
                            // Bottom Stack
                            VStack {
                                HStack {
                                    // Sunrise
                                    HStack {
                                        Image("sunriseIcon")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 40, height: 38)
                                            .padding(.trailing, 7)
                                        VStack(alignment: .leading) {
                                            Text("Sunrise")
                                                .font(Constants.normalText)
                                            Text("\(weatherMapViewModel.formattedSunrise) AM")
                                                .font(Constants.descriptiveText)
                                        }
                                    }
                                    .padding()
                                    .frame(width: width * 0.45, height: proxy.size.height * 0.085)
                                    .background(Constants.SECONDARY_COLOR)
                                    .mask(
                                        RoundedRectangle(cornerRadius: 20)
                                    )
                                    
                                    // Sunset
                                    HStack {
                                        Image("sunsetIcon")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 40, height: 38)
                                            .padding(.trailing, 7)
                                        VStack(alignment: .leading) {
                                            Text("Sunset")
                                                .font(Constants.normalText)
                                            Text("\(weatherMapViewModel.formattedSunset) PM")
                                                .font(Constants.descriptiveText)
                                        }
                                    }
                                    .padding()
                                    .frame(width: width * 0.45, height: proxy.size.height * 0.085)
                                    .background(Constants.SECONDARY_COLOR)
                                    .mask(
                                        RoundedRectangle(cornerRadius: 20)
                                    )
                                }
                                HStack {
                                    //Wind speed stack
                                    detailedBox(text: "Wind", value: "\(String(weatherMapViewModel.weatherDataModel?.current.windSpeed ?? 3.09)) km/h", image: "wind")
                                    
                                    // Pressure Stack
                                    detailedBox(text: "Pressure", value: "\(String(weatherMapViewModel.weatherDataModel?.current.pressure ?? 3)) hpa", image: "line.horizontal.3.decrease")
                                }
                                
                                
                                HStack {
                                    // Humidity Stack
                                    detailedBox(text: "Humidity", value: "\(String(weatherMapViewModel.weatherDataModel?.current.humidity ?? 0))%", image: "drop")
                                    //                        Spacer()
                                    
                                    // UVI stack
                                    detailedBox(text: "UV Index", value: String(weatherMapViewModel.weatherDataModel?.current.uvi ?? 3.09), image: "sun.haze")
                                }
                                
//                                Spacer()
                                
                            }
//                            .padding(.top, 20)
//                            .padding()// Bottom Stack
                            
                            
                        } // main vstack
                    }

                    else {
                        ZStack {
                            Color.white.ignoresSafeArea()

                                
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .purple))
                                .scaleEffect(2)
                        }
                    }
                }// Main Stack
                
            }
            .refreshable {
                print("refreshed")
            }
            .onChange(of: weatherMapViewModel.city, {
                weatherMapViewModel.weatherDataModel = nil
            })
            .alert(isPresented: $weatherMapViewModel.showCountryNotFound,content: {
                Alert(title: Text("Country not found"))
            })
            .edgesIgnoringSafeArea(.top)
            .toolbar {
                ToolbarItem(placement: .topBarLeading, content: {
                    Text(weatherMapViewModel.searchedCity)
                        .font(Constants.titleText)
                        .bold()
                        .foregroundColor(textColor)
                })
                ToolbarItem(placement: .topBarTrailing, content: {
                    Button(action: {
                        displaySearchBar.toggle()
                    }, label: {
                        Image(systemName: "magnifyingglass")
                            .tint(textColor)
                    })
                })
            }
            .background(Constants.PRIMARY_COLOR)
            .ignoresSafeArea(.keyboard, edges: .bottom)
            
        }
        .onAppear {
            let currentTime = Date(timeIntervalSince1970: TimeInterval(weatherMapViewModel.weatherDataModel?.current.dt ?? 0))
            let timeOfDay = currentTime.getTimeOfDay(currentTime: weatherMapViewModel.weatherDataModel?.timezone ?? "UTC")
            selectTextColor(timeOfDay: timeOfDay)
        }
    }
    
    
    func detailedBox(text: String, value: String, image: String) -> some View {
        return HStack {
            Circle()
                .frame(width: 40, height: 40)
                .foregroundColor(.white)
                .overlay(content: {
                    Image(systemName: image)
                        .resizable()
                        .frame(width: 20, height: 25)
                        .foregroundColor(.black)
                })
                .padding(.trailing, 5)
            VStack(alignment: .leading) {
                Text(text)
                    .font(Constants.normalText)
                Text(value)
                    .font(Constants.descriptiveText)
            }
        }
        .padding()
        .frame(width: width * 0.45, height: height * 0.08)
        .background(Constants.SECONDARY_COLOR)
        .mask(
            RoundedRectangle(cornerRadius: 20)
        )
    }
    
    
    
    func iconForHourly(timeOfDay: TimeOfDay) -> Image {
        let item = weatherMapViewModel.weatherDataModel?.current.weather[0].main
        switch item {
        case "Clouds":
            return Image("overcast_clouds")
        case "Rain":
            return Image("light_rain")
        case "Thunderstorm":
            return Image("thunder")
        case "Snow":
            return Image("snow")
        case "Fog":
            return Image("fog")
        case "scattered clouds":
            return Image("scattered_clouds")
        case "Mist":
            return Image("mist")
        case "Clear":
            if timeOfDay != .night {
                return Image("clear_sky")
            }
            return Image("moon")
        default:
            return Image("clear_sky")
        }
    }
    
    
    private func backgroundView(timeOfDay: TimeOfDay) -> Image {
        switch timeOfDay {
        case .morning:
            textColor = .black
            return Image("sunse") // Set morning background color
        case .day:
            textColor = .black
            return Image("day")// Set day background color
        case .evening:
            return Image("sunset") // Set evening background color
        case .night:
            return Image("night") // Set night background color
        }
    }
    
    func selectTextColor(timeOfDay: TimeOfDay) {
        switch timeOfDay {
        case .morning:
            textColor = .black
        case .day:
            textColor = .black
        default:
            textColor = .white
        }
    }
}

extension Date {
    func getTimeOfDay(currentTime: String) -> TimeOfDay {
        var calendar = Calendar.current
        if let timeZone = TimeZone(identifier: currentTime) {
            calendar.timeZone = timeZone
        }
        
        let hour = calendar.component(.hour, from: self)
        
        switch hour {
        case 6..<12:
            return .morning
        case 12..<18:
            return .day
        case 18..<21:
            return .evening
        default:
            return .night
        }
    }
}

#Preview {
    WeatherNowView()
        .environmentObject(WeatherMapViewModel())
        .environmentObject(NetworkMonitor())
}

enum TimeOfDay {
    case morning, day, evening, night
}
