//
//  DailyView.swift
//  MNAD_CW_TEST
//
//  Created by Chamika Sakalasuriya on 2023-11-26.
//

import SwiftUI

struct DailyView: View {
    
    @EnvironmentObject var weatherMapViewModel: WeatherMapViewModel
    
    var body: some View {
        List {
            ForEach(weatherMapViewModel.weatherDataModel?.daily ?? []) {item in
                dailyItem(item: item)
            }
        }
        
        .listStyle(.plain)
    }
    
    func iconForDaily(item: Daily) -> Image {
        switch item.weather[0].description {
        case "overcast clouds":
            return Image("overcast_clouds")
        case "light rain":
            return Image("light_rain")
        case "moderate rain":
            return Image("moderate_rain")
        case "very heavy rain":
            return Image("heavy_rain")
        case "few clouds":
            return Image("few_clouds")
        case "scattered clouds":
            return Image("scattered_clouds")
        case "broken clouds":
            return Image("broken_clouds")
        case "clear sky":
            return Image("clear_sky")
        default:
            return Image("clear_sky")
        }
    }
    
    func dailyItem(item: Daily) -> some View {
        HStack{
            HStack {
                VStack {
                    Text(Utils.formattedDateWithWeekdayAndDay(from: TimeInterval(item.dt)))
                        .font(Constants.descriptiveText)
                    Text("\(item.weather[0].description ?? "")".capitalized)
                        .font(Constants.descriptiveText)
                }
                .multilineTextAlignment(.leading)
                
                Spacer()
                VStack {
                    Text("\(String(format: "%.2f" ,item.temp.max))°C")
                        .font(Constants.descriptiveText)
                    Text("\(String(format: "%.2f" ,item.temp.min))°C")
                        .font(Constants.descriptiveText)
                }
                Divider().frame(width: 1)
                iconForDaily(item: item)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
//                            .offset(y: -50)
            }
        }
        .listRowBackground(Constants.PRIMARY_COLOR)
        .padding()
        .frame(width: 350, height: 70)
        .background(Constants.SECONDARY_COLOR)
        .mask({
            RoundedRectangle(cornerRadius: 20)
        })
    }
}

#Preview {
    DailyView()
        .environmentObject(WeatherMapViewModel())
}
