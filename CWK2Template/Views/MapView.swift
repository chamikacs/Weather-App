//
//  MapView.swift
//  MNAD_CW_TEST
//
//  Created by Chamika Sakalasuriya on 2023-12-18.
//

import SwiftUI
import MapKit
import CoreLocation

struct MainLocationDTO: Codable {
    let locations: [SubLocationDTO]
}

struct SubLocationDTO: Codable, Hashable {
    let name: String
    let cityName: String
    let latitude: Double
    let longitude: Double
    let description: String
    let imageNames: String
    let link: String
    var cordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

struct MapView: View {
    @EnvironmentObject var weatherMapViewModel: WeatherMapViewModel
    
    @State var locations: [SubLocationDTO] = []
    @State var place: [SubLocationDTO] = []
    
    // Gesture Properties
    @State var offset: CGFloat = 0
    @State var lastOffset: CGFloat = 0
    
    @State var locationNotFound = false
    
    @GestureState var gestureOffset: CGFloat = 0
    
    var body: some View {
        ZStack {
            Map {
                ForEach(place, id: \.self) {location in
                    Marker(location.name, coordinate: location.cordinate)
                        .tint(.purple)
                }
            }
            .blur(radius: getBlurRadius())
            
            // Bottom sheet
            
            GeometryReader { proxy -> AnyView in
                
                let height = proxy.frame(in: .global).height
                let width = proxy.frame(in: .global).width
                
                return AnyView(
                    ZStack {
                        BottomView(style: .systemMaterialLight)
                            .clipShape(CustomCorner(corners: [.topLeft, .topRight], radius: 30))
                        
                        if locationNotFound == true {
                            VStack {
                                Text("Tourist Locations Not Found for \(weatherMapViewModel.city)")
                                    .font(Constants.title2Text)
                                    .multilineTextAlignment(.center)
                            }
                            .padding(.top, 20)
                            .frame(maxHeight: .infinity, alignment: .top)
                        } else {
                            //Content inside bottomView
                            VStack {
                                Capsule()
                                    .fill(.black)
                                    .frame(width: 80, height: 4)
                                    .padding(.top)
                                
                                Text("Tourist Attractions in \(weatherMapViewModel.searchedCity)")
                                    .font(Constants.title2Text)
                                //                                .bold()
                                
                                ScrollView(.vertical, showsIndicators: false){
                                    ForEach(place, id: \.self) {place in
                                        
                                        VStack {
                                            Spacer()
                                            Image(place.imageNames)
                                                .resizable()
                                                .frame(width: width * 0.8, height: 200)
                                                .scaledToFit()
                                                .cornerRadius(20)
                                            Spacer()
                                            Text(place.name)
                                                .font(Constants.normalText)
                                                .bold()
                                            Text(place.description)
                                                .multilineTextAlignment(.center)
                                                .font(Constants.descriptiveText)
                                            Link(place.link, destination: URL(string: place.link)!)
                                            Spacer()
                                        }
                                        .padding()
                                        .cornerRadius(20)
                                    }
                                }
                            }
                            .frame(maxHeight: .infinity, alignment: .top)
                            //                        .padding(.bottom, 20)
                            
                        }
                    }
                    
                        .offset(y: height - 200)
                        .offset(y: -offset > 0 ? -offset <= (height - 200) ? offset : -(height - 200) : 0)
                        .gesture(DragGesture().updating($gestureOffset, body: {
                            value, out, _ in
                            
                            out = value.translation.height
                            onChange()
                        }).onEnded({ value in
                            
                            let maxHeight = height - 100
                            
                            withAnimation{
                                
                                // Logic Conditions for moving bottom sheet
                                // up down or mid
                                if -offset > 100 && -offset < maxHeight/2 {
                                    
                                    //Mid
                                    offset = -(maxHeight / 3)
                                }
                                else if -offset > maxHeight/2 {
                                    offset = -maxHeight
                                }
                                else {
                                    offset = 0
                                }
                            }
                            
                            // Storing last offset
                            lastOffset = offset
                            
                        }))
                )
            }
        }
        .onAppear {
            loadDataFromBundle()
            setPlaceData()
        }
    }
    
    func onChange() {
        DispatchQueue.main.async {
            self.offset = gestureOffset + lastOffset
        }
    }
    
    func getBlurRadius() -> CGFloat {
        
        let progress = -offset / (UIScreen.main.bounds.height - 100)
        
        return progress * 30
    }
    
    
    func loadDataFromBundle() {
        guard let fileURL =  Bundle.main.url(forResource: "places", withExtension: "json") else {
            print("not able to locate the file")
            return
        }
        
        do {
            let data = try Data(contentsOf: fileURL)
            let decodedData = try JSONDecoder().decode(MainLocationDTO.self, from: data)
            locations = decodedData.locations
            
        } catch {
            locationNotFound = true
            print("Could not able to load or decode \(locationNotFound)")
        }
        
    }
    
    func setPlaceData() {
        place = locations.filter {
            $0.cityName.lowercased() == weatherMapViewModel.city.lowercased()
        }
        if place.isEmpty {
            locationNotFound = true
        }
    }
}


#Preview {
    MapView()
        .environmentObject(WeatherMapViewModel())
}


