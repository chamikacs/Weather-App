//
//  ForecastView.swift
//  MNAD_CW_TEST
//
//  Created by Chamika Sakalasuriya on 2023-11-26.
//

import SwiftUI
import Charts

struct ForecastView: View {
    
    @EnvironmentObject var weatherMapViewModel: WeatherMapViewModel
    @EnvironmentObject var networkMonitor: NetworkMonitor
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                Constants.PRIMARY_COLOR
                
                VStack {
                    
                    //Top Stack
                    VStack {
                        HourlyView()
                            .environmentObject(weatherMapViewModel)
                    }
                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                    
                    
                    // Chart stack
                    VStack(alignment: .leading) {
                        HStack {
                            Circle()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.white)
                                .overlay(content: {
                                    Image(systemName: "calendar")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(.black)
                                })
                                .padding(.trailing, 5)
                            Text("Day Forecast")
                                .font(Constants.descriptiveText)
                                
                        }
                        .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 0))
                        
                        Chart {
                            ForEach(weatherMapViewModel.weatherDataModel?.daily.dropLast() ?? []) { data in
                                
                                LineMark(x: .value("Day", Utils.dayOfWeek(from: TimeInterval(data.dt)) ?? ""), y: .value("Temp", data.temp.max))
                                    .foregroundStyle(Color.purple)
                                
                                BarMark(x: .value("Day", Utils.dayOfWeek(from: TimeInterval(data.dt)) ?? ""), y: .value("Temp", data.temp.max), width: 5)
                                    .foregroundStyle(Color.purple.gradient)
                                    .cornerRadius(5)
                            }
                        }
                        .padding()
                    }
                    .background(Constants.SECONDARY_COLOR.opacity(0.5))
                    .cornerRadius(20)
                    .padding() // End of chart stack
                    
                    //Bottom Stack
                    VStack {
                        DailyView().environmentObject(weatherMapViewModel)
                    }
                    
                }
            }
            .background(Constants.PRIMARY_COLOR)
            
            .navigationTitle(Text("Weather Forecast For \(weatherMapViewModel.searchedCity)"))
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
}

#Preview {
    ForecastView()
        .environmentObject(WeatherMapViewModel())
        .environmentObject(NetworkMonitor())
}
