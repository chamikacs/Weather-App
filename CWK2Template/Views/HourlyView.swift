//
//  HourlyView.swift
//  MNAD_CW_TEST
//
//  Created by Chamika Sakalasuriya on 2023-11-26.
//

import SwiftUI

struct HourlyView: View {
    
    @EnvironmentObject var weatherMapViewModel: WeatherMapViewModel
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 10) {
                ForEach(weatherMapViewModel.weatherDataModel?.hourly ?? []){item in
                    HourlyItem(item: item, timezone: weatherMapViewModel.weatherDataModel!.timezone)
                }
            }
        }
    }
}

struct HourlyItem: View {
    var item: Hourly
    var timezone: String
    
    let height = UIScreen.main.bounds.height
    let width = UIScreen.main.bounds.width
    
    var body: some View {
        VStack {
            iconForHourly(item: item)
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
            
            Text("\(item.formattedHour(timezone: timezone))")
                .font(Constants.descriptiveTextBold)
            
            Text(Utils.formattedDateWithWeekdayAndDay(from: TimeInterval(item.dt)))
                .font(Constants.descriptiveText)
            
            Text("\(String(format: "%.2f",item.temp))°C")
                .font(Constants.descriptiveText)
            
        }
        .frame(width: width * 0.25, height: height * 0.19)
        .background(Constants.SECONDARY_COLOR)
        .mask({
            RoundedRectangle(cornerRadius: 20)
        })
    }
    
    func iconForHourly(item: Hourly) -> Image {
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
}

extension Hourly{
    func formattedHour(timezone: String) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(self.dt))
        let formatter = DateFormatter()
        formatter.dateFormat = "h a"  // Example format: "4 PM"
        if let tz = TimeZone(identifier: timezone) {
            formatter.timeZone = tz
        }
        return formatter.string(from: date)
    }
}

#Preview {
    HourlyView()
        .environmentObject(WeatherMapViewModel())
}
