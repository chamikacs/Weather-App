//
//  NavBar.swift
//  CWK2Template
//
//  Created by girish lukka on 29/10/2023.
//

import SwiftUI

struct NavBar: View {
    
    @StateObject var weatherMapViewModel: WeatherMapViewModel = WeatherMapViewModel()
    @StateObject var networkMonitor: NetworkMonitor = NetworkMonitor()
    @State private var showAlert = false
    @State var test = false
    
    var body: some View {
        VStack {
            TabView {
                WeatherNowView()
                    .tabItem {
                        Label("City", systemImage: "magnifyingglass")
                    }
                    .environmentObject(weatherMapViewModel)
                    .environmentObject(networkMonitor)
                    .toolbarBackground(Constants.PRIMARY_COLOR, for: .tabBar)
                ForecastView()
                    .tabItem {
                        Label("Forecast", systemImage: "calendar")
                    }
                    .environmentObject(weatherMapViewModel)
                    .environmentObject(networkMonitor)
                    .toolbarBackground(Constants.PRIMARY_COLOR, for: .tabBar)
                MapView()
                    .tabItem {
                        Label("Place Map", systemImage: "map")
                    }
                    .environmentObject(weatherMapViewModel)
                    .toolbarBackground(Constants.PRIMARY_COLOR, for: .tabBar)
            }
            .accentColor(.purple)
            .alert(isPresented: $showAlert) {
                // Show a network error alert if there is no internet connection
                Alert(
                    title: Text("Network Error"),
                    message: Text("Please check your internet connection and try again."),
                    dismissButton: .default(Text("Retry"), action: {
                        // Perform some retry action if needed
                    })
                )
            }
            .onAppear {
                // Check for internet connection on app launc
                if !networkMonitor.isActive {
                    showAlert = true
                }
            }
            .onChange(of: weatherMapViewModel.showCountryNotFound) { newValue in
                test = newValue
            }
            .onChange(of: networkMonitor.isActive) { newValue in
                // Handle changes in internet connection status
                showAlert = !newValue // Show the alert when connection is lost
        }
        }
    }
}

#Preview {
    NavBar()
}
